# 🎨 Beginner's Guide to Editing Your Website Design

## 📍 Two Main Places to Edit Design

### 1. **Main Stylesheet** (Controls Everything)
**File**: `quotes-builder/public/css/styles.css`

This is a regular CSS file - just CSS code, no HTML. It controls colors, fonts, buttons, spacing, and layout for your entire website.

### 2. **Quote Page Styles** (Just for Quote Pages)
**File**: `quotes-builder/src/layouts/BaseLayout.astro`

**Important**: This is an Astro file (`.astro`) which means HTML and CSS are in the same file!

**File Structure:**
- **Lines 1-25**: JavaScript/TypeScript code (you can ignore this)
- **Lines 27-77**: HTML `<head>` section (meta tags, fonts, etc.)
- **Lines 79-199**: CSS styles inside `<style>` tags ← **Edit CSS here**
- **Lines 201-268**: HTML body (header, main content, footer) ← **Edit HTML here**

**How to edit CSS in this file:**
1. Look for the `<style>` tag (starts around line 79)
2. All CSS is between `<style>` and `</style>` (lines 79-199)
3. Edit the CSS just like you would in a regular `.css` file
4. The HTML is below the `</style>` tag (starting at line 201)

**Visual Example of BaseLayout.astro structure:**
```
Line 1-25:    JavaScript code (ignore this)
Line 27-77:   <head> HTML (meta tags, fonts)
Line 79:       <style>                    ← CSS starts here
Line 80-199:   .quote-text { ... }        ← Edit CSS here!
Line 199:      </style>                   ← CSS ends here
Line 201-268:  <body> HTML (header, content, footer) ← Edit HTML here
```

**Example - What you'll see when editing:**
```79:95:quotes-builder/src/layouts/BaseLayout.astro
  <style>
    /* Quote-specific styles */
    .quote-container {
      max-width: 800px;
      margin: 60px auto;
      padding: 40px 20px;
    }
    
    .quote-text {
      font-size: 2em;        ← Change this!
      line-height: 1.6;
      color: white;          ← Or change this!
      font-family: 'Instrument Serif', serif;
```

---

## 🎯 Quick Start: Common Design Changes

### Change 1: Update Website Colors

**File to edit**: `quotes-builder/public/css/styles.css`

**What to change**: Look for color codes (like `#101010` or `#667eea`)

**Example - Change Background Color:**
- **Line 23**: Find `background: #101010;`
- Change to: `background: #1a1a2e;` (or any color you like)
- Use [this color picker](https://htmlcolorcodes.com/) to find hex codes

**Example - Change Header Background:**
- **Line 44**: Find `background: #101010;` inside the `header` section
- Change to your preferred color

### Change 2: Make Quote Text Bigger/Smaller

**File to edit**: `quotes-builder/src/layouts/BaseLayout.astro`

**Line 88**: Find `font-size: 2em;`
- Make bigger: Change to `2.5em` or `3em`
- Make smaller: Change to `1.5em` or `1.8em`

**Line 89**: `line-height: 1.6;` controls spacing between lines
- Increase spacing: `1.8` or `2.0`
- Decrease spacing: `1.4` or `1.5`

### Change 3: Change Quote Text Color

**File to edit**: `quotes-builder/src/layouts/BaseLayout.astro`

**Line 90**: Find `color: white;`
- Change to: `color: #FFD700;` (gold)
- Or: `color: #87CEEB;` (sky blue)
- Or any color you prefer!

### Change 4: Change Button Colors

**File to edit**: `quotes-builder/public/css/styles.css`

**Search for**: `.btn-primary` (around line 200-250)

You'll see something like:
```css
.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}
```

**To change button color:**
- Replace `#667eea` and `#764ba2` with your colors
- Or use a solid color: `background: #FF6B6B;` (removes gradient)

### Change 5: Change Font Sizes Globally

**File to edit**: `quotes-builder/public/css/styles.css`

**Line 51**: Header title size - `font-size: 24px;`
- Make bigger: `28px` or `32px`
- Make smaller: `20px` or `18px`

**Line 82**: Navigation links - `font-size: 1rem;`
- Make bigger: `1.2rem` or `1.5rem`
- Make smaller: `0.9rem` or `0.8rem`

---

## 🔍 How to Find What to Edit

### Method 1: Search for Text You See
1. Open the file in your code editor
2. Press `Cmd+F` (Mac) or `Ctrl+F` (Windows)
3. Type the text you see on your website
4. Find it in the code and edit nearby styles

### Method 2: Search for Colors
1. Right-click on your website → "Inspect" (or "Inspect Element")
2. Find the color code (like `#101010`)
3. Search for that color in your CSS file
4. Change it!

### Method 3: Search for Class Names
- If you see a button, search for `.btn`
- If you see a header, search for `header`
- If you see quote text, search for `.quote-text`

---

## ✅ Step-by-Step: Making Your First Change

Let's change the quote text color to gold as an example:

### Step 1: Open the File
Open: `quotes-builder/src/layouts/BaseLayout.astro`

### Step 2: Find the Line
- Press `Cmd+F` (Mac) or `Ctrl+F` (Windows)
- Search for: `quote-text`
- You'll see around **line 87-90** inside a `<style>` tag:
```79:95:quotes-builder/src/layouts/BaseLayout.astro
<style>
  /* Quote-specific styles */
  .quote-container {
    max-width: 800px;
    margin: 60px auto;
    padding: 40px 20px;
  }
  
  .quote-text {
    font-size: 2em;
    line-height: 1.6;
    color: white;    ← This is what we'll change
    font-family: 'Instrument Serif', serif;
    font-style: italic;
    margin-bottom: 30px;
    text-align: center;
  }
```

### Step 3: Make the Change
Change `color: white;` to `color: #FFD700;`

### Step 4: Save the File
Press `Cmd+S` (Mac) or `Ctrl+S` (Windows)

### Step 5: Rebuild Your Website
Open Terminal (or Command Prompt) and run:
```bash
cd quotes-builder
npm run build
```

### Step 6: Preview Your Changes
```bash
npm run preview
```
Then open: http://localhost:4321

### Step 7: See Your Changes!
Visit any quote page and you'll see the text is now gold!

---

## 🎨 Common CSS Properties Explained

| Property | What It Does | Example |
|----------|-------------|---------|
| `color` | Text color | `color: #FF0000;` (red) |
| `background` | Background color | `background: #000000;` (black) |
| `font-size` | Text size | `font-size: 24px;` or `2em;` |
| `padding` | Space inside element | `padding: 20px;` |
| `margin` | Space outside element | `margin: 10px;` |
| `border-radius` | Rounded corners | `border-radius: 10px;` |
| `font-family` | Font style | `font-family: Arial;` |

---

## 🚨 Important Notes

1. **Always rebuild after changes**: Run `npm run build` in the `quotes-builder` folder
2. **Test locally first**: Use `npm run preview` before uploading
3. **Save your files**: Make sure to save before rebuilding
4. **One change at a time**: Test each change separately

---

## 🎯 Quick Reference: File Locations

| What You Want to Change | File to Edit | Where in File |
|------------------------|--------------|----------------|
| Background colors | `public/css/styles.css` | Lines ~23, ~44 |
| Quote text size | `BaseLayout.astro` | Line 88 (inside `<style>` tag) |
| Quote text color | `BaseLayout.astro` | Line 90 (inside `<style>` tag) |
| Button colors | `BaseLayout.astro` | Lines 142-145 (inside `<style>` tag) |
| Header text | `public/css/styles.css` | Line ~51 |
| Navigation links | `public/css/styles.css` | Line ~82 |

**Note**: In `BaseLayout.astro`, all CSS is between `<style>` tags (lines 79-199). The HTML structure starts at line 201.

---

## 💡 Pro Tips for Beginners

1. **Use browser inspector**: Right-click → Inspect to see what CSS is applied
2. **Start small**: Change one thing at a time
3. **Keep backups**: Copy files before making big changes
4. **Use color pickers**: [htmlcolorcodes.com](https://htmlcolorcodes.com/) or [coolors.co](https://coolors.co/)
5. **Test on mobile**: Resize your browser window to see mobile view

---

## 🆘 Need Help?

**Can't find what to edit?**
- Use your browser's "Inspect" tool to find the CSS class name
- Search for that class name in your CSS files

**Changes not showing?**
- Make sure you saved the file
- Run `npm run build` again
- Clear your browser cache (Cmd+Shift+R or Ctrl+Shift+R)

**Want to undo a change?**
- Press `Cmd+Z` (Mac) or `Ctrl+Z` (Windows) to undo
- Or reload the file from your backup

---

**Ready to start? Pick one change from above and try it!** 🚀

