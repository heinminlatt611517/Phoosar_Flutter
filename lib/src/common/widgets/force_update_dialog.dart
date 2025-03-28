import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/auth/login.dart';
import '../../providers/app_provider.dart';

Future<void> forceUpdateDialog({required BuildContext context, required WidgetRef ref}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: SafeArea(
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            surfaceTintColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "App Update Required",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "A new version is available. Please update to continue using the app with the latest features and improvements.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop(true);
                      await _launchStore();
                      await ref.read(sharedPrefProvider).clear();
                      ref.invalidate(dashboardProvider);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Update Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _launchStore() async {
  String url;
  String androidAppId = 'com.moc.updatephoosar';
  String iOSAppId = 'com.moc.phoo-sar';
  url = Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=$androidAppId'
      : 'https://apps.apple.com/us/app/phoosar/id6480433838';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
