import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();

interface NotificationData {
  title: string;
  body: string;
  id: string | number;
}

interface UserData {
  fcmToken?: string;
}

export const sendNotification = onDocumentCreated("users/{userId}/notifications/{notificationId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    console.log("No data associated with the event");
    return;
  }

  const notification = snapshot.data() as NotificationData;
  const userId = event.params.userId;

  // Get user's FCM token
  const userDoc = await admin.firestore()
    .collection("users")
    .doc(userId)
    .get();
  const userData = userDoc.data() as UserData;
  const fcmToken = userData?.fcmToken;

  if (!fcmToken) {
    console.log("No FCM token found for user:", userId);
    return null;
  }

  // Send notification
  const message = {
    token: fcmToken,
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data: {
      id: notification.id.toString(),
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
  };

  try {
    await admin.messaging().send(message);
    console.log("Notification sent successfully");

    // Update notification status
    await snapshot.ref.update({
      status: "sent",
      sentAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return null;
  } catch (error) {
    console.error("Error sending notification:", error);
    await snapshot.ref.update({
      status: "error",
      error: error instanceof Error ? error.message : String(error),
    });
    return null;
  }
});
