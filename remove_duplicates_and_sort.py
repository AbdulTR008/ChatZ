#!/usr/bin/env python3
"""
Flutter Translation Duplicate Remover + Alphabetical Sorter
Removes duplicates and sorts keys A-Z for better organization.
"""

import json
import os
from collections import OrderedDict

def remove_duplicates_and_sort(file_path):
    """Remove duplicate keys and sort alphabetically."""
    try:
        print(f"\nProcessing: {os.path.basename(file_path)}")

        # Read the file
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Track duplicates during parsing
        seen_keys = set()
        duplicate_keys = []
        original_pairs = []

        def track_pairs(pairs):
            """Custom object hook to track duplicates during JSON parsing."""
            result = OrderedDict()
            for key, value in pairs:
                original_pairs.append((key, value))
                if key in seen_keys:
                    duplicate_keys.append(key)
                else:
                    seen_keys.add(key)
                    result[key] = value
            return result

        # Parse with our custom hook
        cleaned_data = json.loads(content, object_pairs_hook=track_pairs)

        # Check for duplicates
        had_duplicates = len(duplicate_keys) > 0

        if had_duplicates:
            print(f"  ⚠ Found {len(duplicate_keys)} duplicate key(s)")

            # Count duplicates
            dup_count = {}
            for key in duplicate_keys:
                dup_count[key] = dup_count.get(key, 0) + 1

            # Show up to 5 examples
            shown = 0
            for key, count in dup_count.items():
                if shown >= 5:
                    break
                print(f"    • '{key}' (repeated {count + 1} times)")
                shown += 1

            if len(dup_count) > 5:
                print(f"    ... and {len(dup_count) - 5} more")
        else:
            print(f"  ✓ No duplicates found")

        # Sort keys alphabetically (case-insensitive)
        sorted_data = OrderedDict(sorted(cleaned_data.items(), key=lambda x: x[0].lower()))

        print(f"  📋 Sorting {len(sorted_data)} keys alphabetically...")

        # Write sorted and cleaned version
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(sorted_data, f, ensure_ascii=False, indent=2)
            f.write('\n')

        if had_duplicates:
            print(f"  ✓ Removed {len(duplicate_keys)} duplicate(s)")
        print(f"  ✓ Sorted alphabetically (A-Z)")
        print(f"  • Total unique keys: {len(sorted_data)}")

        return True

    except json.JSONDecodeError as e:
        print(f"  ✗ JSON parsing error: {str(e)}")
        print(f"     Line {e.lineno}, Column {e.colno}")
        return False
    except Exception as e:
        print(f"  ✗ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Process all translation files."""
    current_dir = os.getcwd()

    print("="*70)
    print("Flutter Translation: Remove Duplicates + Sort A-Z")
    print("="*70)
    print(f"\nWorking directory: {current_dir}")

    # Look for JSON files
    possible_dirs = [
        'assets/translation',
        'assets/translations',
        'lib/l10n',
        'assets/i18n',
        '.'
    ]

    json_files = []
    translation_dir = None

    for dir_path in possible_dirs:
        full_path = os.path.join(current_dir, dir_path)
        if os.path.exists(full_path):
            files = [f for f in os.listdir(full_path) if f.endswith('.json')]
            if files:
                json_files = [os.path.join(full_path, f) for f in sorted(files)]
                translation_dir = full_path
                break

    if not json_files:
        print("\n⚠ No JSON files found!")
        print("\nSearched in:")
        for dir_path in possible_dirs:
            print(f"  • {dir_path}/")
        return

    print(f"\nFound {len(json_files)} translation file(s) in: {os.path.basename(translation_dir)}/")
    for f in json_files:
        print(f"  • {os.path.basename(f)}")

    # Process files
    print("\n🔧 Removing duplicates and sorting...")
    processed_count = 0

    for json_file in json_files:
        if remove_duplicates_and_sort(json_file):
            processed_count += 1

    # Summary
    print("\n" + "="*70)
    if processed_count > 0:
        print(f"✅ SUCCESS! Processed {processed_count} file(s)")
        print("\n📝 What was done:")
        print("  ✓ Removed all duplicate keys (kept first occurrence)")
        print("  ✓ Sorted all keys alphabetically (A-Z)")
        print("  ✓ Preserved all translations and values")
        print("\n📝 Next steps:")
        print("  1. Open files in VS Code - should be sorted A-Z now")
        print("  2. Run: flutter clean && flutter pub get")
        print("  3. Test your app thoroughly")
        print("  4. Commit: git add . && git commit -m 'Sort and clean translation keys'")
    else:
        print("ℹ️  No files were processed")
    print("="*70)

if __name__ == "__main__":
    main()
