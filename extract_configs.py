import UnityPy
import os
import json

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data"
os.makedirs(out_dir, exist_ok=True)

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

def save_obj(obj, category):
    try:
        data = obj.read()
        name = getattr(data, 'm_Name', f"{obj.type.name}_{obj.path_id}")
        if not name:
            name = f"{obj.type.name}_{obj.path_id}"
        
        # Clean name
        name = os.path.basename(name)
        
        path = os.path.join(out_dir, category)
        os.makedirs(path, exist_ok=True)
        
        if obj.type.name == "TextAsset":
            # For TextAssets, it can be 'script' (bytes) or 'text' (string)
            content = getattr(data, 'script', None)
            if content is None:
                content = getattr(data, 'text', b"")
            
            # If it's still string, encode to bytes
            if isinstance(content, str):
                content = content.encode('utf-8')
            
            if content:
                with open(os.path.join(path, f"{name}.txt"), "wb") as f:
                    f.write(content)
                return True
        elif obj.type.name == "MonoBehaviour":
            try:
                tree = data.read_typetree()
                with open(os.path.join(path, f"{name}.json"), "w", encoding="utf-8") as f:
                    json.dump(tree, f, indent=4, ensure_ascii=False)
                return True
            except:
                return False
    except Exception as e:
        # print(f"Error saving {obj.type.name}: {e}")
        return False
    return False

print("Scanning for data...")
for obj in env.objects:
    if obj.type.name == "TextAsset":
        save_obj(obj, "TextAssets")
    elif obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            name = getattr(data, 'm_Name', "").lower()
            if any(k in name for k in ["data", "config", "slime", "skill", "unit", "enemy", "stage", "item", "reward"]):
                save_obj(obj, "Configs")
        except:
            pass

print("Done scanning.")
