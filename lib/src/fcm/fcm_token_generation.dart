import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import "package:http/http.dart" as http;

class FirebaseAccessToken {
  static String firebaseMsgScope =
      "https://www.googleapis.com/auth/firebase/firebase.messaging";
  Future<String> getToken() async {
    try {
      final credentials = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "phoo-sar",
        "private_key_id": "061dcd0aa8bfaceefb019b41f6f0216c167e0164",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCj/dWKLkjsJIf7\nC0/V0Ht38Jlf8Gj9QUsYw7HemguRTaLKG52Ye6fWPIdYsq+pbJ1yFoNrnkDbAyhn\nFFi19Y4Wf6HKPVz6JRSnU0SN+KZqcdBPjHHUjF3nT2UWjyJpvlNMLTWmXkkQNBXt\nV0sKyiXuETDl3lIpDCk3cgvn1Gvn4u/mS9ErptrIOBG1P6NdcBY1NgSeAMhAgr2X\nNe8o/xboDt7YZE36ft1mQPFc8Ex4Vo/qkNu7eJzTKQtjfi4y39eZjnM+DgYbXfxj\nJ9Krck9/2A7KLFOiWm0qZRc93YpUUZSW3SZDZ8yVVdOC0YS6Wax6RSgETlU/Q0j/\nNZKGZnX1AgMBAAECggEAA0ZcpxGFDcgt+f6wFbQ/3vWMTozpv9L3ubMgwHIBlKGB\nBHm4NDUV9TKIvmX1GZRMcZyO+81xfJ4rxqEyo1GXyI28cKI4kts+Nhg02IP0aNBE\niW4j0MuLzYR5n5F0rblqBu2pMl0UJvFvVanGWx0N1Fr+B70glWbDhPKvV64XiI4o\nrBVxl0UBeF+S9DkFdp5f7f9KqtSAwlhCVApYIVnhdWjhBQXGgGiULNGzNL2afdFC\na0ooXcuc4vlGOYcl3OqOmht8ggFa8T8qN9ZcpCQ0Fxh5p2QJ59wmlye2Pan0nsKM\n/PO5wn9v5iXZ7NjYnCgr+CzJMRZfF/IgSs5EwH7HgQKBgQDCsy6rztFSXN8+zj7G\nCbdxxVaseLjhKNVNSRZEr6gvNEaOTNfuoVMVFKRcS+6gTK1uCNU+sFK+GYnkBsag\npeQcJLRVHvGFFZ+H6hhqyS3q1hmm4sb3n0rzebYw4NzYIx1Dpm5HfcePfvSmWLSY\n78sAyjVVvn93MNleloK2ffE8gQKBgQDXn44TFKLr9TEmRT3bfYPRsjBLEKj0ePBy\n76kxWvgrw/OnwYbkCAcKgK3v/HTKW7sU9k4wo0jyH0G2fKy31owJka/Lk8S8Xnq7\nrFejP/G0Q+r0kjh1aWaHqkRQjZKQHVEenm6iFxs/E2WDrnxJogL7n3us78cbBgIy\nmeG+sHpPdQKBgQCokwmaugPkowKr11jkkK8jM3Ba/l9cm8UrGFfOeqRM0p8wP/pJ\n46YSv3+bZici5aDXf5BaqcHKVEReiTtbBqcdcu4sMRF+X/1zaU1gz/UQufUV2I3b\nAjGb40rKwTaVcLm6xBQBlDa/2HUsvesH677BXVKWfczRPxtFWV2tchf3gQKBgANd\nozsbBFwIjMbbJ9cIQ4l/bY+OaATA6ofww8RYdi1Atsn0lGV01p9MWOq5Fx2dhvMR\n0TCjK91TrZPqqEuKVs9DbeoQmW6TTvkk/I04z04QDVfZ/HWguo/9kWlsfFAxlPWU\nZYe0MqGubNQ8YgZIOCGzYJvXdlUup9QgYMy4NoCNAoGAJtCPISw7vUyDR8fp/YXA\ng6p8yB8oo90XPQgD1CJR2pyz7Qye9s9QBYWSQh6zegCW6UE/1NrcGFFIzv3wUlgk\ndaGdI4W9sx+xycI7w6JKd4UDyjGqk4AfeXLMfhs+4kL2z6LwZHrNzQZJX1uTvCbg\nKsrDU5HofkEKrjQIrJ5qzPY=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-crhsf@phoo-sar.iam.gserviceaccount.com",
        "client_id": "114773718376288657189",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-crhsf%40phoo-sar.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      });
      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      final client = await obtainAccessCredentialsViaServiceAccount(
          credentials, scopes, http.Client());
      final accessToken = client;
      Timer.periodic(const Duration(minutes: 59), (timer) {
        accessToken.refreshToken;
      });
      return accessToken.accessToken.data;
    } catch (e) {
      print(e);
    }

    return '';
  }
}