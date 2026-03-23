import collections
import os

def find_key(path):
    with open(path, 'rb') as f:
        data = f.read()
    
    # Check blocks of 16
    blocks = [data[i:i+16] for i in range(0, len(data) - 16, 16)]
    counts = collections.Counter(blocks)
    most_common = counts.most_common(5)
    print(f"File: {os.path.basename(path)}")
    for b, c in most_common:
        print(f"Count: {c}, Hex: {b.hex(' ')}")

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
find_key(os.path.join(db_dir, "MonsterControlData.csv"))
find_key(os.path.join(db_dir, "TextData.csv"))
