
while IFS= read -r line; do
    echo "Received: $line"
done

perl /home/admin/nvim/dev/latex-writer/src/tex2utf.pl < <(echo "$1")
