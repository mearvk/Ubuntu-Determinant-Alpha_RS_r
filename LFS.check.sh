#!/usr/bin/env bash

# Define the size limit in kilobytes (50MB = 51200KB)
SIZE_LIMIT=51200
COMMIT_BLOCKED=0
GITIGNORE_UPDATED=0

# Loop through all files that are staged for commit (excluding deleted files)
git diff --cached --name-only --diff-filter=d | while read -r file; do
    
    # Check if the file exists physically on disk
    if [ -f "$file" ]; then
        # Get file size in kilobytes
        file_size=$(du -k "$file" | cut -f1)
        
        # Check if the file size exceeds the 50MB limit
        if [ "$file_size" -ge "$SIZE_LIMIT" ]; then
            echo "❌ ERROR: '$file' is $(($file_size / 1024))MB (Limit is 50MB)."
            
            # Check if the file is already listed in .gitignore
            if ! grep -qxF "$file" .gitignore 2>/dev/null; then
                echo "$file" >> .gitignore
                echo "➕ Added '$file' to .gitignore."
                GITIGNORE_UPDATED=1
            fi
            
            # Unstage the large file to protect the commit
            git reset HEAD "$file" > /dev/null
            COMMIT_BLOCKED=1
        fi
    fi
done

# If any large files were found, block the commit and give instructions
if [ -f .gitignore ] && git diff --name-only | grep -q ".gitignore"; then
    echo ""
    echo "⚠️  Commit blocked. Large files were detected and removed from the staging area."
    echo "📝 Your .gitignore has been updated. Please commit the updated .gitignore first."
    exit 1
fi

exit 0

