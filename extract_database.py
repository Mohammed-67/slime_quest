import os
import struct
import re

raw_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\game_database"
os.makedirs(out_dir, exist_ok=True)

target_keywords = ["Data", "Balance", "Chapter", "Monster", "Player", "Reward", "Shop", "TextData"]

print("Extracting game database from raw blobs...")

for filename in os.listdir(raw_dir):
    if not filename.endswith(".bin"):
        continue
    
    path = os.path.join(raw_dir, filename)
    with open(path, "rb") as f:
        content = f.read()
    
    try:
        if len(content) < 4: continue
        name_len = struct.unpack("<I", content[:4])[0]
        if 0 < name_len < 256 and len(content) >= 4 + name_len + 4:
            name = content[4:4+name_len].decode('utf-8', errors='ignore')
            
            # Filter for database files
            if any(k in name for k in target_keywords):
                data_len_pos = 4 + name_len
                padding = (4 - (name_len % 4)) % 4
                data_len_pos += padding
                
                if len(content) >= data_len_pos + 4:
                    data_len = struct.unpack("<I", content[data_len_pos:data_len_pos+4])[0]
                    actual_data = content[data_len_pos+4:data_len_pos+4+data_len]
                    
                    # Determine extension (csv? json? txt?)
                    sample = actual_data[:100].decode('utf-8', errors='ignore')
                    if sample.startswith("{") or sample.startswith("["):
                        ext = ".json"
                    elif "," in sample or "\t" in sample:
                        ext = ".csv"
                    else:
                        ext = ".txt"
                    
                    with open(os.path.join(out_dir, name + ext), "wb") as f_out:
                        f_out.write(actual_data)
                    print(f"Extracted: {name}{ext}")

    except:
        pass

print("Database extraction complete.")
