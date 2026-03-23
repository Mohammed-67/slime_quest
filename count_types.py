import UnityPy
from collections import Counter

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

type_counts = Counter()
for obj in env.objects:
    type_counts[obj.type.name] += 1

print("\n--- Asset Counts by Type ---")
for type_name, count in sorted(type_counts.items(), key=lambda x: x[1], reverse=True):
    print(f"{type_name}: {count}")
