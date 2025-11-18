# Firebase Cloud Functions - Email Notifications

This folder contains the Cloud Functions that send email notifications when users sign up for your SuccessQuotes app.

## What's Here

- **`index.js`** - The main function that triggers on user signup
- **`package.json`** - Dependencies (SendGrid, Firebase)
- **`.gitignore`** - Keeps node_modules out of git

## Quick Commands

### Deploy Functions
```bash
firebase deploy --only functions
```

### View Logs
```bash
firebase functions:log
```

### View Current Config
```bash
firebase functions:config:get
```

### Update SendGrid API Key
```bash
firebase functions:config:set sendgrid.api_key="YOUR_NEW_KEY"
```

### Update Notification Email
```bash
firebase functions:config:set notification.email="your-email@gmail.com"
```

### Test Locally (Emulator)
```bash
npm run serve
```

### Install Dependencies
```bash
npm install
```

## The Function

### `sendSignupNotification`

**Trigger:** Runs automatically when a new user creates an account via Firebase Auth

**What it does:**
1. Captures user info (email, ID, signup time)
2. Formats a beautiful HTML email
3. Sends it to your configured email address via SendGrid

**Cost:** Free for up to 2M invocations/month (Firebase) + 100 emails/day (SendGrid free tier)

## Configuration

All sensitive config is stored in Firebase Functions Config (NOT in code):

- `sendgrid.api_key` - Your SendGrid API key
- `notification.email` - Email address to receive notifications

## Full Documentation

See the root folder:
- **`QUICK_START_EMAIL_NOTIFICATIONS.md`** - 5-minute setup guide
- **`EMAIL_NOTIFICATION_SETUP.md`** - Detailed step-by-step instructions

## Support

- Firebase Functions: https://firebase.google.com/docs/functions
- SendGrid: https://docs.sendgrid.com/


