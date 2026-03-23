import os

def brute_xor(path):
    with open(path, 'rb') as f:
        head = f.read(128)
    
    for k in range(256):
        decoded = bytes([b ^ k for b in head])
        try:
            text = decoded.decode('utf-8')
            # Check for high percentage of ASCII
            ascii_count = sum(1 for c in text if 32 <= ord(c) <= 126 or ord(c) == 10 or ord(c) == 13)
            if ascii_count > len(text) * 0.9:
                print(f"Key Found: 0x{k:02x}")
                print(f"Sample: {text[:64]}")
                return k
        except:
            continue
    return None

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
key = brute_xor(os.path.join(db_dir, "ChapterData.csv"))
if key is not None:
    print(f"FINAL KEY: 0x{key:02x}")
