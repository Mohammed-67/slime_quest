import os
import re

def repair_content(content):
    # 1. Fix broken Ternary Operators in String Templates
    # Example: 'gem'_?_'_' : '🪙' -> 'gems' ? '💎' : '🪙'
    content = re.sub(r"'gem'_\?_'_' : '🪙'", "'gems' ? '💎' : '🪙'", content)
    content = re.sub(r'type == "gem"_\?_"\💎" : "🪙"', 'type == "gems" ? "💎" : "🪙"', content)

    # 2. Fix BoxDecoration.withValues (invalid)
    # If app_theme.dart defines borderGlow as BoxDecoration, we can't call withValues on it.
    # We should just remove it or fix it if it was intended for a color.
    content = re.sub(r'AppTheme\.borderGlow\.withValues\(alpha: [0-9.]+\)', 'AppTheme.borderGlow', content)

    # 3. Fix missing closing braces and corrupted list literals
    # Example: [r.type == 'gems' ... ).toList(), -> ].toList(),
    # content = content.replace(')).toList(),', ')).toList(),') # already matched?
    
    # 4. Fix specific screen method signatures and calls
    # chapter_select_screen.dart had issues with startBattle and isBoss_
    content = content.replace('isBoss_', 'isBoss')
    content = content.replace('stamina_', 'stamina')
    
    # 5. Fix common Widget parameter errors (Missing required argument 'text')
    # GameButton often needs 'text' or 'label'.
    # If we see GameButton without 'text:', but with something else:
    # Actually, let's look at GameButton definition.
    
    # 6. Fix "withValues" everywhere to be safer (use withOpacity if it might be an older Flutter version)
    # But wait, analyze didn't complain about Color.withValues.
    
    # 7. Fix Icon names (more specifically)
    icon_fixes = {
        'arrowback': 'arrow_back',
        'arrowback_ios': 'arrow_back_ios',
        'arrowforward': 'arrow_forward',
        'arrowforward_ios': 'arrow_forward_ios',
        'emojievents': 'emoji_events',
        'emojievents_outlined': 'emoji_events_outlined',
        'monetizationon': 'monetization_on',
        'cloudupload': 'cloud_upload',
        'volumeup': 'volume_up',
        'musicnote': 'music_note',
        'helpoutline': 'help_outline',
        'infooutline': 'info_outline',
        'privacytip': 'privacy_tip',
        'newreleases': 'new_releases',
        'accesstime': 'access_time',
        'checkcircle': 'check_circle',
        'mailoutline': 'mail_outline',
        'flashon': 'flash_on',
        'autoawesome': 'auto_awesome',
        'chevronright': 'chevron_right',
        'bugreport': 'bug_report',
        'confirmationnumber': 'confirmation_number',
    }
    for old, new in icon_fixes.items():
        content = content.replace(f'Icons.{old}', f'Icons.{new}')

    # 8. Fix Numeric constants again (ensure no double .0.0)
    def fix_numbers(match):
        num = match.group(1)
        return f"{num}.0"
    content = re.sub(r'\b_(\d+)\b', fix_numbers, content)
    content = content.replace('.0.0', '.0')

    return content

def main():
    base_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\lib"
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = repair_content(content)
                
                if new_content != content:
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Fixed {file}")

if __name__ == "__main__":
    main()
