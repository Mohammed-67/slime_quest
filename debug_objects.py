import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

print("\n--- First 100 Objects ---")
for i, obj in enumerate(env.objects):
    print(f"Index {i}: ClassID {obj.type} - TypeName {obj.type.name}")
    if i >= 100:
        break
