sudo apt update && apt install -y wget python3 python3-pip p7zip-full git
python3 -m pip install --no-cache-dir -r requirements.txt
git clone https://github.com/hyperbotauthor/syzygy.git
wget --no-check-certificate -nv "https://gitlab.com/OIVAS7572/Goi5.1.bin/-/raw/MEGA/Goi5.1.bin.7z" -O Goi5.1.bin.7z \
&& 7z e Goi5.1.bin.7z && rm Goi5.1.bin.7z
bash multifish.sh
python3 lichess-bot.py -u
