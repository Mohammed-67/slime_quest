import UnityPy
import os
import json

bin_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\assets\bin\Data"

def dump_datamanager():
    # Try common assets files
    for root, dirs, files in os.walk(bin_dir):
        for f in files:
            if not (f.endswith('.assets') or f.endswith('.sharedassets')):
                continue
            path = os.path.join(root, f)
            try:
                env = UnityPy.load(path)
                for obj in env.objects:
                    if obj.type.name == "MonoBehaviour":
                        try:
                            # We can search for known field names or script name
                            d = obj.read_typetree()
                            if "MonsterData" in str(d) or "BalanceData" in str(d):
                                print(f"Dumping MonoBehaviour from {f} (PathID: {obj.path_id})")
                                with open(f"dump_{f}_{obj.path_id}.json", "w") as w:
                                    json.dump(d, w, indent=4)
                        except:
                            continue
            except:
                continue

dump_datamanager()
