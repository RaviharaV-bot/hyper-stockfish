for f in *.pgn
    do
    f1="${f%.pgn}"
    polyglot make-book -pgn "$f" -bin "$f1".bin -min-game 1
    done
