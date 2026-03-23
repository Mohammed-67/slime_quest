import os
import re

raw_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\extracted_spine"
os.makedirs(out_dir, exist_ok=True)

print("Decoding Spine assets from raw blobs...")

for filename in os.listdir(raw_dir):
    if not filename.endswith(".bin"):
        continue
    
    path = os.path.join(raw_dir, filename)
    with open(path, "rb") as f:
        content = f.read()
    
    # Unity TextAsset binary structure:
    # 4 bytes: Name Length
    # N bytes: Name
    # 4 bytes: Data Length
    # M bytes: Data
    
    try:
        if len(content) < 4: continue
        
        # Read name length
        import struct
        name_len = struct.unpack("<I", content[:4])[0]
        if 0 < name_len < 128 and len(content) >= 4 + name_len + 4:
            name = content[4:4+name_len].decode('utf-8', errors='ignore')
            data_len_pos = 4 + name_len
            # In some Unity versions there is 0-3 padding bytes to align to 4
            padding = (4 - (name_len % 4)) % 4
            data_len_pos += padding
            
            if len(content) >= data_len_pos + 4:
                data_len = struct.unpack("<I", content[data_len_pos:data_len_pos+4])[0]
                actual_data = content[data_len_pos+4:data_len_pos+4+data_len]
                
                # Check if it's Spine or Atlas
                header = actual_data[:100].decode('utf-8', errors='ignore')
                
                if ".png" in header or "size:" in header or "format:" in header:
                    ext = ".atlas"
                elif "\"spine\"" in header or "\"skeleton\"" in header:
                    ext = ".json"
                else:
                    # Generic text asset
                    ext = ".txt"
                
                clean_name = re.sub(r'[^\w\-_\.]', '_', name)
                with open(os.path.join(out_dir, clean_name + ext), "wb") as f_out:
                    f_out.write(actual_data)
                # print(f"Saved {name}{ext}")

    except Exception as e:
        # print(f"Error decoding {filename}: {e}")
        pass

print("Spine/Text extraction complete.")
