from config import load_config
import lichess
from urllib.parse import urljoin
import chess.pgn
import datetime
import time
import os
import sys
import getopt
import json
import chess
import chess.polyglot

__version__ = "1.0"

PARSED_OPTS={}

CONFIG = load_config(config_file)

USERNAME = CONFIG["username"]

MAX_BOOK_PLIES  = 60
MAX_VISIT_GAMES = 100000
MAX_BOOK_WEIGHT = 10000

try:
	opts, args = getopt.getopt(sys.argv[1:], "d:b", ["force"])
	for o,a in opts:
		PARSED_OPTS[o]=a
except getopt.GetoptError as err:
	print(err)
	sys.exit(2)

MINUTE = 60
HOUR = 60 * MINUTE
DAY = 24 * HOUR

SERVER_TIMESTAMP_DIFF = 2 * HOUR

def get_zobrist_key_hex(board):
	return "%0.16x" % chess.polyglot.zobrist_hash(board)

def load_json_obj(path):
	try:
		json_obj = json.load(open(path))
		#print("loaded json obj from {}".format(path))
		return json_obj
	except:
		print("{} does not exist".format(path))
	return {}

def dump_json_obj(path,json_obj,indent=None):
	with open(path, 'w') as outfile:
		json.dump(json_obj, outfile, indent=indent)

class LichessGame():
	def __init__(self,game,me=USERNAME):
		self.game=game
		self.me=me
	def get_id(self):
		url=self.game.headers["Site"]
		parts=url.split("/")
		game_id=parts[-1]
		return game_id
	def get_time(self):
		dtstr = self.game.headers["UTCDate"]+"T"+self.game.headers["UTCTime"]
		dtobj = datetime.datetime(1970,1,1)
		gamedt = dtobj.strptime(dtstr,"%Y.%m.%dT%H:%M:%S")
		return gamedt.timestamp()
	def result(self):
		return self.game.headers.get("Result", "*")
	def white(self):
		return self.game.headers.get("White", "?")
	def black(self):
		return self.game.headers.get("Black", "?")
	def score(self):
		res=self.result()
		if res=="1/2-1/2":
			return 1
		if res=="1-0":
			return 2
		return 0
	def score_me(self):
		score=self.score()		
		if self.me==self.black():
			return 2-score
		return score
	def color_me(self):
		if self.me==self.black():
			return chess.BLACK
		return chess.WHITE

def timestamp_to_filename_time(timestamp):
	timestampint=int(timestamp)
	return datetime.datetime.fromtimestamp(timestampint).strftime("%Y_%m_%d_%H_%M_%S")+"_"+str(timestampint)

def parse_datestr_as_timestamp(datestr):
	dtobj = datetime.datetime(1970,1,1)
	gamedt = dtobj.strptime(datestr,"%Y.%m.%dT%H:%M:%S")
	return gamedt.timestamp()

def epoch_timestamp():
	return parse_datestr_as_timestamp("2000.01.01T00:00:00")

def now_timestamp():
	return time.time()

def server_time(timestamp):
	return timestamp+SERVER_TIMESTAMP_DIFF

def create_dir(path):
	if not os.path.exists(path):
		os.makedirs(path)
		print("created {}".format(path))
	else:
		#print("{} exists".format(path))
		pass

def pgn_path(name):
	return os.path.join(PGN_DIR,name)+".pgn"

def get_games(li,username,queryparams={},path=None):	
	querylist=[]
	for paramkey in queryparams:
		querylist.append("{}={}".format(paramkey,queryparams[paramkey]))
	query=""
	if(len(querylist))>0:
		query="?"+"&".join(querylist)
	querypath="/games/export/{}{}".format(username,query)	
	queryurl = urljoin(li.baseUrl, querypath)
	print(queryurl)
	response = li.session.get(queryurl)
	response.raise_for_status()
	text=response.text
	if not path==None:
		with open(path,"w") as pgnfile:
			pgnfile.write(text)
	return text

PGN_DIR = USERNAME+"_pgn"

create_dir(PGN_DIR)

li = lichess.Lichess(CONFIG["token"], CONFIG["url"], __version__)

class HeaderVisitor(chess.pgn.BaseVisitor):
	def __init__(self):
		self.game = chess.pgn.Game()		

		self.variation_stack = [self.game]
		self.starting_comment = ""
		self.in_variation = False

	def visit_header(self, tagname, tagvalue):
		self.game.headers[tagname] = tagvalue

	def result(self):
		return self.game

def visit_games(path,visitor,callback):
	pgn = open(path)

	cnt=0

	while cnt<MAX_VISIT_GAMES:
		rawgame = chess.pgn.read_game(pgn,visitor)
		if rawgame==None:
			break		
		ligame = LichessGame(rawgame)
		game_id=ligame.get_id()
		timestamp=ligame.get_time()
		callback(cnt,ligame)
		cnt+=1

class GameInfo():
	def __init__(self,game_id,time,pgn_string):
		self.game_id=game_id
		self.time=time
		self.pgn_string=pgn_string

class BookMove():
	def __init__(self,uci,weight=0,plays=0):
		self.uci=uci
		self.weight=weight
		self.plays=plays

class BookPosition():
	def __init__(self,zobrist_key,fen):
		self.zobrist_key=zobrist_key
		self.fen=fen
		self.moves={}

class BuildInfo():
	def __init__(self,name=USERNAME,pgn_dir=PGN_DIR):
		self.name=name
		self.pgn_dir=pgn_dir
		self.game_ids=[]		
		self.paths=[]
		self.game_infos={}
		self.positions={}
		self.latest=epoch_timestamp()		
		self.earliest=now_timestamp()

	def all_games_path(self):
		return self.name+"_all_games.pgn"

	def polyglot_path(self):
		return self.name+".bin"

	def buildinfo_path(self):
		return self.name+"_buildinfo.json"

	def load(self):
		json_obj=load_json_obj(self.buildinfo_path())		
		for key in json_obj:
			if key=="game_ids":
				self.game_ids=json_obj[key]
			elif key=="paths":
				self.paths=json_obj[key]
			elif key=="game_infos":
				for gkey in json_obj[key]:
					gobj=json_obj[key][gkey]
					gi=GameInfo(gobj["game_id"],gobj["time"],gobj["pgn_string"])
					self.game_infos[gkey]=gi
			elif key=="positions":
				for pkey in json_obj[key]:
					pobj=json_obj[key][pkey]
					pos=BookPosition(pkey,pobj["fen"])
					for mkey in pobj["moves"]:
						mobj=pobj["moves"][mkey]
						pos.moves[mobj["uci"]]=BookMove(mobj["uci"],mobj["weight"],mobj["plays"])
					self.positions[pkey]=pos
			elif key=="latest":
				self.latest=json_obj[key]

	def save(self):
		game_infos_obj={}
		for key in self.game_infos:
			gi=self.game_infos[key]
			gobj={
				"game_id":gi.game_id,
				"time":gi.time,
				"pgn_string":gi.pgn_string
			}
			game_infos_obj[key]=gobj
		positions_obj={}
		for key in self.positions:
			pos=self.positions[key]
			mobj={}
			for mkey in pos.moves:
				bm=pos.moves[mkey]
				mobj[mkey]={
					"uci":bm.uci,
					"weight":bm.weight,
					"plays":bm.plays
				}
			positions_obj[key]={
				"zobrist_key":key,
				"fen":pos.fen,
				"moves":mobj
			}
		dump_json_obj(self.buildinfo_path(),{
			"game_ids":self.game_ids,
			"paths":self.paths,
			"game_infos":game_infos_obj,
			"positions":positions_obj,
			"latest":self.latest,
			"earliest":self.earliest
		},indent=2)

	def build_callback(self,cnt,ligame):
		game_id=ligame.get_id()
		time=ligame.get_time()
		ligame.game.headers["UTCTimeStamp"]=str(int(time))
		ligame.game.headers["GameId"]=game_id
		if game_id in self.game_ids:
			print("{} already done".format(game_id))
		else:
			print("adding {}".format(game_id))
			self.game_ids.append(game_id)
			if time>self.latest:
				self.latest=time
			if time<self.earliest:
				self.earliest=time
			exporter = chess.pgn.StringExporter(headers=True, variations=True, comments=True)
			pgn_string = ligame.game.accept(exporter)
			self.game_infos[game_id]=GameInfo(game_id,time,pgn_string)
			game=ligame.game
			board=game.board()
			score_me=ligame.score_me()
			ply=0
			zobrist_key=get_zobrist_key_hex(board)
			fen=board.fen()
			bp=BookPosition(zobrist_key,fen)					
			if zobrist_key in self.positions:
				bp=self.positions[zobrist_key]
			for move in game.main_line():
				if ply<MAX_BOOK_PLIES:
					uci=move.uci()
					fromp=board.piece_at(move.from_square)
					if fromp.piece_type==chess.KING:
						if uci=="e1g1":
							uci="e1h1"
						elif uci=="e1c1":
							uci="e1a1"
						elif uci=="e8g8":
							uci="e8h8"
						elif uci=="e8c8":
							uci="e8a8"
					bm=BookMove(uci)
					if uci in bp.moves:
						bm=bp.moves[uci]
					bm.plays+=1					
					score_corr=2-score_me
					if board.turn==ligame.color_me():
						score_corr=score_me
					if (bm.weight+score_corr)>MAX_BOOK_WEIGHT:
						for muci in bp.moves:
							if not muci==uci:
								mm=bp.moves[muci]
								mm.weight-=score_corr
								if mm.weight<0:
									mm.weight=0
					else:
						bm.weight+=score_corr
					bp.moves[uci]=bm
					self.positions[zobrist_key]=bp
					board.push(move)
					zobrist_key=get_zobrist_key_hex(board)
					fen=board.fen()
					bp=BookPosition(zobrist_key,fen)					
					if zobrist_key in self.positions:
						bp=self.positions[zobrist_key]
					ply+=1
				else:
					break			

	def sorted_game_ids(self):
		return sorted(self.game_ids,key=lambda game_id: -self.game_infos[game_id].time)

	def build(self):							
		for name in os.listdir(self.pgn_dir):
			if name.endswith(".pgn"):
				path=os.path.join(self.pgn_dir,name)
				if path in self.paths:
					#print("{} already done".format(path))
					pass
				else:
					print("building {}".format(path))
					visit_games(path,chess.pgn.GameModelCreator,self.build_callback)					
					self.paths.append(path)

		sorted_ids=self.sorted_game_ids()
		sorted_pgn_list=list(map(lambda game_id:self.game_infos[game_id].pgn_string,sorted_ids))
		joined_pgn=("\n\n\n").join(sorted_pgn_list)+"\n\n\n"
		with open(self.all_games_path(), 'w') as outfile:
			outfile.write(joined_pgn)
			print("saved all {} games to {}".format(len(sorted_ids),self.all_games_path()))
		with open(self.polyglot_path(), 'wb') as outfile:
			allentries=[]
			for zobrist_key in self.positions:				
				zbytes=bytes.fromhex(zobrist_key)				
				pos=self.positions[zobrist_key]
				for uci in pos.moves:					
					m=chess.Move.from_uci(uci)
					mi=m.to_square+(m.from_square << 6)					
					if not m.promotion==None:
						mi+=((m.promotion-1) << 12)
					mbytes=bytes.fromhex("%0.4x" % mi)										
					wbytes=bytes.fromhex("%0.4x" % pos.moves[uci].weight)					
					lbytes=bytes.fromhex("%0.8x" % 0)
					allbytes=zbytes+mbytes+wbytes+lbytes
					allentries.append(allbytes)
			sorted_weights=sorted(allentries,key=lambda entry:entry[10:12],reverse=True)
			sorted_entries=sorted(sorted_weights,key=lambda entry:entry[0:8])
			print("total of {} moves added to book {}".format(len(allentries),self.polyglot_path()))
			for entry in sorted_entries:
				outfile.write(entry)

def get_some_games(since,until,name):
	query={"since":int(server_time(since))*1000,"until":int(server_time(until))*1000}

	games=get_games(li,USERNAME,query,pgn_path(name))

def build():
	bi=BuildInfo()
	if not "--force" in PARSED_OPTS:
		bi.load()
	bi.build()			
	bi.save()

for o,a in opts:
	if o=="-d":		
		#print("download")
		bi=BuildInfo()
		bi.load()
		sincetimestamp=epoch_timestamp()
		untiltimestamp=now_timestamp()
		parts=a.split("-")		
		if len(parts)==2:			
			sincetimestamp=parse_datestr_as_timestamp(parts[0])
			untiltimestamp=parse_datestr_as_timestamp(parts[1])
		elif a=="latest":
			sincetimestamp=bi.latest
		sinceftime=timestamp_to_filename_time(sincetimestamp)
		untilftime=timestamp_to_filename_time(untiltimestamp)
		name=sinceftime+"__"+untilftime
		print("getting games [ {} ] in {}".format(a,name))
		get_some_games(sincetimestamp,untiltimestamp,name)
		build()
	elif o=="-b":
		print("build")
		build()
		pass
