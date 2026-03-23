import os

def try_increment_xor(path):
    with open(path, 'rb') as f:
        data = f.read(128)
    
    # Try XORing with i
    dec = bytes([data[i] ^ i for i in range(len(data))])
    print(f"File: {os.path.basename(path)}")
    print(f"XOR with i Sample: {dec.decode('utf-8', errors='ignore')[:64]}")

    # Try XORing with (data[i] - i) % 256
    dec2 = bytes([(data[i] - i) % 256 for i in range(len(data))])
    print(f"Sub i Sample: {dec2.decode('utf-8', errors='ignore')[:64]}")

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
try_increment_xor(os.path.join(db_dir, "MonsterControlData.csv"))
