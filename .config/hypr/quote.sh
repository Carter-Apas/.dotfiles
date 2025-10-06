#!/bin/bash
# hyprlock quote script using the quotable.io API (https://api.quotable.io/)
# Requires: curl (for fetching), jq (for JSON parsing)

# The API returns a JSON object like: {"content": "...", "author": "..."}

# Use curl to get a random quote (max length 150 chars to fit nicely on the screen)
QUOTE_DATA=$(curl -s "https://thequoteshub.com/api/")

# Check if curl failed or returned no data
if [ $? -ne 0 ] || [ -z "$QUOTE_DATA" ]; then
    echo "Failed to fetch quote. Check internet connection."
    exit 1
fi

# Use jq to extract the quote content and author, then format it.
# 1. .content is the quote text.
# 2. gsub removes any internal quotes or newlines that might break Pango.
# 3. We append the author wrapped in <i> tags for italics (Pango markup).
QUOTE=$(echo "$QUOTE_DATA" | jq -r '(.text | gsub("[\"\n]"; "")) + "\n– <i>" + .author + "</i>"')

# Check if jq failed to parse
if [ $? -ne 0 ] || [ -z "$QUOTE" ]; then
    echo "Failed to parse quote JSON."
    exit 1
fi

# Print the final formatted quote
echo "$QUOTE"
