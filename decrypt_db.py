import os

key_hex = "33 37 75 32 38 79 50 72 31 73 76 79 39 79 38 63"
key = bytes.fromhex(key_hex)

def decrypt(path, out_path):
    with open(path, 'rb') as f:
        data = f.read()
    
    decrypted = bytearray()
    for i in range(len(data)):
        decrypted.append(data[i] ^ key[i % 16])
    
    try:
        text = decrypted.decode('utf-8', errors='ignore')
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(text)
        print(f"Decrypted: {os.path.basename(path)} -> {os.path.basename(out_path)}")
        print(f"Sample: {text[:100]}")
    except Exception as e:
        print(f"Error decrypting {path}: {e}")

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database_plain"
os.makedirs(out_dir, exist_ok=True)

decrypt(os.path.join(db_dir, "ChapterData.csv"), os.path.join(out_dir, "ChapterData.csv"))
decrypt(os.path.join(db_dir, "MonsterData.txt"), os.path.join(out_dir, "MonsterData.csv"))
decrypt(os.path.join(db_dir, "TextData.csv"), os.path.join(out_dir, "TextData.csv"))
decrypt(os.path.join(db_dir, "PlayerLevelData.csv"), os.path.join(out_dir, "PlayerLevelData.csv"))
decrypt(os.path.join(db_dir, "MonsterControlData.csv"), os.path.join(out_dir, "MonsterControlData.csv"))
