// Firebase Configuration
// IMPORTANT: Replace these values with your actual Firebase config
// Get these from: Firebase Console > Project Settings > Your apps > SDK setup and configuration

const firebaseConfig = {
  apiKey: "AIzaSyBIlYBHeEHxOhRrv2_KyKONwL2wTFYeKls",
  authDomain: "success-quotes-website.firebaseapp.com",
  databaseURL: "https://success-quotes-website-default-rtdb.europe-west1.firebasedatabase.app",
  projectId: "success-quotes-website",
  storageBucket: "success-quotes-website.firebasestorage.app",
  messagingSenderId: "926053392655",
  appId: "1:926053392655:web:8a75656675afc7a2995e7a",
  measurementId: "G-639LGFZYPZ"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Get a reference to the database service
const database = firebase.database();

