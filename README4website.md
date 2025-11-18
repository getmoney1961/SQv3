# Success Quotes Website

A beautiful, fast static website built with Astro featuring thousands of curated success quotes from the world's most successful people.

**Live Website**: [www.successquotes.co](https://www.successquotes.co)

---

## 📁 Project Structure

```
Website/
├── quotes-builder/          ← SOURCE CODE (Your source of truth)
│   ├── src/
│   │   ├── pages/          ← Astro page templates (.astro files)
│   │   ├── layouts/        ← Shared layout components
│   │   ├── components/     ← Reusable components
│   │   └── data/          ← Quote data (quotes.json)
│   ├── public/            ← Static assets (copied to dist)
│   │   ├── css/
│   │   ├── js/
│   │   ├── CNAME
│   │   └── images
│   ├── package.json
│   └── astro.config.mjs
│
├── dist/                   ← BUILT WEBSITE (Deploy this to GitHub Pages)
│   ├── index.html
│   ├── app.html
│   ├── daily.html
│   ├── CNAME
│   └── ... (all generated HTML files)
│
└── DEPLOY-TO-GITHUB.md    ← Deployment instructions
```

---

## 🚀 Quick Start

### Prerequisites
- Node.js installed on your computer
- Basic knowledge of terminal/command line

### Development Workflow

1. **Edit Source Files**
   ```bash
   cd quotes-builder/src/pages/
   # Edit any .astro files (index.astro, app.astro, etc.)
   ```

2. **Preview Changes Locally**
   ```bash
   cd quotes-builder
   npm run dev
   ```
   Open http://localhost:4321 in your browser

3. **Build for Production**
   ```bash
   npm run build
   ```
   This generates all HTML files in the `dist/` folder

---

## 🎨 How It Works

### Astro Build System

**Astro** is a static site generator that:
1. Takes your `.astro` files (templates)
2. Processes them with your data (quotes.json)
3. Generates static HTML files
4. Outputs everything to the `dist/` folder

### Source of Truth

**Your pages**: `quotes-builder/src/pages/`
- `index.astro` → Becomes `dist/index.html`
- `app.astro` → Becomes `dist/app.html`
- `daily.astro` → Becomes `dist/daily.html`
- `search.astro` → Becomes `dist/search.html`
- And so on...

**Your data**: `quotes-builder/src/data/quotes.json`
- Contains all quotes with metadata
- Used to generate individual quote pages

---

## 📝 Making Changes

### Editing Navigation Links

All pages use a shared header with navigation links. You'll find the header in:
- `quotes-builder/src/layouts/BaseLayout.astro` (for quote pages)
- Individual page files (for other pages)

The navigation links are:
```html
<a href="/app">The App</a>
<a href="/quotes">Search Quotes</a>
<a href="/daily">Daily Quote</a>
<a href="mailto:hello@successquotes.co">Contact</a>
```

### Editing Page Content

1. Open the corresponding `.astro` file in `quotes-builder/src/pages/`
2. Make your changes
3. Save the file
4. Rebuild: `npm run build` (in quotes-builder folder)
5. Deploy the updated `dist/` folder

### Adding New Pages

1. Create a new `.astro` file in `quotes-builder/src/pages/`
2. Example: `quotes-builder/src/pages/about.astro`
3. Build the site: `npm run build`
4. New page appears at: `dist/about.html`

---

## 🌐 Deploying to GitHub Pages

See **[DEPLOY-TO-GITHUB.md](./DEPLOY-TO-GITHUB.md)** for detailed instructions.

### Quick Deploy

```bash
# 1. Build the site
cd quotes-builder
npm run build

# 2. Deploy to GitHub
cd ../dist
git init
git add .
git commit -m "Deploy website"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -f origin main:gh-pages
```

---

## 📦 What Gets Deployed

Only the `dist/` folder contents get deployed to GitHub Pages:
- ✅ All HTML files
- ✅ CSS, JavaScript, Images
- ✅ CNAME file (for custom domain)
- ✅ Sitemap and robots.txt

The `quotes-builder/` source folder stays on your computer (or you can push it to a separate branch for backup).

---

## 🔧 Configuration Files

### `quotes-builder/astro.config.mjs`
- Site URL: `https://www.successquotes.co`
- Output directory: `../dist`
- Sitemap generation settings

### `quotes-builder/public/CNAME`
- Contains your custom domain
- Gets copied to `dist/CNAME` during build

### `.gitignore`
- Ignores `node_modules/`
- Ignores Firebase config with sensitive keys
- **Does NOT ignore `dist/`** (needed for GitHub Pages)

---

## 🔥 Firebase Integration

The website uses Firebase for:
- Daily quote functionality
- Analytics (optional)

**Config file**: `quotes-builder/public/js/firebase-config.js`
- This file is `.gitignore`d for security
- Make sure it exists before deploying
- Template available: `quotes-builder/public/js/firebase-config.template.js`

---

## 📊 Analytics

- Google Analytics integrated (G-Q7VXDVZB5V)
- Tracks page views and user interactions
- Script included in all pages

---

## 🎯 Key Features

✨ **3000+ Success Quotes**
- Categorized by author, topic, and category
- Beautiful, modern UI
- Fast loading times

🔍 **Search Functionality**
- Search by quote text
- Filter by author, topic, or category
- Real-time search results

📱 **Responsive Design**
- Works on all devices
- Mobile-first approach
- Beautiful typography

🚀 **Performance**
- Static HTML (ultra-fast)
- Optimized images
- Minimal JavaScript

---

## 📚 Documentation Files

- `README.md` (this file) - Project overview
- `DEPLOY-TO-GITHUB.md` - Deployment instructions
- `FIREBASE-SETUP-INSTRUCTIONS.md` - Firebase configuration
- `UI-CUSTOMIZATION-GUIDE.md` - Design customization
- `DEPLOYMENT-GUIDE.md` - General deployment info

---

## 🐛 Troubleshooting

### Build fails
```bash
cd quotes-builder
rm -rf node_modules
npm install
npm run build
```

### Changes not showing on website
1. Make sure you ran `npm run build`
2. Check that you deployed the `dist/` folder
3. Clear browser cache
4. Wait 5-10 minutes for GitHub Pages to update

### Navigation links broken
- Make sure all links start with `/` (e.g., `/app`, not `app`)
- Links are relative to the domain root
- Check that corresponding `.html` files exist in `dist/`

---

## 📞 Support

For questions or issues:
- Email: hello@successquotes.co
- Check the documentation files in this folder

---

## 🎓 Learning Resources

### Astro Documentation
- Official Docs: https://docs.astro.build
- Tutorial: https://docs.astro.build/en/tutorial/0-introduction/

### GitHub Pages
- Setup Guide: https://docs.github.com/en/pages

### Beginners: Understanding the Workflow
1. **You write** templates in `.astro` files
2. **Astro builds** them into HTML
3. **You deploy** the HTML to GitHub Pages
4. **Visitors see** your website!

---

## ✅ Checklist Before Deploying

- [ ] Made your changes in `quotes-builder/src/pages/`
- [ ] Tested locally with `npm run dev`
- [ ] Built the site with `npm run build`
- [ ] Verified `dist/CNAME` contains `www.successquotes.co`
- [ ] Checked `dist/js/firebase-config.js` exists
- [ ] Ready to push `dist/` folder to GitHub!

---

**Built with ❤️ using Astro**

