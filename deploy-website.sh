#!/bin/bash

# Success Quotes - Easy Deployment Script
# This script builds your website and prepares it for GitHub Pages deployment

echo "========================================="
echo "  Success Quotes - Website Deployment"
echo "========================================="
echo ""

# Step 1: Build the website
echo "Step 1: Building website..."
cd quotes-builder
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed! Please check for errors above."
    exit 1
fi

echo "✅ Build completed successfully!"
echo ""

# Step 2: Check CNAME
echo "Step 2: Verifying CNAME file..."
if [ -f "../dist/CNAME" ]; then
    echo "✅ CNAME file exists: $(cat ../dist/CNAME)"
else
    echo "⚠️  Warning: CNAME file not found!"
fi
echo ""

# Step 3: Check Firebase config
echo "Step 3: Checking Firebase configuration..."
if [ -f "../dist/js/firebase-config.js" ]; then
    echo "✅ Firebase config exists"
else
    echo "⚠️  Warning: firebase-config.js not found!"
    echo "   Copy it from: quotes-builder/public/js/firebase-config.js"
fi
echo ""

# Instructions for GitHub deployment
echo "========================================="
echo "  Ready to Deploy!"
echo "========================================="
echo ""
echo "Your website has been built and is ready in the 'dist/' folder."
echo ""
echo "To deploy to GitHub Pages, run these commands:"
echo ""
echo "  cd dist"
echo "  git init"
echo "  git add ."
echo "  git commit -m \"Deploy Success Quotes website\""
echo "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "  git push -f origin main:gh-pages"
echo ""
echo "Replace YOUR_USERNAME and YOUR_REPO with your actual GitHub details."
echo ""
echo "📚 For detailed instructions, see: DEPLOY-TO-GITHUB.md"
echo "========================================="

