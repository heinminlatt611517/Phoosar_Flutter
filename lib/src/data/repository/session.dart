import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/error_dialog.dart';
import 'package:phoosar/src/data/response/default_response.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/page_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static bool showOnce = false;
  static Dio dio = Dio();

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
      Uri url, BuildContext context, WidgetRef ref, CancelToken cancelToken) async {
    var prefs = ref.watch(sharedPrefProvider);
    var token = prefs.getString("token") ?? "";
    developer.log("Token : " + token.toString());

    try {
      Response response = await dio.get(
        url.toString(),
        options: Options(
          headers: {
            "Accept": "application/json",
            'content-type': 'application/json',
            'Authorization': "Bearer " + token,
          },
        ),
        cancelToken: cancelToken,
      );

      if (!response.statusCode.toString().startsWith("2")) {
        var data = DefaultResponse.fromJson(response.data);
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
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        developer.log("Request canceled: ${e.message}");
      } else {
        developer.log("Request error: ${e.message}");
      }
      return Response(
        requestOptions: RequestOptions(path: url.toString()),
        statusCode: 408,
        statusMessage: 'Error',
      );
    }
  }

  static Future<Response> post(
      Uri url, dynamic data, BuildContext context, CancelToken cancelToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    developer.log("Jwt token: $token");

    try {
      Response response = await dio.post(
        url.toString(),
        data: data,
        options: Options(
          headers: {
            "Accept": "application/json",
            'content-type': 'application/json',
            'Authorization': "Bearer " + token!,
          },
        ),
        cancelToken: cancelToken,
      );

      developer.log("Jwt token: ${response.data}");
      var responseData = DefaultResponse.fromJson(response.data);
      if (!response.statusCode.toString().startsWith("2")) {
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
                  ));
        }
      }
      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        developer.log("Request canceled: ${e.message}");
      } else {
        developer.log("Request error: ${e.message}");
      }
      return Response(
        requestOptions: RequestOptions(path: url.toString()),
        statusCode: 408,
        statusMessage: 'Error',
      );
    }
  }
  
  static Future<Response> delete(Uri url, CancelToken cancelToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? '';

    try {
      Response response = await dio.delete(
        url.toString(),
        options: Options(
          headers: {
            "Accept": "application/json",
            'content-type': 'application/json',
            'Authorization': "Bearer " + token,
          },
        ),
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        developer.log("Request canceled: ${e.message}");
      } else {
        developer.log("Request error: ${e.message}");
      }
      return Response(
        requestOptions: RequestOptions(path: url.toString()),
        statusCode: 408,
        statusMessage: 'Error',
      );
    }
  }

  static Future<Response> patch(
      Uri url, dynamic data, BuildContext context, CancelToken cancelToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    developer.log("Jwt token: $token");

    try {
      Response response = await dio.patch(
        url.toString(),
        data: data,
        options: Options(
          headers: {
            "Accept": "application/json",
            'content-type': 'application/json',
            'Authorization': "Bearer " + token!,
          },
        ),
        cancelToken: cancelToken,
      );

      var responseData = DefaultResponse.fromJson(response.data);
      if (!response.statusCode.toString().startsWith("2")) {
        showDialog(
            context: context,
            builder: (context) => ErrorDialog(
                  title: "",
                  message: responseData.message,
                ));
      }

      developer.log("Jwt token: ${response.data}");

      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        developer.log("Request canceled: ${e.message}");
      } else {
        developer.log("Request error: ${e.message}");
      }
      return Response(
        requestOptions: RequestOptions(path: url.toString()),
        statusCode: 408,
        statusMessage: 'Error',
      );
    }
  }

  static Future<Response> put(
      Uri url, dynamic data, BuildContext context, CancelToken cancelToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    try {
      Response response = await dio.put(
        url.toString(),
        data: data,
        options: Options(
          headers: {
            "Accept": "application/json",
            'content-type': 'application/json',
            'Authorization': "Bearer " + token!,
          },
        ),
        cancelToken: cancelToken,
      );

      var responseData = DefaultResponse.fromJson(response.data);
      if (!response.statusCode.toString().startsWith("2")) {
        showDialog(
            context: context,
            builder: (context) => ErrorDialog(
                  title: "",
                  message: responseData.message,
                ));
      }

      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        developer.log("Request canceled: ${e.message}");
      } else {
        developer.log("Request error: ${e.message}");
      }
      return Response(
        requestOptions: RequestOptions(path: url.toString()),
        statusCode: 408,
        statusMessage: 'Error',
      );
    }
  }

}