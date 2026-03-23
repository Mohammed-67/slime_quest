import UnityPy
import os

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data/TextAssetsExports"
os.makedirs(out_dir, exist_ok=True)

env = UnityPy.load(apk_assets_dir)

print("Scanning for TextAssets (Class ID 49)...")
count = 0
for obj in env.objects:
    if obj.type.name == "TextAsset" or obj.class_id == 49:
        try:
            # Try to get raw data if regular script attribute is missing
            raw = obj.get_raw_data()
            # The first 4 bytes are often the name length, and then the name, and then the data.
            # But let's just save the whole thing.
            with open(os.path.join(out_dir, f"Raw_{obj.path_id}.bin"), "wb") as f:
                f.write(raw)
            count += 1
        except:
            pass

print(f"Exported {count} raw TextAssets.")
