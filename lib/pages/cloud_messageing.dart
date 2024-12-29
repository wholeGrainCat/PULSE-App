/*import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessage {
  // Initialize FirebaseMessaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize notification permission request
  Future<void> initNotifications() async {
    try {
      // Request permission to show notifications
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("Notification permission granted");

        // Get FCM token after permission is granted
        String? token = await getToken();
        print("FCM Token: $token");

        // You can now send this token to your server to use for push notifications
      } else {
        print("Notification permission denied");
      }
    } catch (e) {
      print("Error during initNotifications: $e");
    }
  }

  // Get the FCM token
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        print("FCM Token retrieved successfully: $token");
        return token;
      } else {
        print("Failed to retrieve FCM Token");
        return null;
      }
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }
}*/
