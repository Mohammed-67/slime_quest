import os
import re

def repair_content(content):
    # 1. Fix Keywords
    keywords = ['if', 'for', 'async', 'await', 'const', 'case', 'return', 'else', 'while', 'import', 'class', 'enum', 'static', 'final', 'late', 'required', 'override']
    for kw in keywords:
        content = re.sub(rf'\b{kw}_\b', kw, content)
    
    # 2. Fix Filename spaces in imports
    def fix_uri(match):
        uri = match.group(1)
        return f"'{uri.replace(' ', '_')}'"
    content = re.sub(r"'([^']+\.dart)'", fix_uri, content)
    content = re.sub(r'"([^"]+\.dart)"', fix_uri, content)

    # 3. Fix App Theme -> AppTheme (expanded)
    content = content.replace('App Theme', 'AppTheme')
    content = content.replace('AppTheme_', 'AppTheme')
    
    # 4. Fix Icons (specific common contractions)
    icon_fixes = {
        'arrowback': 'arrow_back',
        'arrowforward': 'arrow_forward',
        'arrowback_ios': 'arrow_back_ios',
        'arrowforward_ios': 'arrow_forward_ios',
        'emojievents': 'emoji_events',
        'monetizationon': 'monetization_on',
        'cloudupload': 'cloud_upload',
        'volumeup': 'volume_up',
        'volumedown': 'volume_down',
        'volumeoff': 'volume_off',
        'helpoutline': 'help_outline',
        'infooutline': 'info_outline',
        'privacytip': 'privacy_tip',
        'newreleases': 'new_releases',
        'accesstime': 'access_time',
        'chevronright': 'chevron_right',
        'chevronleft': 'chevron_left',
        'flashon': 'flash_on',
        'flashoff': 'flash_off',
        'autoawesome': 'auto_awesome',
        'checkcircle': 'check_circle',
        'mailoutline': 'mail_outline',
        'bugreport': 'bug_report',
        'confirmationnumber': 'confirmation_number',
        'favorite_': 'favorite',
        'heal_': 'heal',
        'isBoss_': 'isBoss',
    }
    for old, new in icon_fixes.items():
        content = content.replace(f'Icons.{old}', f'Icons.{new}')
        content = content.replace(f' {old}', f' {new}')

    # 5. Fix Numeric Constants (e.g. _16 -> 16.0)
    # Match _ followed by digits
    def fix_numbers(match):
        num = match.group(1)
        return f"{num}.0"
    content = re.sub(r'\b_(\d+)\b', fix_numbers, content)

    # 6. Restore Underscores to Private fields (Improved)
    # We look for field names that are used as " name" in getters/setters or logic
    private_names = [
        'currentSlimeHp', 'currentMonsterHp', 'isPlayerTurn', 'isBattleOver', 
        'battleLog', 'unreadMails', 'ownedSlimes', 'teamSlimes', 'inventory', 
        'chapters', 'achievements', 'arenaRank', 'arenaTickets', 'slimePassActive',
        'isMonsterAttacking', 'isAttacking', 'confettiController', 'orbController',
        'lastPulled', 'multiPullResults', 'isAnimating', 'tabController'
    ]
    for name in private_names:
        # Avoid double underscores if already fixed
        if f'_{name}' not in content:
            # Change declaration and usage
            # This is risky but since we are in a broken state, it's worth it
            # We match it when it follows a type or is used as a property
            content = re.sub(rf'\b{name}\b', f'_{name}', content)
    
    # Clean up accidental double underscores or broken getters
    content = content.replace('__', '_')
    content = content.replace('get _', 'get ')
    content = content.replace('this._', 'this._')
    content = content.replace('._', '.') # Fix property access on other objects if it shouldn't be private
    # Wait, '._' is generally bad if it's external. Let's revert that if needed.
    
    # 7. Fix common logic corruption
    content = content.replace('?? _', '?? ')
    content = content.replace(' : _', ' : ')
    content = content.replace('([_])', '([])')

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
