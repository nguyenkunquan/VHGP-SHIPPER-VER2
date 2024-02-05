importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyCYuZ3q5TnMbkO5okCnjxG3jzQr5NomaaY",
  appId: "1:933202759364:web:353a8c91a509f2549ec391",
  messagingSenderId: "933202759364",
  projectId: "vhgp-9b167",
  authDomain: "vhgp-9b167.firebaseapp.com",
  storageBucket: "vhgp-9b167.appspot.com",
  measurementId: "G-84FKEQYVZB",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
