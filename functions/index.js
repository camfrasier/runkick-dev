const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

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
 response.send("Hello from Firebase!");
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
