const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.createProfile = functions.auth.user().onCreate((user) => {
    // Do something after a new user account is created
    return admin.firestore().doc(`/users/${user.uid}`).set({
      id: user.uid
    })
});
