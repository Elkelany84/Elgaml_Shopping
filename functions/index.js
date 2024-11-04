//const functions = require('firebase-functions');
    const {initializeApp} = require("firebase-admin/app");
    const {getMessaging} = require("firebase-admin/messaging");
    const {onDocumentCreated} = require("firebase-functions/firestore");

    initializeApp();

    exports.dispatchMessage = onDocumentCreated("ordersAdvanced/{sessionId}", (event) => {
      const snapshot = event.data;
      const data = snapshot.data();
      const message = getMessaging();
      message.send({
        topic: "ordersAdvanced",
        notification: {
          title: "Store",
          body: "New Order Arrived",
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
    exports.orderCreated = onDocumentCreated("ordersAdvanced/{sessionId}", (event) => {
//          const snapshot = event.data;
//          const data = snapshot.data();
          const message = getMessaging();
          message.send({
//            topic: "ordersAdvanced",
            notification: {
              title: "Store",
              body: "New Order",
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
          });
        });

//create and deploy your first function
//exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
//});