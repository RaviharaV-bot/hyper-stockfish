FROM debian:stable-slim
MAINTAINER RAVIHARAV
RUN echo RAVIHARAV
COPY . .
COPY requirements.txt .

# If you want to run any other commands use "RUN" before.
 #install wanted packages
RUN apt update > aptud.log && apt install -y wget python3 python3-pip p7zip-full unzip > apti.log
RUN python3 -m pip install --no-cache-dir -r requirements.txt > pip.log

#add books in .7z format
RUN wget --no-check-certificate -nv "https://gitlab.com/OIVAS7572/Goi5.1.bin/-/raw/MEGA/Goi5.1.bin.7z" -O Goi5.1.bin.7z \
&& 7z e Goi5.1.bin.7z && rm Goi5.1.bin.7z
RUN wget --no-check-certificate -nv "https://gitlab.com/OIVAS7572/Cerebellum3merge.bin/-/raw/master/Cerebellum3Merge.bin.7z" -O Cerebellum3merge.bin.7z \
&& 7z e Cerebellum3merge.bin.7z && rm Cerebellum3merge.bin.7z

#add variant books and other books
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/antichess.bin" -O antichess.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/atomic.bin" -O atomic.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/horde.bin" -O horde.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/racingKings.bin" -O racingKings.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/threeCheck.bin" -O threeCheck.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/kingOfTheHill.bin" -O kingofthehill.bin

#syzygy tablebase 5 pices
RUN wget --no-check-certificate "https://public.dm.files.1drv.com/y4mEojrBlwhk79vwi44xyFPDIaFigAjK4Yl7RQ8qpJfsjm3swpYRfEzLLljH6wL08SCUYdN1PD1t1gHAluE-KNMIl90YDX7KgYmeN9iqryjrP3VynPoz8yrATl7o6g-MYZwTtNWbYSkKNxkfY2kLNO70ocRN1tlsAwXrCm2CGGxpY13DTNNFiirnCMvgUKP20gmQ57T-o-g9rGGW2muSelBwhNjNXJHlVPl9uq0qmI40tk?access_token=EwAAA61DBAAU2kADSankulnKv2PwDjfenppNXFIAAcwCxFCAIUFL15UmmYKLY90uz5cHXsbF53tlrkzcXiQT2mC6wkC8jnWHQR4AGudjGRqy6hTnGEE7GC5GEHhH54apA087CH2tUny66fXDjMRaTCtWmVeEZ/90ldS%2bN1xaw0Qnr2x63n4m%2bvZ343ECNukvejzouGU49BRsh0184ed0%2bnz8BLFWbYp9t8LJnda2eXN/bfuG4YWWsPv/5o405RE634JLIJsReIg1G0MWz5E60H7Thr4671NFBsjyG%2bFZ3FgPII6GhrHJ%2bO0oDjcsyBo%2b/DT%2bZQqW%2bnpEwUDvgE2Ki6x3ZXDgYSh8BPBTBAoT9X0vq9IO29lOD0MDz4iBUDoDZgAACLhB0dWMK8Fs0AEZs1gmHaYw1mY4H2tSxtB6XnD8WkxkSpGeDmEzIIcaSOIPLkY51czdy0hIERcjNiadAgLyxGkIofU3xXB3O1nLvt%2bomKevg3TGhuHi0J44zOnU7XxK5TQY2inimhwnb/ubMjT%2bhr7uiCIGku53W0Y3vEnYK9kZEOu%2bJGjb2/LD/NyD0u2gzqMPor70gH%2bwpPru9uXjzt2rrBzPwYkrJwLjBag9NKRAa38SxA%2bt/E0DRBzQcF%2by3luzTNz1jIN2nFkiz4riM53U/2dyUD3eSjzATn05KDIg4Wil2bSNN%2bNsC1Uaqjb/1L5Vt8YrZQCi9d/HKCAnsWf65/OvbpQdnawp1WRtOzT2zsbJP861chtDMIIYM1RXOMR%2bClxI4HqgD%2bk%2beAy1uIQljYqwJPX8CqtcJAzrV6fB3iztlHlOJlusQZR9vkuOKOp7MUvAVrZ6Zx/j1/WckbauyPubGSEhChcGIINr9xuzsGiXWsH3vmecu1aYHL7HO0YE16owCzonraEKNK1Me8oeByNq9sxkNhcUDPiRXvjjo%2bGpQvkwdUPW7FOZwszdGuV70k5VTCTPz5r9HP/e2LxvxhrOebo2ADu4KSLF7bXURD55RUE7oBYrxgoC" -O syzygy.zip
RUN unzip syzygy.zip

#engine section
RUN chmod +x sf
RUN chmod +x msf

#start bot
CMD python3 lichess-bot.py -u
