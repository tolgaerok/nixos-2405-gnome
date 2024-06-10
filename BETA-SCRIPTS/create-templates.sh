#!/bin/bash

# Define the template directory..
TEMPLATE_DIR="$HOME/Templates"

# Create the template directory if it doesn't exist
mkdir -p "$TEMPLATE_DIR"

# Create blank text document
touch "$TEMPLATE_DIR/Blank-Document.txt"

# Create blank Word document
touch "$TEMPLATE_DIR/Blank-Document.docx"

# Create blank Excel spreadsheet
touch "$TEMPLATE_DIR/Blank-Spreadsheet.xlsx"

# Create blank configuration file
touch "$TEMPLATE_DIR/Blank-Config.conf"

# Create blank markdown file
touch "$TEMPLATE_DIR/Blank-Document.md"

# Create blank shell script
touch "$TEMPLATE_DIR/Blank-Script.sh"

# Create blank Python script
touch "$TEMPLATE_DIR/Blank-Script.py"

# Create blank JSON file
touch "$TEMPLATE_DIR/Blank-Document.json"

# Create blank YAML file
touch "$TEMPLATE_DIR/Blank-Document.yaml"

# Create blank HTML file
touch "$TEMPLATE_DIR/Blank-Document.html"

# Create blank CSS file
touch "$TEMPLATE_DIR/Blank-Document.css"

# Create blank JavaScript file
touch "$TEMPLATE_DIR/Blank-Document.js"

# Print a message indicating completion
echo "Template documents created in $TEMPLATE_DIR"
