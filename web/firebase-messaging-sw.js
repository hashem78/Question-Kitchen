importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyDiWv4b8LHCsTdk4pk1P9slJQpE9KvrZis",
    authDomain: "question-kitchen.firebaseapp.com",
    projectId: "question-kitchen",
    storageBucket: "question-kitchen.appspot.com",
    messagingSenderId: "210995432998",
    appId: "1:210995432998:web:fcd8e57ac6e140f615e0e7"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
});