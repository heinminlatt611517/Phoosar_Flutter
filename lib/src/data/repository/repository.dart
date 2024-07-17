import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:phoosar/env/env.dart';
import 'session.dart';

class Repository {
  Future<Response> login(dynamic request, WidgetRef ref, BuildContext context,
      CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/login"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> register(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/register"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> sendOTP(
      dynamic request, WidgetRef ref, CancelToken cancelToken) async {
    var dio = Dio();
    var response = await await dio.post(
      "${Env.baseurl}/send-otp",
      data: request,
      options: Options(
        headers: {
          "Accept": "application/json",
          'content-type': 'application/json',
        },
      ),
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<Response> verifyOTP(
      dynamic request, WidgetRef ref, CancelToken cancelToken) async {
    var dio = Dio();
    var response = await await dio.post(
      "${Env.baseurl}/verify-otp",
      data: request,
      options: Options(
        headers: {
          "Accept": "application/json",
          'content-type': 'application/json',
        },
      ),
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> socialLogin(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/social-login"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> saveProfile(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-profile"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> getProfile(
      WidgetRef ref, BuildContext context, CancelToken cancelToken) async {
    var response = await Session.get(
      Uri.parse("${Env.baseurl}/profile"),
      context,
      ref,
      cancelToken,
    );
    return response;
  }

  Future<Response> getQuestionList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/questions"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> saveUserQA(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-user-qa"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> findList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/find-list"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> matchList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/match-list"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> likedYouList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/liked-you-list"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> likedProfilesList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/liked-profiles-list"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> packagesList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/packages"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> pointsList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/points"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> whatNewsList(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/what-news"),
      request,
      context,
      cancelToken,
    );
    return response;
  }

  Future<Response> ezPayment(dynamic request, WidgetRef ref,
      BuildContext context, CancelToken cancelToken) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/ez-payment"),
      request,
      context,
      cancelToken,
    );
    return response;
  }
}
