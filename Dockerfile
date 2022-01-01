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
RUN wget --no-check-certificate "https://drive.google.com/u/0/uc?export=download&confirm=fqxB&id=1HJTooTmu5FNFYKfngNomBhuMp1FRpzes" -O syzygy.zip
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
