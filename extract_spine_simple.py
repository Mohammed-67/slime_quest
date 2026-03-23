import os

search_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports"
out_spine = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\spine"
os.makedirs(out_spine, exist_ok=True)

for filename in os.listdir(search_dir):
    if filename.endswith(".bin"):
        path = os.path.join(search_dir, filename)
        with open(path, "rb") as f:
            data = f.read()
            # Find the first .json or .atlas or .png in the file name part
            # Or just use the path_id if name is not found
            name = f"obj_{filename[:-4]}" 
            
            # Simple signature search
            if b'"spine":' in data:
                start = data.find(b'{')
                if start != -1:
                    with open(os.path.join(out_spine, f"{name}.json"), "wb") as out:
                        out.write(data[start:])
            elif b'size: ' in data:
                pos = data.find(b".png")
                if pos != -1:
                    # Find start of line
                    while pos > 0 and data[pos] != 10: pos -= 1
                    with open(os.path.join(out_spine, f"{name}.atlas"), "wb") as out:
                        out.write(data[pos+1:])

print("Simplified spine extraction complete.")
