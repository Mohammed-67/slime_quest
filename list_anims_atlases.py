import UnityPy
import os

apk_assets_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\com.loadcomplete.slimequest\assets"

print("Loading Unity assets...")
env = UnityPy.load(apk_assets_dir)

animation_names = []
atlas_names = []

for obj in env.objects:
    if obj.type.name == "AnimationClip":
        try:
            data = obj.read()
            animation_names.append(data.name)
        except:
            pass
    elif obj.type.name == "SpriteAtlas":
        try:
            data = obj.read()
            atlas_names.append(data.name)
        except:
            pass

print("\n--- Animations Found ---")
for name in sorted(animation_names):
    print(name)

print("\n--- Sprite Atlases Found ---")
for name in sorted(atlas_names):
    print(name)
