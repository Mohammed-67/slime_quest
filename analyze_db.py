import os

def check_file(path):
    with open(path, 'rb') as f:
        head = f.read(128)
        print(f"File: {os.path.basename(path)}")
        print(f"Hex: {head.hex(' ')}")
        # Check for common patterns
        # If it starts with 0xEFBBBF, it's UTF-8 with BOM
        # If it starts with 0xFFFE, it's UTF-16
        # If it looks like XOR, we'll try to guess key
        try:
            print(f"Text (utf-8): {head.decode('utf-8', errors='ignore')}")
        except:
            pass

db_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
check_file(os.path.join(db_dir, "ChapterData.csv"))
check_file(os.path.join(db_dir, "TextData.csv"))
check_file(os.path.join(db_dir, "MonsterData.txt"))
