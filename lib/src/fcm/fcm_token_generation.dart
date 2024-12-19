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
        "project_id": "social-media-app-67290",
        "private_key_id": "7c8e982a11cba466f271d2d09e09eb989f0cd97a",
        "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDUrohKEuSvhjRR\n3wdVvvtFY//HgNSh+6aUuwF0qcYQ0a8IFdaTz6iGKoXc/UZcrTpQHQclq/Blui5y\nafDzqwpF9k88ZfY8WAaql3mRCHKtSlI0eDywg+bR6Id7L6hDL1eqGOOmwlKFc/Rq\nrontBRbiJm6h3sX4RWqs0ZNgV+pjK5bxmIDfbs0sfYZXCwqp/1DmI7UKNPPoTx+I\noq5rUURojWTLleGWASpPJTgN68P49Lk1i5I1P8sRB1HSEBE/JNE64Tw4h0Xji+7v\nQJRMlB/XDcQJs12h7FTlr34FDBXRn7IX8GD6gt+fsL7IkbfLKjYxNwwjivZB2NDf\nA0IEVqrXAgMBAAECggEAFmRZzRK4KRLEJ2qH5ys4YVHp+CNEP9my7C3UNWg6hkLN\nXtiNwvo2EAoiFeZEpjVG0nB79CdqJAu6ICmvSLhVWJBaP02s4yWRbhyMnAx7pmsQ\nxJ10JlF819TXjsyxtoEhhbMhJMmIzqwqq6C8vMuwYRcSxtAhn8YPOSrHjXk0IESh\neMoyYlKksbVCEoCFi4d/f4L1/MkPFt95BdUNpcwHwa0dPhOyaFolr0EAu0B7iJyi\nQAWyo4L75r2evttF0eSCbIy0xU2DNxHkrvoxrNVaLJ28doEhyLKdbb0myAcN0D8c\nHzcIjZDeL5jksZRWc+tTSd+2619GF/6UolQm4cbigQKBgQDrqdKmSCUUGNsRiJUh\nFCJpzWa4y7Dq77zc/L6X9HoU1pfSMclhZH6itcfjBQJxQAaCftGGemntVkPaE9v3\nbnTh94sVwMlhpGGQGSgMRbHnS6SfDyhuGCYBj0SEFZrM1x4U64rMpXlrXagPhrQ1\nWc5CXAAnLKGyPKnJk8acdl9CMQKBgQDnCQJvIDp5P8l+wjHw2vs2rct5NheOF/A0\nZkRsIxPTfshZWJ0kLhNyUzejPDb8A0aOsa7REI3DP9O8u+cNmkjH5W2MpRG4vgLn\nVlwuIQoHy2B/M1Kt3/vSNh47MKxIQzDeFsLJcHB0+5NI6fiEqMwHOsLPxr8QZvVG\neySPXtszhwKBgQCwpObExScl3Uu35M0DsnfpHpF0yxmdwH2sl7a1aAdqP0AlyjPM\n0OsrQ17FCChAg2Fdx3l+d5uWzyak/GXRHfZ2unqCn7NTgUewH2spZ8RmPwjyQQZp\nH6i9WopdB2S1Tjm6LKQpqY9NrzIeETZbFynIC/YBZy78zwPlmOMyvHfCwQKBgADY\nl5mwlIY9JY/BRk2Lf8ADgus+t3ddvxNyDG4Y8smjfThWirzHLmsMwvdmEQ17NZbw\nL6O0W9CLO0tFpOL33axdurj5Icd7aqdOOagxlsfQhtnwZi0c1N9AM3wkAX2CQXuO\nucfjEYZcJX3u3Woe9CBSpsP8BlcZCWzopomf302hAoGAdKXbKDiWzaYgPP/hABpi\nNgA8nXNDZncIPcBDhlBisyrA3oy/LlOKhGJLknSUO+vTgjkHB/aTT/y8xacpkqW6\n6wNYNm/Uq8BoW0jcDSjRSrWgmyg5WDdXhI2lPkm78d1DrpgzrxfrxYlVZD1l0L4r\nVO1/vnh8ALc09QcpZnhtUNY=\n-----END PRIVATE KEY-----\n",
        "client_email":
        "firebase-adminsdk-ar7sj@social-media-app-67290.iam.gserviceaccount.com",
        "client_id": "102771816932355389352",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
        "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ar7sj%40social-media-app-67290.iam.gserviceaccount.com",
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