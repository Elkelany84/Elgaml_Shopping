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
          const snapshot = event.data;
          const data = snapshot.data();
          const message = getMessaging();
          message.send({
            topic: "ordersAdvanced",
            notification: {
              title: "Store",
              body: "New Order",
            },
            data: {
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
          });
        });


//    exports.createorder = onDocumentCreated("ordersAdvanced/{sessionId}", (event) => {
//            // Get an object representing the document
//            // e.g. {'name': 'Marie', 'age': 66}
//            const snapshot = event.data;
//            if (!snapshot) {
//                console.log("No data associated with the event");
//                return;
//            }
//            const data = snapshot.data();
//
//            // access a particular field as you would any JS property
//            const name = data.name;
//
//            // perform more operations ...
//            console.log("New user created: ", name);
//            const message = getMessaging();
//            message.send({
//              notification: {
//                title: "Store",
//                body: "New Order",
//              },
//              data: {
//                click_action: "FLUTTER_NOTIFICATION_CLICK",
//            }
//
//        });

//create and deploy your first function
//exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
//});