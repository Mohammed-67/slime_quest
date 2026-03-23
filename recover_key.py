import collections
import os

def recover_key(path):
    with open(path, 'rb') as f:
        data = f.read()
    
    key_len = 16
    recovered_key = bytearray(key_len)
    
    for i in range(key_len):
        bytes_at_pos = [data[j] for j in range(i, len(data), key_len)]
        counts = collections.Counter(bytes_at_pos)
        recovered_key[i] = counts.most_common(1)[0][0]
    
    print(f"Recovered Key: {recovered_key.hex(' ')}")
    return recovered_key

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
key = recover_key(os.path.join(db_dir, "MonsterControlData.csv"))

def decrypt(path, key_data):
    with open(path, 'rb') as f:
        data = f.read()
    decrypted = bytearray([data[i] ^ key_data[i % 16] for i in range(len(data))])
    text = decrypted.decode('utf-8', errors='ignore')
    with open(path + ".decoded", "w", encoding='utf-8') as w:
        w.write(text)
    print(f"Decoded {os.path.basename(path)}")
    print(f"Sample: {text[:64]}")

decrypt(os.path.join(db_dir, "ChapterData.csv"), key)
decrypt(os.path.join(db_dir, "MonsterData.txt"), key)
decrypt(os.path.join(db_dir, "TextData.csv"), key)
