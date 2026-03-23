import UnityPy
import os

assets_path = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\bin\Data\data.unity3d" # or similar
# Better search all .assets files
bin_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\bin\Data"

def find_monster_data():
    for root, dirs, files in os.walk(bin_dir):
        for f in files:
            if f.endswith('.assets') or f.endswith('.sharedassets') or f.endswith('.unity38'):
                path = os.path.join(root, f)
                try:
                    env = UnityPy.load(path)
                    for obj in env.objects:
                        if obj.type.name == "TextAsset" and "MonsterData" in (obj.read().name):
                            print(f"Found MonsterData TextAsset in {f}")
                            data = obj.read().script
                            with open(f"monster_raw.bin", "wb") as w:
                                w.write(data)
                            return
                        if obj.type.name == "MonoBehaviour":
                            # Check scripts name
                            try:
                                d = obj.read_typetree()
                                if "MonsterData" in str(d):
                                    print(f"Found MonsterData MonoBehaviour in {f}")
                                    import json
                                    with open("monster_json.json", "w") as w:
                                        json.dump(d, w, indent=4)
                                    return
                            except:
                                continue
                except:
                    continue

find_monster_data()
