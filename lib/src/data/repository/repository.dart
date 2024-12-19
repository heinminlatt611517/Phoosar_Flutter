import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phoosar/env/env.dart';

import 'session.dart';

class Repository {
  final Ref ref;
  Repository(this.ref);

  Future<Response> getBackgroundVideo(BuildContext context) async {
    var response = await Session.get(
      Uri.parse("${Env.baseurl}/background-video"),
      context,
      ref,
    );
    return response;
  }

  Future<Response> sendOTP(dynamic request, BuildContext context) async {
    debugPrint("Request:::$request");
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/send-otp"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> verifyOTP(dynamic request, BuildContext context) async {
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/verify-otp"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> login(dynamic request, BuildContext context) async {
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/login"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> register(dynamic request, BuildContext context) async {
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/register"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> socialLogin(dynamic request, BuildContext context) async {
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/social-login"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveProfile(dynamic request, BuildContext context) async {
    debugPrint("SaveProfileRequest::${request}");
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-profile"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> getProfile(dynamic request,BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/profile"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> getQuestionList(
      dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/questions"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveOnlineStatus(
      dynamic request, BuildContext context) async {
    var response = await Session.postOnlineStatus(
      Uri.parse("${Env.baseurl}/save-online-status"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> deleteAccount(
      dynamic request, BuildContext context) async {
    var response = await Session.postDeleteAccount(
      Uri.parse("${Env.baseurl}/account-delete"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveUserQA(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-user-qa"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> findList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/find-list"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> matchList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/match-list"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> likedYouList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/liked-you-list"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> likedProfilesList(
      dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/liked-profiles-list"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> blockedProfilesList(
      dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/blocked-list"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> packagesList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/packages"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> pointsList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/points"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> likesList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/likes"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> rewindsList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/rewinds"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> whatNewsList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/what-news"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> ezPayment(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/ez-payment"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> purchaseHistory(
      dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/purchase-history"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> countryList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/country"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> cityList(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/city"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> forgotPassword(dynamic request, BuildContext context) async {
    var response = await Session.postWithoutAuth(
      Uri.parse("${Env.baseurl}/forgot-password"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveProfileReact(
      dynamic request, BuildContext context) async {
    debugPrint("Request:::$request");
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-react"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> buyWithPoint(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/buy-with-point"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> buySettingWithPoint(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/buy-setting-with-point"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> getMoreDetailsQuestions(BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/moredetails"),
      jsonEncode({}),
      context,
      ref,
    );
    return response;
  }

  Future<Response> addInterests(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/add-interest"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }
  Future<Response> deleteInterest(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/delete-interest"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> deleteMoreDetailsAnswer(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/delete-moredetail-answer"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> updateMoreDetailsAnswer(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/update-moredetail-answer"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> deleteUploadPhoto(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/delete-profile-photo"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> uploadPhoto(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/upload-profile-photo"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveSupabaseUserId(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-supabase-user-id"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> getProfileBuiderQuestion(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/get-question-builder"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveProfileBuiderQuestion(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-question-builder"),
      jsonEncode(request),
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveReport(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-report"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> getInterests(BuildContext context) async {
    var response = await Session.get(
      Uri.parse("${Env.baseurl}/interests"),
      context,
      ref,
    );
    return response;
  }

  Future<Response> getConfig(BuildContext context) async {
    var response = await Session.get(
      Uri.parse("${Env.baseurl}/config"),
      context,
      ref,
    );
    return response;
  }

}
