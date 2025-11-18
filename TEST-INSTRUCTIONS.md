# Testing Random Quote Generator & Search

## Quick Test Instructions

### Step 1: Make sure you're viewing the BUILT site

The website needs to be viewed from the `dist` folder, not the root directory.

**Option A: Using a local server (RECOMMENDED)**

```bash
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/dist
python3 -m http.server 8080
```

Then open: http://localhost:8080/random.html

**Option B: Using the Astro dev server**

```bash
cd /Users/barbs/Projects_2023/2024/SuccessQuotes-12-11/Website/quotes-builder
npm run dev
```

Then open the URL it shows (usually http://localhost:4321)

### Step 2: Test Random Quote Generator

1. Go to: http://localhost:8080/random.html (or /random on dev server)
2. Open browser DevTools (F12 or Right-click → Inspect)
3. Go to the Console tab
4. Click "🎲 Generate Random Quote" button
5. You should see a quote appear

**If you see errors:**
- "Failed to fetch" or "404" → The quotes.json file isn't being loaded
- "quotesData is not defined" → JavaScript scope issue
- Nothing happens → Button event listener isn't attached

### Step 3: Test Search

1. Go to: http://localhost:8080/search.html?q=success
2. You should see search results for "success"
3. Try typing a new search term and pressing Enter

## Common Issues & Solutions

### Issue 1: "Failed to fetch /data/quotes.json"

**Solution:** Make sure you're serving from the `dist` folder, not the root folder.

### Issue 2: Button does nothing, no errors

**Solution:** Hard refresh the page (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows)

### Issue 3: Old JavaScript is cached

**Solution:** 
1. Clear browser cache
2. Do a hard refresh
3. Or use Incognito/Private mode

## Check Your Browser Console

Open DevTools Console and look for:
- ✅ No red errors = Good
- ❌ Red "404" errors = File not found
- ❌ "Uncaught" errors = JavaScript issues

## What Should Happen

### Random Quote Page:
1. You see "Click the button below to generate a random quote"
2. You click the button
3. A quote appears with author name and tags
4. Button text changes to "🎲 Generate Another Quote"

### Search Page:
1. Enter a search term like "success" or "motivation"
2. Press Enter
3. See a list of matching quotes
4. Click any quote to view its full page


