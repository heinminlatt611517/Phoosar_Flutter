import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/env/env.dart';
import 'session.dart';
import 'package:http/http.dart';

class Repository {
  final Ref ref;
  Repository(this.ref);
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

  Future<Response> sendOTP(dynamic request, BuildContext context) async {
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

  Future<Response> socialLogin(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/social-login"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveProfile(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-profile"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> getProfile(BuildContext context) async {
    var response = await Session.get(
      Uri.parse("${Env.baseurl}/profile"),
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
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-online-status"),
      request,
      context,
      ref,
    );
    return response;
  }

  Future<Response> saveUserQA(dynamic request, BuildContext context) async {
    var response = await Session.post(
      Uri.parse("${Env.baseurl}/save-user-qa"),
      request,
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
}
