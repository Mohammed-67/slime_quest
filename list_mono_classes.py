import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

class_counts = {}
count = 0
for obj in env.objects:
    if obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            if data.m_Script:
                script = data.m_Script.read()
                class_name = script.m_ClassName
                class_counts[class_name] = class_counts.get(class_name, 0) + 1
        except:
            pass
        count += 1
        if count % 5000 == 0:
            print(f"Processed {count} MonoBehaviours...")

print("\n--- MonoBehaviour Class Counts ---")
total_classes = 0
for class_name, num in sorted(class_counts.items(), key=lambda x: x[1], reverse=True):
    print(f"{class_name}: {num}")
    total_classes += 1

print(f"\nTotal classes found: {total_classes}")
