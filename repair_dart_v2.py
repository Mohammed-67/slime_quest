import os
import re

def repair_content(content):
    # 1. Fix Keywords (e.g. if_ -> if, for_ -> for)
    keywords = ['if', 'for', 'async', 'await', 'const', 'case', 'return', 'else', 'while', 'import', 'class', 'enum', 'static', 'final', 'late', 'required']
    for kw in keywords:
        content = re.sub(rf'\b{kw}_\b', kw, content)
    
    # 2. Fix Filename spaces in imports (e.g. '../models/slime model.dart' -> '../models/slime_model.dart')
    # Match strings inside quotes ending with .dart
    def fix_uri(match):
        uri = match.group(1)
        return f"'{uri.replace(' ', '_')}'"
    content = re.sub(r"'([^']+\.dart)'", fix_uri, content)
    content = re.sub(r'"([^"]+\.dart)"', fix_uri, content)

    # 3. Fix App Theme -> AppTheme
    content = content.replace('App Theme', 'AppTheme')
    content = content.replace('AppTheme.', 'AppTheme.') # Ensure dot is there

    # 4. Fix Icons spaces (e.g. Icons.arrow back ios -> Icons.arrow_back_ios)
    def fix_icons(match):
        prefix = match.group(1)
        parts = match.group(2).split(' ')
        return prefix + '_'.join(parts)
    
    # Simple pattern for Icons.xxxx yyyy zzzz
    content = re.sub(r'(Icons\.[a-z][a-z0-9_]*) ([a-z][a-z0-9_ ]*)\b', fix_icons, content)

    # 5. Fix Private Member Underscores (The most common issue: int  currentSlimeHp -> int _currentSlimeHp)
    # Look for variable declarations inside classes that have double space prefix
    # Pattern: [type]  [name]
    # We restrict this to CamelCase names starting with a lowercase letter
    def fix_private_fields(match):
        type_part = match.group(1)
        name_part = match.group(2)
        # Check if it was intended to be private by looking at the double space or common patterns
        return f"{type_part} _{name_part}"

    # Match common field declarations with double spaces
    content = re.sub(r'(\b[A-Z][a-zA-Z0-9<>?]*\??)\s\s+([a-z][a-zA-Z0-9]*)\b', fix_private_fields, content)
    content = re.sub(r'(\bbool)\s\s+([a-z][a-zA-Z0-9]*)\b', r'\1 _\2', content)
    content = re.sub(r'(\bint)\s\s+([a-z][a-zA-Z0-9]*)\b', r'\1 _\2', content)
    content = re.sub(r'(\bString\??)\s\s+([a-z][a-zA-Z0-9]*)\b', r'\1 _\2', content)
    content = re.sub(r'(\bfinal)\s\s+([a-z][a-zA-Z0-9]*)\b', r'\1 _\2', content)

    # 6. Fix usages of those private fields (this is tricky, so we look for names that are likely private)
    # If we see ' currentSlimeHp' (leading space, then name), it was likely '_currentSlimeHp'
    # Actually, the previous repair might have left them as ' name'
    # For now, let's fix usages that are assigned or accessed: e.g. " isBattleOver = true" -> " _isBattleOver = true"
    # Wait, the analyze report says: "The name 'currentSlimeHp' is already defined."
    # This means 'int currentSlimeHp' exists but someone is using it as a getter/setter.
    
    # 7. Specific fixes for Provider patterns found in analyze logs
    content = content.replace('currentSlimeHp', '_currentSlimeHp')
    content = content.replace('currentMonsterHp', '_currentMonsterHp')
    content = content.replace('isPlayerTurn', '_isPlayerTurn')
    content = content.replace('isBattleOver', '_isBattleOver')
    content = content.replace('battleLog', '_battleLog')
    content = content.replace('unreadMails', '_unreadMails')
    content = content.replace('ownedSlimes', '_ownedSlimes')
    content = content.replace('teamSlimes', '_teamSlimes')
    content = content.replace('inventory', '_inventory')
    content = content.replace('chapters', '_chapters')
    content = content.replace('achievements', '_achievements')
    
    # Undo double underscores if we created them
    content = content.replace('__', '_')
    content = content.replace('get _', 'get ') # Getters should not have underscores in their names
    content = content.replace('this._', 'this._') # Good
    
    return content

def main():
    base_dir = r"e:\3\Slime+Quest_1.0.4_apkcombo.com\slime_quest\lib"
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                print(f"Repairing {path}...")
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = repair_content(content)
                
                if new_content != content:
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Fixed {file}")

if __name__ == "__main__":
    main()
