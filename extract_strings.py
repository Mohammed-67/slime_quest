import os
import re

path = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports\Raw_697.bin"
out_txt = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\database_strings.txt"

with open(path, "rb") as f:
    data = f.read()
    # Find all printable strings of length 4+
    strings = re.findall(b"[\x20\x2d-\x7e]{4,}", data)
    
    with open(out_txt, "w", encoding="utf-8") as out:
        for s in strings:
            try:
                out.write(s.decode('utf-8') + "\n")
            except:
                pass

print(f"Extracted {len(strings)} strings to database_strings.txt")
