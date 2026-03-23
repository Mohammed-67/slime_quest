import os
import re

def repair_dart(directory):
    for root, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                # Replace multiple underscores with spaces if they are at the start of a line or after a comma
                new_content = re.sub(r'(_+)([a-zA-Z])', r' \2', content) # _style ->  style
                new_content = re.sub(r'([,{])(\s*)_+', r'\1\2 ', new_content)
                new_content = re.sub(r'^_+', lambda m: ' ' * len(m.group(0)), new_content, flags=re.M)
                
                # Specific common damage fixes
                new_content = new_content.replace('_style:_', ' style: ')
                new_content = new_content.replace('(_style:', '(style:')
                new_content = new_content.replace('(_9)', '(9)')
                new_content = new_content.replace('(_8)', '(8)')
                new_content = new_content.replace('const_SizedBox', 'const SizedBox')
                new_content = new_content.replace('EdgeInsets.only(bottom:_6)', 'EdgeInsets.only(bottom: 6)')
                
                if new_content != content:
                    print(f"Repaired: {f}")
                    with open(path, 'w', encoding='utf-8') as file:
                        file.write(new_content)

lib_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\lib"
repair_dart(lib_dir)
print("Finished repairing Dart files.")
