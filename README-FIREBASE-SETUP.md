# Firebase Configuration Setup

## Initial Setup

1. **Copy the template file:**
   ```bash
   cp js/firebase-config.template.js js/firebase-config.js
   ```

2. **Get your Firebase credentials:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project "success-quotes-website"
   - Click the gear icon (Settings) > Project Settings
   - Scroll down to "Your apps" section
   - Copy your Firebase configuration

3. **Update `js/firebase-config.js`:**
   - Open the newly created `js/firebase-config.js`
   - Replace all the placeholder values with your actual Firebase config values
   - Save the file

4. **Security Note:**
   - The `js/firebase-config.js` file is gitignored and will NOT be committed
   - Only the template file (`js/firebase-config.template.js`) is tracked in git
   - Keep your API keys secure and never commit them to version control

## After Exposed Key Incident

Since your API key was exposed, you must:

1. **Regenerate your Firebase API key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Select project "success-quotes-website"
   - Navigate to "APIs & Services" > "Credentials"
   - Delete or regenerate the compromised API key
   - Create a new one with proper restrictions

2. **Restrict your API key:**
   - In Google Cloud Console > Credentials
   - Edit your API key
   - Under "Application restrictions", choose "HTTP referrers"
   - Add your website domains (e.g., `yourwebsite.com/*`, `localhost/*`)
   - Under "API restrictions", select only the APIs you need

3. **Use Firebase Security Rules:**
   - Configure proper security rules in Firebase Console
   - This is your main line of defense for Firebase services


