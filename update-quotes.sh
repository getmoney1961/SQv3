#!/bin/bash

# Success Quotes - Quick Update Script
# This script updates your quotes and rebuilds the site

echo "🔄 Updating Success Quotes Site..."

# Navigate to project directory
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website

# Check if quotes file exists
if [ ! -f "quote of the day.json" ]; then
    echo "❌ Error: 'quote of the day.json' not found!"
    exit 1
fi

echo "📋 Copying quotes to build system..."

# Copy to source data
cp "quote of the day.json" quotes-builder/src/data/quotes.json

# Copy to public data
cp "quote of the day.json" quotes-builder/public/data/quotes.json

echo "✅ Quotes copied successfully!"

echo "🔨 Building site..."

# Navigate to build folder
cd quotes-builder

# Run build
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "✨ BUILD SUCCESSFUL! ✨"
    echo ""
    echo "📊 Your site has been generated in the 'dist/' folder"
    echo ""
    echo "📤 Next steps:"
    echo "   1. Go to: /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/dist/"
    echo "   2. Upload ALL contents to GitHub"
    echo "   3. Your site will update automatically!"
    echo ""
else
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi


