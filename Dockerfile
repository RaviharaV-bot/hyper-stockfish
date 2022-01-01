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
RUN wget --no-check-certificate "https://public.dm.files.1drv.com/y4mHKq7l1mcorwlkaSq5wWs_011wElLh1GneoOXEgL938Fz2slEUwpYqC3_-OWLhpRJjyoYMZPeafsJcuR1taeJ684b1HaL5ddcSAnC-L-Ckufcx_OxV2jWOiFPSKd8h5m65-dke3TDoK6Y37S0vgoaFMUrE-6qdzmKrDmnEJzMzCmX0izR-CzxKvJ8RpwNNxglPmxm7C9FWvrFr9lknzHyFatgoJjR_B1qEX7USLH1ROE?access_token=EwAAA61DBAAU2kADSankulnKv2PwDjfenppNXFIAAUY%2btGJK/HNRS4jdI7ofqd5Yl0POo8ZmAW0KOs0tA55YwUpfnNGIukUTiH7YOrxD9A6aZrtS8H6mtu8Krv98K8P6CSgui6LQ1ZidqpmKzv%2bn1Fx1Jnjgql/S7ua3XeW6yvjTzJIwZA4OEzksE6FeVyZuOsEhnq6SoPs3M34YojO7jCSNzbG8iXcTPA2ADcUVGqqfd6OnPpGGwdMWz07JtkZ2WSsbdvex2pbJXlG0WHRN3Ltrcm2Ucyo%2bJsLTETAG4XfAzwz54u2I70c7xvHI8Alx/2dU6PcEuZg5bfMhmqNYBTrF4ocn%2bfOnXD9YdxhcHdt97UioSqR7JgTpQdQUd5cDZgAACFnfVS0nSZGm0AE9r5iBrgW%2bWPoeiVcSDvRRBsr0BR9uLQVTjcDa30TVdk2UpFD4B1rEF3wIhT5AG%2bOZG5BH7TIH6dOEtv1rVg7F4mq3mCj7BT2bB%2bgF8JM3eaqrOX6RWvV5CAKdjnzcxVB1BdU2SJKqjshhi6exrxbVpjyOceKyPtQL83dtW6ob87zXYZLLRHcXTWBUAz9NezK5X9wj5XY2lsdP/3JbdmyBjY3/3RwctdvkyYoygFSa0%2bwhQklOuji/EvC%2byc/ln15j6eUWOb7guz4zbTEl2Iqa3E2Ig9cSwXLVOsagIickBz9K8dAQpXLg12ZoC/SxEU6ksHq%2bJiWg/vmr3/WOM%2bJqy5qb6%2b3T/OCDXVBgtL4DqW3JMA9P5892EcVfqUlVr%2b253qhEwhF7VnvrCjH3pksLL9llBez8qomQhaA6ASH%2br7o/0cMfG%2bNJHPXV056Sue/2X/ZPllbnsZenNEwVWsFHSDiyJwqbNIwbCGELzX5IHCwwk7JdC1twzm%2bbED9YP27gty6GZvoXXfyxfppMf6ySC/lk1JMp83eG7FP5h2A8hYi6b1Anz2%2b1gPM%2bmAk2SSy4i7dbrzY2XxE7QHxMZiaU3Jnkfoms7eoNyKD61SEwRgoC" -O syzygy.zip
RUN unzip syzygy.zip

#engine section
RUN chmod +x sf
RUN chmod +x msf

#start bot
CMD python3 lichess-bot.py -u
