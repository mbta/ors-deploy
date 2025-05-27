#!/usr/bin/env bash

input_file="$1"
xmllint --xpath '//modify/way/tag[@k="name"]/@v' "$input_file" | sort -u | sed 's/ v="//g' | sed 's/"//g' > names.txt

while read -r name; do
  timestamp=$(date -Iseconds -u)
  xmllint_string="//modify/way[tag[@k='name' and @v='$name']]"
  {
    head -n 4 "$input_file"
    xmllint --xpath "${xmllint_string}" "$input_file"
    echo "  </modify>"
    echo "</osmChange>"
  } > "..//${timestamp}_${name// /_}.osc"
done < names.txt

rm names.txt
rm "$input_file"
