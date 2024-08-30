import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phoosar/src/common/widgets/error_dialog.dart';
import 'package:phoosar/src/data/response/default_response.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/extensions.dart';
import 'package:phoosar/src/utils/page_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static bool showOnce = false;

  static unauthenticatedState(SharedPreferences prefs, BuildContext context,
      [String? error]) {
    if (showOnce == false) {
      prefs.clear();
      showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                title: "Session Expired",
                message: "Please Login Again",
                onTap: () {
                  pageNavigator(context, const LoginScreen(),
                      removeBackStacks: true);
                },
              ));

      showOnce = true;
    }
  }

  static Future<Response> get(
    Uri url,
    BuildContext context,
    Ref ref,
  ) async {
    var prefs = ref.watch(sharedPrefProvider);
    var token = prefs.getString("token") ?? "";
    developer.log("Token : " + token.toString());
    var locale = ref.watch(localeProvider);

    final client = await ref.getDebouncedHttpClient();

    Response response = await client.get(
      url,
      headers: {
        'Accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + token,
        'language': locale,
      },
    );

    if (!response.statusCode.toString().startsWith("2")) {
      var data = DefaultResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 422) {
        showDialog(
            context: context,
            builder: (context) => ErrorDialog(
                  title: data.message,
                  message: data.errors!.join("\n"),
                ));
      } else if (response.statusCode == 401) {
        unauthenticatedState(prefs, context);
      } else {
        showDialog(
            context: context,
            builder: (context) => ErrorDialog(
                  title: "",
                  message: data.message,
                ));
      }
    }
    return response;
  }

  static Future<Response> post(
      Uri url, dynamic data, BuildContext context, Ref ref) async {
    var prefs = ref.watch(sharedPrefProvider);
    var token = prefs.getString("token") ?? "";
    developer.log("Token : $token");
    var locale = ref.watch(localeProvider);

    final client = await ref.getDebouncedHttpClient();

    try {
      Response response = await client.post(
        url,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
          'language': locale,
        },
        body: data,
      );

      if (!response.statusCode.toString().startsWith("2")) {
        var responseData = DefaultResponse.fromJson(jsonDecode(response.body));
        if (response.statusCode == 401) {
          unauthenticatedState(prefs, context);
        } else {
          print('should call here');
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: "",
              message: response.statusCode == 422
                  ? responseData.errors!.join("\n")
                  : responseData.message,
            ),
          );
        }
      }
      return response;
    } catch (e) {
      developer.log("Request error: $e");
      return Response(
        'Error',
        408,
        request: Request('POST', url),
      );
    }
  }

  static Future<Response> postWithoutAuth(
      Uri url, dynamic data, BuildContext context, Ref ref) async {
    final client = await ref.getDebouncedHttpClient();
    var locale = ref.watch(localeProvider);
    var prefs = ref.watch(sharedPrefProvider);

    try {
      Response response = await client.post(
        url,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'language': locale,
        },
        body: data,
      );

      if (!response.statusCode.toString().startsWith("2")) {
        var responseData = DefaultResponse.fromJson(jsonDecode(response.body));
        if (response.statusCode == 401) {
          unauthenticatedState(prefs, context);
        } else {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: "",
              message: response.statusCode == 422
                  ? responseData.errors!.join("\n")
                  : responseData.message,
            ),
          );
        }
      }
      return response;
    } catch (e) {
      developer.log("Request error: $e");
      return Response(
        'Error',
        408,
        request: Request('POST', url),
      );
    }
  }

  static Future<Response> delete(Uri url, BuildContext context, Ref ref) async {
    var prefs = ref.watch(sharedPrefProvider);
    var token = prefs.getString("token") ?? "";
    developer.log("Token : $token");
    var locale = ref.watch(localeProvider);
    final client = await ref.getDebouncedHttpClient();

    try {
      Response response = await client.delete(
        url,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
          'language': locale,
        },
      );

      if (!response.statusCode.toString().startsWith("2")) {
        var responseData = DefaultResponse.fromJson(jsonDecode(response.body));
        if (response.statusCode == 401) {
          unauthenticatedState(prefs, context);
        } else {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: "",
              message: responseData.message,
            ),
          );
        }
      }
      return response;
    } catch (e) {
      developer.log("Request error: $e");
      return Response(
        'Error',
        408,
        request: Request('DELETE', url),
      );
    }
  }

  static Future<Response> patch(
      Uri url, dynamic data, BuildContext context, Ref ref) async {
    var prefs = ref.watch(sharedPrefProvider);
    var token = prefs.getString("token") ?? "";
    developer.log("Token : $token");

var locale =ref.watch(localeProvider);
    final client = await ref.getDebouncedHttpClient();

    try {
      Response response = await client.patch(
        url,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
          'language': locale,
        },
        body: data,
      );

      if (!response.statusCode.toString().startsWith("2")) {
        var responseData = DefaultResponse.fromJson(jsonDecode(response.body));
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: "",
            message: response.statusCode == 422
                ? responseData.errors!.join("\n")
                : responseData.message,
          ),
        );
      }

      developer.log("Response : ${response.body}");

      return response;
    } catch (e) {
      developer.log("Request error: $e");
      return Response(
        'Error',
        408,
        request: Request('PATCH', url),
      );
    }
  }
}
