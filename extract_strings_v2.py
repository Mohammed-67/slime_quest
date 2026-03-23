path = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports\Raw_697.bin"
out_txt = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\database_strings.txt"

with open(path, "rb") as f:
    data = f.read()
    strings = []
    current = []
    for b in data:
        if 32 <= b <= 126:
            current.append(chr(b))
        else:
            if len(current) >= 4:
                strings.append("".join(current))
            current = []
            
    with open(out_txt, "w", encoding="utf-8") as out:
        for s in strings:
            out.write(s + "\n")

print(f"Manual scan: {len(strings)} strings.")
