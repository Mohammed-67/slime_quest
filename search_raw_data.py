import os

search_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\TextAssetsExports"
keywords = ["slime", "stats", "hp", "atk", "level", "stage", "chapter", "gem", "gold"]

for root, _, files in os.walk(search_dir):
    for filename in files:
        if filename.endswith(".bin"):
            path = os.path.join(root, filename)
            try:
                with open(path, "rb") as f:
                    content = f.read()
                    # Check for keywords (any case) in the binary
                    content_lower = content.lower()
                    found = [k for k in keywords if k.encode('utf-8') in content_lower]
                    if found:
                        print(f"File {filename}: {found}")
                        # Print some strings if possible
                        try:
                            # Try to decode as utf-8 but ignore errors
                            text = content.decode('utf-8', errors='ignore')
                            # Print any interesting lines (e.g. JSON-like { .. } or ID-like)
                            if "{" in text:
                                print(f"  Sample JSON: {text[text.find('{'):text.find('{')+300]}")
                        except:
                            pass
            except:
                pass
