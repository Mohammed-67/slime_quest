import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
env = UnityPy.load(apk_assets_dir)

for obj in env.objects:
    if obj.type.name == "TextAsset":
        data = obj.read()
        print(f"Name: {getattr(data, 'm_Name', 'N/A')}")
        print(f"Has script: {hasattr(data, 'script')}")
        if hasattr(data, 'script'):
             val = data.script
             print(f"Script type: {type(val)}")
             if val:
                 print(f"Script length: {len(val)}")
        
        print(f"Has text: {hasattr(data, 'text')}")
        if hasattr(data, 'text'):
             val = data.text
             print(f"Text length: {len(val)}")
        
        # Binary data?
        print(f"Has data: {hasattr(data, 'data')}")
        if hasattr(data, 'data'):
             val = data.data
             print(f"Data length: {len(val)}")

        break
