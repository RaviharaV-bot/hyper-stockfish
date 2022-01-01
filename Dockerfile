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
RUN wget --no-check-certificate "https://public.dm.files.1drv.com/y4mQ8esgbF65__EizzBeD-SGVypOt19-g3ADbCcrAYXM0w01hYkV29A6fPnJ8WzI_DdIeny1MLhyvLnwkut95Oe2-G52IWdY2xcAtklEsEICGS5PwOp76-Oma4JZsbbv4X3gdvvFkEQMD4UYKQYqDPZHroQXIVj1EAl8N7HGXXK_TspSbZHocVDsIx3oYA2c5Hfu_JOAClCdD8lFL41xqlcLfIW7qEYnX9QJa7ct6ImBQA?access_token=EwAIA61DBAAU2kADSankulnKv2PwDjfenppNXFIAAaJs0v7HbhvDVdvPiV26S007VKpQ4bbySE0ka9zpJxgQQQnaVug%2bTAf9%2bKM6LmW6TOlTwF6StOLMBrgta3EIc%2bdorRU/Uaujnl84s3aruJbZrjMmxLfU5nD%2bS6dOc2NtECVZiciddjDR7bqZM7rrUR87cJBaPlPaFUSGU9TDuALhqgute0zYcnv9NFMMzV5VFFu72A16C6W9aidYamrn78ShaDrIxfuToelVRNkN9EbNUZfzmKneAzcwBoAQWI%2buAlIilehY9LSa1/cSsJZlfuadD0On2C3Hm9xhQH2TqcX9rJ9VDb5hsqQJvk5lPi/LQK2w/0YoiOaCmI5nUyAg8ikDZgAACHXDVOUVSg1V2AG9a2U46shCUiD6Vlac5AOzONYJ0h9hexNUdWMqQXnywb0tMgq4kCaqU0B/MMOz0YPgs%2bN559HwxWmnXkD4NoVUBoK69pJQvIAjwmhHf3WUg/ygrz9mquyLePlOmzepwxtB2Jn4QJYSNTaQqjiCYXjFiMWsDizKU2SFP9VjJkKWi8uTcz6gQRa/eV5OWW10UWTozOTJaoRiwl25Mgu4nq2J8IPEBvVjUZm6Pj6IbV55eVrfIlJbpD1e7inLknp8VY5o3b5ZsLAze7jMb1KlGpXf54dPPCURAmycfBtKvCPI/mM8N2UYVeOZ%2biyUd2W5DW4%2bghdaHbAt1nNC8cnq%2bgc7iyJPM6lZRmr/WbWYG8zWO2s9GwzkFAy0bGHvo9iXTlB3KvyN/QXfL1RNVaZ7M7uHCcTSk6sDlEsk1EUDzfnXlpFExl3cp7RVP1SVC48lO2D3St2qEiSUymZJensE2V/RspZyHTo6lFoSy2z9NMsHNLQHHjPu2qoTzm1L9yIZiNe9ZwudUgHVGIQ0rLm94vZhAMOobJ9%2b/I2xHHFgstkdpjcVv0Q9Zy2L9N5PIEDG71LkqGH1p/XTOHUYz66tPlS8SVDaQk/4qDRj7%2b3ZuxrfuKSsgZvo23PRCgI%3d" -O syzygy.zip
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
