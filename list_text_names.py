import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
env = UnityPy.load(apk_assets_dir)

text_names = []
for obj in env.objects:
    if obj.type.name == "TextAsset":
        try:
            data = obj.read()
            text_names.append(data.m_Name)
        except:
            pass

print("\n--- Text Asset Names ---")
for name in sorted(text_names):
    print(name)
