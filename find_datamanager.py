import UnityPy

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"
env = UnityPy.load(apk_assets_dir)

for obj in env.objects:
    if obj.type.name == "MonoBehaviour":
        try:
            data = obj.read()
            if data.m_Script:
                script = data.m_Script.read()
                if script.m_ClassName == "DataManager":
                    print(f"DataManager found! PathID: {obj.path_id}")
                    # Try to get data
                    try:
                        print(f"Raw data head: {obj.get_raw_data()[:100].hex()}")
                    except:
                        pass
        except:
            pass
