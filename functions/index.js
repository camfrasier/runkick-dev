const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// stripe sdk for cloud functions with test key
const stripe = require('stripe')(functions.config().stripe.secret_test_key);

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// stripe cloud functions

/*
exports.createStripeCustomer = functions.firestore.document('users/{uid}').onCreate(async (snap, context) => {
    const data = snap.data();
    const email = snap.email;

    // await removes the need for a completion handlers
    const customer = await stripe.customers.create({ email: email })

    // the update returns a promise so there are no errors that occur.
    return admin.firestore().collection('users').doc(data.id).update({stripeId : customer.id})

});
*/

/*
exports.createStripeCustomer = functions.database.ref('users/{uid}').onCreate(async (snapshot, context) => {
    //const data = snap.data();
    const uid = context.params.uid;
    const email = snapshot.email;

    // await removes the need for a completion handlers
    const customer = await stripe.customers.create({ email: email })

    // the update returns a promise so there are no errors that occur.
    return admin.database().ref('users/' + uid).update({stripeId : customer.id})

});
*/

exports.createStripeCustomer = functions.database.ref('users/{uid}').onCreate((snapshot, context) => {
    //const data = snap.data();
    const uid = context.params.uid;

    return admin.database().ref('/users/' + uid + '/email/').once('value', async (snapshot) => {
    var email = snapshot.val();
    // await removes the need for a completion handlers
    const customer = await stripe.customers.create({ email: email })

    // the update returns a promise so there are no errors that occur.
    return admin.database().ref('users/' + uid).update({stripeId : customer.id})
  })
});

// callable function - see google firebase callable function docs, so we don't need Alamo Fire etc.

exports.createEphemeralKey = functions.https.onCall(async (data, context) => {

  const customerId = data.customer_id;
  const stripeVersion = data.stripe_version; // the key from the value we pass from the client initializeApp
  const uid = context.auth.uid;

  if (uid === null) {
    console.log('Illegal access attempt due to unauthenticated user');
    throw new functions.https.HttpsError('permission-denied', 'Illegal access attempt.')
  }
  // request that we create the ephemeral key
  return stripe.ephemeralKeys.create(
    {customer: customerId},
    {stripe_version: stripeVersion}
  ).then((key) => {

    return key // return the key to the client app

  }).catch((err) => {
    throw new functions.https.HttpsError('internal', 'Unable to create ephemeral key')
  })
})



exports.observeComments = functions.database.ref('/user-comments/{postId}/{commentId}').onCreate((snapshot, context) => {
  // variables that we will need in order to reach into the proper variables within a structure
  var postId = context.params.postId;
  var commentId = context.params.commentId;

  // using '/' is super important when going into one node, user-comments, another node, postId, then it's dictionary
  return admin.database().ref('/user-comments/' + postId + '/' + commentId).once('value', snapshot => {
    var comment = snapshot.val();
    var commentUid = comment.uid;

    return admin.database().ref('/users/' + commentUid).once('value', snapshot => {
      var commentingUser = snapshot.val();
      var username = commentingUser.username;

      return admin.database().ref('/posts/' + postId).once('value', snapshot => {
        var post = snapshot.val();
        var postOwnerUid = post.ownerUid;

        return admin.database().ref('/users/' + postOwnerUid).once('value', snapshot => {
          var postOwner = snapshot.val();

          var payload = {
            notification: {
              body: username + ' commented on your post'
            }
          };

          admin.messaging().sendToDevice(postOwner.fcmToken, payload)
            .then(function(response) {
              // Response is a message ID string.
              console.log('Successfully sent message:', response);
            })
            .catch(function(error) {
              console.log('Error sending message:', error);
            });

        })
      })
    })
  })
})

exports.observeLikes = functions.database.ref('/user-likes/{uid}/{postId}').onCreate((snapshot, context) => {

    var uid = context.params.uid;
    var postId = context.params.postId;

    console.log('LOGGER --- uid is ' + uid);
    console.log('LOGGER --- postId is ' + postId)

    return admin.database().ref('/users/' + uid).once('value', snapshot => {

      var userThatLikedPost = snapshot.val();

      return admin.database().ref('/posts/' + postId).once('value', snapshot => {

        var post = snapshot.val();

        return admin.database().ref('/users/' + post.ownerUid).once('value', snapshot => {

          var postOwner = snapshot.val();

          var payload = {
            notification: {
              body: userThatLikedPost.username + ' liked your post'
            }
          };

          admin.messaging().sendToDevice(postOwner.fcmToken, payload)
            .then(function(response) {
              // Response is a message ID string.
              console.log('Successfully sent message:', response);
            })
            .catch(function(error) {
              console.log('Error sending message:', error);
            });

        })
      })
    })
} )

// creating a function to observe follow... we can use this to observe check-ins as well
exports.observeFollow = functions.database.ref ('/user-following/{uid}/{followedUid}').onCreate((snapshot, context) => {

  var uid = context.params.uid;
  var followedUid = context.params.followedUid

  console.log('LOGGER --- uid that did following is ' + uid);
  console.log('LOGGER --- following uid is ' + followedUid);

  // this is how we find information related to the username of the follower
  return admin.database().ref('/users/' + followedUid).once('value', snapshot => {
    var userThatWasFollowed = snapshot.val();

    return admin.database().ref('/users/' + uid).once('value', snapshot => {
      var userThatFollowed = snapshot.val();

      var payload = {
        notification: {
          title: 'You have a new follower!',
          body: userThatFollowed.username + ' started following you'
        }
      };

      admin.messaging().sendToDevice(userThatWasFollowed.fcmToken, payload)
        .then(function(response) {
          // Response is a message ID string.
          console.log('Successfully sent message:', response);
        })
        .catch(function(error) {
          console.log('Error sending message:', error);
        });

    })

  })

})

// from udemy session #77
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase Cam Frasier!");
});

exports.sendPushNotification = functions.https.onRequest((req, res) => {

  res.send("Attempting to send push notifications");
  console.log("LOGGER --- Trying to send push message..");

  var uid = 'NebeicciSGMMn5ZtlDCorJ26i222'

  var fcmToken = 'einGOxpRZNM:APA91bGBetV2mKi6zDA7HG9IQeKGWrB4msLhkdRoUBmF3dOseCuGm2mt0nzElFhSL_Mxc5Y6GDzgxZfyXkvLokbyk-wDMhmmc9M2on5q8yK7JFqx9CNPkmx3RvKwdV8hnPqpHj7xb2jF'

  return admin.database().ref('/users/' + uid).once ('value', snapshot => {

    var user = snapshot.val();

    console.log("Username is " + user.username);

    var payload = {
      notification: {
        title: 'Push Notification Title',
        body: 'Test notification message'
      }
    }

    admin.messaging().sendToDevice(fcmToken, payload)
      .then(function(response) {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
      })
      .catch(function(error) {
        console.log('Error sending message:', error);
      });

  })
})
