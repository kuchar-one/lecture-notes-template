#!/bin/bash
set -e

echo "Initializing Git repository..."
git init

echo "Adding files..."
git add .

echo "Committing..."
git commit -m "Initial commit of premium lecture notes template"

echo "Creating GitHub repository..."
# Assumes gh is installed via homebrew
/opt/homebrew/bin/gh repo create lecture-notes-template --public --source=. --remote=origin --push

echo "Marking repository as a template..."
/opt/homebrew/bin/gh repo edit --template

echo "Done! The repository is now available on GitHub as a template."
