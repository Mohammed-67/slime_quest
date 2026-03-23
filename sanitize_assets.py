import os
import re

def sanitize_filename(name):
    # Replace non-ascii and special chars with underscores
    new_name = re.sub(r'[^\x00-\x7F]+', '_', name)
    # Also handle some problematic windows characters if any
    new_name = new_name.replace(' ', '_').replace('%', '_')
    return new_name

def rename_assets(directory):
    for root, dirs, files in os.walk(directory):
        for f in files:
            new_f = sanitize_filename(f)
            if new_f != f:
                old_path = os.path.join(root, f)
                new_path = os.path.join(root, new_f)
                try:
                    # If new file already exists, add index
                    if os.path.exists(new_path):
                        base, ext = os.path.splitext(new_f)
                        new_path = os.path.join(root, f"{base}_alt{ext}")
                    
                    print(f"Renaming: {f} -> {os.path.basename(new_path)}")
                    os.rename(old_path, new_path)
                except Exception as e:
                    print(f"Error renaming {f}: {e}")

assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets"
rename_assets(assets_dir)
print("Finished Sanitizing Assets Filenames.")
