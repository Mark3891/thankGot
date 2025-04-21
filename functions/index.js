

//const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// exports.sendPushNotification = functions.firestore
//    .document("letters/{letterId}")
//    .onCreate(async (snapshot, context) => {
//      const newLetter = snapshot.data();
//      const receivedUser = newLetter.receivedUser;
//
//      // 받은 사람의 Firebase 토큰을 가져옵니다
//      const userRef = admin.firestore().collection("users").doc(receivedUser);
//      const userDoc = await userRef.get();
//      const userData = userDoc.data();
//
//      const token = userData && userData.fcmToken;
//
//      if (token) {
//        const message = {
//          notification: {
//            title: "새로운 편지 도착!",
//            body: newLetter.content,
//          },
//          token: token,
//        };
//
//        // FCM을 통해 푸시 알림을 보냅니다
//        await admin.messaging().send(message);
//        console.log("푸시 알림 전송 성공");
//      }
//    });
