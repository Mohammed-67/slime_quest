import UnityPy
import os
import json

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
out_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\data\MonoExports"
os.makedirs(out_dir, exist_ok=True)

env = UnityPy.load(apk_assets_dir)

print("Extracting strategic MonoBehaviours...")
count = 0
for obj in env.objects:
    if obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            # Check script class name
            if data.m_Script:
                script = data.m_Script.read()
                class_name = script.m_ClassName
                if any(k in class_name.lower() for k in ["data", "config", "slime", "skill", "unit", "enemy", "stage", "item", "reward"]):
                    tree = data.read_typetree()
                    name = getattr(data, 'm_Name', f"{class_name}_{obj.path_id}")
                    with open(os.path.join(out_dir, f"{name}.json"), "w", encoding="utf-8") as f:
                        json.dump(tree, f, indent=4, ensure_ascii=False)
                    count += 1
        except:
            pass

print(f"Exported {count} strategic MonoBehaviours.")
