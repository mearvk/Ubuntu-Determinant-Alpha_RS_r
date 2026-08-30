# Initialize counter and limit (50MB in bytes = 52428800)
limit=52428800
total=0

find . -name "*.c" -type f -print0 | while IFS= read -r -d '' file; do
  size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
  total=$((total + size))
  if [ "$total" -gt "$limit" ]; then
    echo "Reached 50MB limit."
    break
  fi
  git add "$file"
done

git commit -m "Add roughly 50MB of loose C files"

