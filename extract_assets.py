import os
import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets"

os.makedirs(os.path.join(out_dir, "images"), exist_ok=True)
os.makedirs(os.path.join(out_dir, "audio"), exist_ok=True)
os.makedirs(os.path.join(out_dir, "data"), exist_ok=True)
os.makedirs(os.path.join(out_dir, "fonts"), exist_ok=True)

print("Loading Unity assets from:", apk_assets_dir)
env = UnityPy.load(apk_assets_dir)
print(f"Loaded {len(env.objects)} objects.")

extracted_images = 0
extracted_audio = 0
extracted_data = 0

for obj in env.objects:
    if obj.type.name in ["Texture2D", "Sprite"]:
        pass
    elif obj.type.name == "AudioClip":
        pass
    elif obj.type.name == "TextAsset":
        try:
            data = obj.read()
            filename = getattr(data, 'name', getattr(data, 'm_Name', getattr(obj, "container", None)))
            if not filename:
                filename = f"TextAsset_{extracted_data}"
            else:
                filename = os.path.basename(filename)
                
            with open(os.path.join(out_dir, "data", f"{filename}.txt"), "wb") as f:
                f.write(data.script)
                extracted_data += 1
        except Exception as e:
            print(f"Text error: {e}")
    elif obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            filename = getattr(data, 'name', getattr(data, 'm_Name', getattr(obj, "container", None)))
            # Only extract named config/ScriptableObjects
            if filename and filename != "MonoBehaviour":
                import json
                filename = os.path.basename(filename)
                tree = data.read_typetree()
                with open(os.path.join(out_dir, "data", f"{filename}.json"), "w", encoding="utf-8") as f:
                    json.dump(tree, f, indent=4, ensure_ascii=False)
                extracted_data += 1
        except Exception as e:
            if "has no attribute" not in str(e):
                print(f"Mono error: {e}")

print(f"Extraction complete!")
print(f"Images extracted: {extracted_images}")
print(f"Audio files extracted: {extracted_audio}")
print(f"Data files extracted: {extracted_data}")
