import os
import json
import re

search_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports"
out_spine = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\spine"
os.makedirs(out_spine, exist_ok=True)

def find_name(content):
    # Try to find a printable string in the first 128 bytes
    try:
        # First 4 bytes are often name length
        length = int.from_bytes(content[0:4], "little")
        if 2 < length < 100:
            name = content[4:4+length].decode('utf-8', errors='ignore')
            if name.isprintable():
                return name
    except:
        pass
    return None

for filename in os.listdir(search_dir):
    if filename.endswith(".bin"):
        path = os.path.join(search_dir, filename)
        with open(path, "rb") as f:
            content = f.read()
            
            # Find Spine JSON
            if b'"spine":' in content:
                name = find_name(content) or f"spine_{filename[:-4]}"
                # Clean name (remove extension if included)
                name = name.split(".")[0]
                
                # Extract the JSON part
                start = content.find(b'{')
                if start != -1:
                    json_data = content[start:]
                    # Try to save as JSON
                    try:
                        with open(os.path.join(out_spine, f"{name}.json"), "wb") as out:
                            out.write(json_data)
                    except:
                        pass
            
            # Find Atlas
            elif b'size: ' in content and b'format: ' in content:
                name = find_name(content) or f"atlas_{filename[:-4]}"
                name = name.split(".")[0]
                
                # Extract atlas part (skipping name)
                # Atlas often starts with some metadata but we want the text
                start = content.find(b'\n')
                # If first lines contain .png, it's definitely an atlas
                if b'.png' in content[:500]:
                    # Find first line that looks like an atlas header (no spaces)
                    lines = content.split(b'\n')
                    atlas_lines = []
                    found_atlas = False
                    for line in lines:
                        if b'.png' in line or b'size:' in line:
                            found_atlas = True
                        if found_atlas:
                            atlas_lines.append(line)
                    
                    if atlas_lines:
                        with open(os.path.join(out_spine, f"{name}.atlas"), b"\n".join(atlas_lines)):
                             pass # Fixed below
                             
# Fix the atlas write logic
print("Scanning for Spine files...")
for filename in os.listdir(search_dir):
    if filename.endswith(".bin"):
        path = os.path.join(search_dir, filename)
        with open(path, "rb") as f:
            content = f.read()
            name = find_name(content)
            if not name: continue
            name = name.replace("\x00", "").strip()
            # Remove any trailing junk
            name = "".join(c for c in name if c.isalnum() or c in "._-")
            
            path_name = os.path.join(out_spine, name)
            
            if b'"spine":' in content:
                start = content.find(b'{')
                if start != -1:
                    with open(path_name if "." in name else f"{path_name}.json", "wb") as out:
                        out.write(content[start:])
            elif b'size: ' in content[:500] and b'.png' in content[:500]:
                # Find the actual start of atlas text (usually after the name)
                # Atlas text starts with a filename usually.
                # Let's just save from the newline after the name.
                try:
                    # Skip the first bytes that contain name/header
                    header_len = int.from_bytes(content[0:4], "little")
                    atlas_text = content[4+header_len+4:] # Skip 4 for data len too?
                    # Unity's structure for TextAsset: NameLen(4), Name(N), DataLen(4), Data(M)
                    datalen_pos = 4 + header_len
                    # Pad to 4 bytes alignment if needed? Usually not for strings.
                    # Actually let's just find the first .png and go back 1 line.
                    pos = content.find(b".png")
                    if pos != -1:
                        # Find start of line
                        while pos > 0 and content[pos] != 10: # \n
                            pos -= 1
                        with open(path_name if "." in name else f"{path_name}.atlas", "wb") as out:
                            out.write(content[pos+1:])
                except:
                    pass

print("Spine extraction complete.")
