import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original_content = content

    # Add .w to width
    content = re.sub(r'width:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'width: \1.w', content)
    # Add .h to height
    content = re.sub(r'height:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'height: \1.h', content)
    # Add .sp to fontSize
    content = re.sub(r'fontSize:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'fontSize: \1.sp', content)
    # Add .r to Radius.circular
    content = re.sub(r'Radius\.circular\(\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'Radius.circular(\1.r)', content)
    # Add .w to EdgeInsets.all
    content = re.sub(r'EdgeInsets\.all\(\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'EdgeInsets.all(\1.w)', content)

    # Adding .w / .h to symmetric padding is trickier, let's do a basic look
    content = re.sub(r'horizontal:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'horizontal: \1.w', content)
    content = re.sub(r'vertical:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'vertical: \1.h', content)
    
    # top, bottom, left, right in only
    content = re.sub(r'top:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'top: \1.h', content)
    content = re.sub(r'bottom:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'bottom: \1.h', content)
    content = re.sub(r'left:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'left: \1.w', content)
    content = re.sub(r'right:\s*([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'right: \1.w', content)

    # Size(width, height)
    # Size(20, 20) -> Size(20.w, 20.h)
    content = re.sub(r'Size\(\s*([0-9]+(?:\.[0-9]+)?)\s*,\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'Size(\1.w, \2.h)', content)

    # Icon size
    content = re.sub(r'(Icon\([^\)]*?size:\s*)([0-9]+(?:\.[0-9]+)?)(?![:\.a-zA-Z0-9_])', r'\g<1>\2.sp', content)
    
    if content != original_content:
        # Check if screenutil is imported
        if "flutter_screenutil/flutter_screenutil.dart" not in content:
            # Add after first import
            import_statement = "import 'package:flutter_screenutil/flutter_screenutil.dart';\n"
            if "import " in content:
                content = content.replace("import ", import_statement + "import ", 1)
            else:
                content = import_statement + content
                
        with open(filepath, 'w') as f:
            f.write(content)
        return True
    return False

modified_count = 0
for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            if process_file(path):
                modified_count += 1

print(f"Modified {modified_count} files.")
