// firebase.ts
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyB9tbMf1KkGxF5efpZWV3RHUaeg7Run5M4",
  authDomain: "exp-12.firebaseapp.com",
  projectId: "exp-12",
  storageBucket: "exp-12.firebasestorage.app",
  messagingSenderId: "202381822263",
  appId: "1:202381822263:web:67b02e8c11ae58839fb2b2",
  measurementId: "G-8YG7L32LH8"
};

// Initialize Firebase only once
const app = initializeApp(firebaseConfig);

// Export initialized services
export const auth = getAuth(app);
export const db = getFirestore(app);
export default app;
