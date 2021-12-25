for file in *.pgn; do
    pgn_to_bin "${file}" > "${file%.pgn}.bin"
done
