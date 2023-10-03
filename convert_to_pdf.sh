#!/bin/bash

# Check for the directory argument
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <directory>"
	exit 1
fi

DIRECTORY=$(realpath "$1")

# Check if wkhtmltopdf is installed
if ! command -v wkhtmltopdf &>/dev/null; then
	echo "wkhtmltopdf could not be found. Please install it first."
	exit 1
fi

# Find all HTML files in the given directory and its subdirectories
find "$DIRECTORY" -name "*.html" | while read -r file; do
	# Extract the file name without the extension for the output PDF file
	output_file="${file%.html}.pdf"

	# Convert HTML to PDF using wkhtmltopdf
	echo "Converting $file to $output_file"
	wkhtmltopdf "$file" "$output_file"
done

echo "Conversion completed!"
