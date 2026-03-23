import UnityPy
import os

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

mono_names = set()
count = 0
for obj in env.objects:
    if obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            name = getattr(data, 'name', getattr(data, 'm_Name', None))
            if name:
                mono_names.add(name)
        except:
            pass
        count += 1
        if count % 5000 == 0:
            print(f"Processed {count} MonoBehaviours...")

print("\n--- Unique MonoBehaviour Names (First 200) ---")
sorted_names = sorted(list(mono_names))
for name in sorted_names[:200]:
    print(name)

print(f"\nTotal unique Mono names found: {len(sorted_names)}")
