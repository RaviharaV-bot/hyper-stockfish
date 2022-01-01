FROM debian:stable-slim
MAINTAINER RAVIHARAV
RUN echo RAVIHARAV
COPY . .
COPY requirements.txt .

# If you want to run any other commands use "RUN" before.
 #install wanted packages
RUN apt update > aptud.log && apt install -y wget python3 python3-pip p7zip-full unzip > apti.log
RUN python3 -m pip install --no-cache-dir -r requirements.txt > pip.log

#syzygy tablebase 5 pices
RUN wget --no-check-certificate "https://doc-0c-4k-docs.googleusercontent.com/docs/securesc/6u8jf8lp1a9uf1g9bt2vflfpf22imeij/4m86u8uddaco8pmc3l5svpskph9jk2qa/1641044925000/11706750457809039325/11706750457809039325/1HJTooTmu5FNFYKfngNomBhuMp1FRpzes?e=download&authuser=0&nonce=knnvitumu07mm&user=11706750457809039325&hash=qimkif537cbli9h6tbmo6qv92mm02snf" -O syzygy.zip
RUN unzip syzygy.zip

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

#engine section
RUN chmod +x sf
RUN chmod +x msf

#start bot
CMD python3 lichess-bot.py -u
