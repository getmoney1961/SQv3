# Deploy Success Quotes Website to GitHub Pages

## Understanding Your Project Structure

### Source Code (The Source of Truth)
- **Location**: `quotes-builder/`
- **Contains**: 
  - `src/pages/` - Your Astro page templates (index.astro, app.astro, daily.astro, etc.)
  - `public/` - Static assets that get copied to dist (CSS, JS, images, CNAME)
  - `astro.config.mjs` - Configuration file

### Built Website (What Goes on GitHub Pages)
- **Location**: `dist/`
- **Contains**: Static HTML files generated from your Astro source
- **This is what you deploy to GitHub Pages!**

---

## How Astro Works (Simple Explanation)

1. **You Edit**: Files in `quotes-builder/src/pages/` (like `app.astro`)
2. **You Build**: Run `npm run build` in the `quotes-builder/` folder
3. **Astro Generates**: All the HTML files in `dist/` folder
4. **You Deploy**: Push the `dist/` folder contents to GitHub Pages

---

## Step-by-Step: Deploy to GitHub Pages

### Step 1: Make Sure Everything is Built
```bash
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder
npm run build
```

This creates/updates all files in the `dist/` folder.

### Step 2: Initialize Git in the `dist` Folder
```bash
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/dist
git init
```

### Step 3: Add All Files
```bash
git add .
```

### Step 4: Commit
```bash
git commit -m "Deploy Success Quotes website"
```

### Step 5: Add Your GitHub Repository as Remote
Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username:
```bash
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git
```

### Step 6: Force Push to GitHub Pages Branch
```bash
git push -f origin main:gh-pages
```

**Or if your main branch is called master:**
```bash
git push -f origin master:gh-pages
```

---

## Important Notes

### About Force Push
- The `-f` flag means "force push" - it overwrites everything on GitHub with your local version
- This is what you want for a clean deployment
- ⚠️ **Warning**: This will DELETE any files on GitHub that aren't in your local `dist` folder

### CNAME File
- Your CNAME file is already in `quotes-builder/public/CNAME`
- When you build, it automatically gets copied to `dist/CNAME`
- This tells GitHub Pages to use your custom domain: **www.successquotes.co**

### Firebase Config
- Make sure `dist/js/firebase-config.js` exists before deploying
- This file is ignored in git, so make sure it's in your dist folder before pushing

---

## Alternative: Deploy Entire Project to GitHub

If you want to keep your source code on GitHub too (recommended):

### Step 1: Initialize Git in the Website Root
```bash
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website
git init
```

### Step 2: Add and Commit
```bash
git add .
git commit -m "Initial commit - Success Quotes website"
```

### Step 3: Add Remote
```bash
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git
```

### Step 4: Push Main Branch
```bash
git push -u origin main
```

### Step 5: Deploy dist to gh-pages Branch
```bash
cd dist
git subtree push --prefix dist origin gh-pages
```

---

## GitHub Pages Settings

After pushing, go to your GitHub repository:

1. Click **Settings**
2. Scroll to **Pages** (left sidebar)
3. Under **Source**, select:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
4. Click **Save**
5. Your custom domain should already be set from the CNAME file

---

## Making Updates

### Workflow for Future Updates:

1. **Edit your source files** in `quotes-builder/src/pages/`
2. **Rebuild** the site:
   ```bash
   cd quotes-builder
   npm run build
   ```
3. **Deploy** the updated `dist/` folder:
   ```bash
   cd ../dist
   git add .
   git commit -m "Update website"
   git push -f origin main:gh-pages
   ```

---

## Troubleshooting

### "Firebase config not found" error on website
- Make sure `dist/js/firebase-config.js` exists
- Copy from `quotes-builder/public/js/firebase-config.js` if needed

### Website not updating
- Clear your browser cache
- Wait 5-10 minutes for GitHub Pages to rebuild
- Check GitHub Actions tab for build status

### Custom domain not working
- Make sure CNAME file contains: `www.successquotes.co`
- Check your domain DNS settings point to GitHub Pages

---

## Quick Reference Commands

```bash
# Build the website
cd quotes-builder && npm run build

# Deploy to GitHub Pages
cd ../dist && git add . && git commit -m "Update" && git push -f origin main:gh-pages
```

---

## Need Help?
If you get stuck, refer back to this guide or check the GitHub Pages documentation at:
https://docs.github.com/en/pages

