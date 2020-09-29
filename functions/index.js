const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

exports.myFunction = functions.firestore
    .document('compaint/{docs}')
    .onCreate((snapshot, context) => {
        return admin.messaging().sendToTopic('compaint', {
            notification: {
                title: snapshot.data().title,
                body: snapshot.data().feedback,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            }
        });

    });
