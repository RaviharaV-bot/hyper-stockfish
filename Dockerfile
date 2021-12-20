FROM debian:stable-slim
MAINTAINER RAVIHARAV
RUN echo RAVIHARAV
COPY . .
COPY requirements.txt .

# If you want to run any other commands use "RUN" before.

RUN apt update > aptud.log && apt install -y wget python3 python3-pip p7zip-full > apti.log
RUN python3 -m pip install --no-cache-dir -r requirements.txt > pip.log

RUN wget --no-check-certificate -nv "https://gitlab.com/OIVAS7572/Goi5.1.bin/-/raw/MEGA/Goi5.1.bin.7z" -O Goi5.1.bin.7z \
&& 7z e Goi5.1.bin.7z && rm Goi5.1.bin.7z

#RUN wget --no-check-certificate -nv "https://abrok.eu/stockfish/builds/7262fd5d14810b7b495b5038e348a448fda1bcc3/linux64modern/stockfish_21102807_x64_modern.zip" -O chess-engine.zip \
#&& wget --no-check-certificate -nv "https://tests.stockfishchess.org/api/nn/nn-3475407dc199.nnue" -O nn-3475407dc199.nnue \
#&& 7z e chess-engine.zip && rm chess-engine.zip && mv stockfish* chess-engine
RUN wget --no-check-certificate "https://github.com/RaviharaV-bot/sfbot/raw/main/stockfish_x64_modern" -O stockfish_x64_modern
RUN wget --no-check-certificate "https://gitlab.com/OIVAS7572/Cerebellum3merge.bin/-/raw/master/Cerebellum3Merge.bin.7z" -O Cerebellum3Merge.bin.7z \
&& 7z e Cerebellum3merge.bin.7z && rm Cerebellum3merge.bin.7z
RUN wget --no-check-certificate "https://github.com/OIVAS7572/lichess-bot/raw/master/Drawkiller_EloZoom_big.bin" -O Drawkiller_EloZoom_big.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/antichess.bin" -O antichess.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/atomic.bin" -O atomic.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/horde.bin" -O horde.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/racingKings.bin" -O racingKings.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/threeCheck.bin" -O threeCheck.bin
RUN wget --no-check-certificate "https://fbserv.herokuapp.com/file/books/kingOfTheHill.bin" -O kingofthehill.bin
RUN chmod +x stockfish_x64_modern
# Engine name is here ^^^^^^

CMD python3 lichess-bot.py -u
