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
        "private_key_id": "127a9f528750cf901d68f23ce39b4cd3b6cd6c9a",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCYG5vMcEykLrBu\n3IK2ukUP4Dn3qUGAg/LhL2uo4AuS3a7ndqtjfEUoCLBqyFR6iRAq5bchXmFhSB25\njGfTE9jSfq6vhNEcROD8exv0VR+Rz9nD7dUwFQWl63eI8DsO0iwNSKb73PqzIPPz\nQAPma7YyDh7VLuAEGJFJ1vuEaS6gVkuum3n2Vb3jF++FhdI7DrDpYc4ODXBjpQEX\njMWd+lujMPA9e/PtLRTZ8ZVEJik6Vzo7sgthU5ikLZN41bGbPa45712YayDC67Tu\n9DSbZZEYmk6b1xn2GLsbfdi4DuMBlAJvtOtlZOsDF1FphQXd40SlqrKA1t7HG0+Y\nGHmNR4u/AgMBAAECggEABCU7raqUpCRzmx0RlB2A4VbI+nNxI6mbVnP4GRE8fFAX\nXE6Mvp7cTnC1YiU7v17GtoYt/TZSk0sN9SJOK0YCTD/qNQ76ssY7ykj1CseN7AFN\nDyM6gqxBmNm3sPjSTmwy8CYkcUvLkOzOfGwogkCgPz5irIh+nKeQwIFTHhloJs14\nfBp1c2fyJw9mn/S5bFVOAtq1cufbU7V0OHYd/WXfUbCb1PHITQmt3CiJoJPMMjO0\n+BO6swemEX/s19TNFJ1E6bekVsoluLvnbmSiFvUhGTDS3kkrwyAVp8aFaLXCqyWw\nED3FNRBLtTMRuPTZXhEP5x60mEV6jfxRBUuivOaSdQKBgQDWbpJv7Cjn+luW5E29\ncvTDc5N5Vf2QuQRLwWLUzaz+fsDWOARALU+E5opugjFo5UezS5NbfI7Fv0YYWn92\nEaAIzszLWgIwbrTqw9YU+b1Lhz6QSmygc3dMg/btBj/kY/hEk/SKma1z4vz0N5pR\n3nfpaBQILz+GQDMimo1Sr/ddNQKBgQC1mCIoM4L/ITMgCQoiBFpRpy4TA8+Dp3ot\nYwPZzqUfLBodjdCAl6ofMD8XzmhkmgtjmGcZrSLODpl9TahjGBs90ntTrRcuqlnh\ntBaHkzT/ntBVSP8zR5KDo2mRsZy/Gv+2TQFXmn89zw2/eNcQSPi56XewleQqnAYA\nadIQ9WfHowKBgASQd/d/7GL7tkVg+LKmpsUeSa5UgUA6X/gI1sS22A7Wvd4RdS20\niTPIAHxXsxuLfdo4KpvQ6+0TpDdSfdISj/iABmXxtYg4Ywt4Pa9WnYvlBhTmMKe9\nrXVofbIP5v5Cjn9PMu5cVQ/Zbg74vAUwGhdSytJdxxlhdnUvGwD+k+JdAoGAGMTO\na+NSy8/QdF8nRaqIUzjVXPyZEmEGlig6PzwjY5QVX9CXDuMg7i4bfPjHXmlwgj4o\nWeU2qRpurxunixSfqpgKAEjMr63GorV4mTdn9DHKQse5H1p0zoW8gYXTVnGtTUVF\nmJhXIKwcOPCXjP4XBuykSa64N2OeofHNGEkQxbcCgYEAvKO//7zSCbSNPLlrzuj/\n9CZJfSOHnDeZeUSO8EIEK7Wutw7JG0lD8b2GyHrDFDxnLDEZ3wtOTph/XBWe6txy\n37AD4UfGWycprbDkQ2NvM/W49ML7mJCB+y7je2W9docIvBKdAHYZu1YpebzAujBf\nZb7NvMHDRk7izlBAfTVjm10=\n-----END PRIVATE KEY-----\n",
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