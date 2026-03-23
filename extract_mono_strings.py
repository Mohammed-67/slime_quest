import UnityPy
import re

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
env = UnityPy.load(apk_assets_dir)

all_strings = set()
print("Scanning for strings in all MonoBehaviours...")

for obj in env.objects:
    if obj.type.name == "MonoBehaviour":
        try:
            # Get raw data and scan for strings
            raw = obj.get_raw_data()
            matches = re.findall(b'[\x20-\x7E]{4,}', raw)
            for m in matches:
                try:
                   s = m.decode('utf-8').strip()
                   if s: all_strings.add(s)
                except: pass
        except:
            pass

print(f"Total strings found: {len(all_strings)}")
with open("extracted_strings.txt", "w", encoding="utf-8") as f:
    for s in sorted(list(all_strings)):
        f.write(s + "\n")
