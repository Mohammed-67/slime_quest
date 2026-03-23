import os
import re

def sanitize_filename(name):
    return re.sub(r'[^\x00-\x7F]+', '_', name).replace(' ', '_').replace('%', '_')

def fix_dart_files(directory):
    count = 0
    for root, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                # regex that matches any string literal (single or double quote) containing non-ascii
                new_content = re.sub(r"'[^']*'|\"[^\"]*\"", 
                                     lambda m: sanitize_filename(m.group(0)) if any(ord(c) > 127 for c in m.group(0)) else m.group(0), 
                                     content)
                
                if new_content != content:
                    print(f"Fixed: {f}")
                    with open(path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                    count += 1
    print(f"Total files fixed: {count}")

lib_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\lib"
fix_dart_files(lib_dir)
