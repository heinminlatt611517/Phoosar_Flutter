//match list provider
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/request/city_request.dart';
import 'package:phoosar/src/data/request/profile_save_request.dart';
import 'package:phoosar/src/data/request/question_save_request.dart';
import 'package:phoosar/src/data/response/city_list_response.dart';
import 'package:phoosar/src/data/response/country_list_response.dart';
import 'package:phoosar/src/data/response/find_response.dart';
import 'package:phoosar/src/data/response/like_list_response.dart';
import 'package:phoosar/src/data/response/liked_you_list_response.dart';
import 'package:phoosar/src/data/response/match_list_response.dart';
import 'package:phoosar/src/data/response/more_details_question_response.dart';
import 'package:phoosar/src/data/response/package_list_response.dart';
import 'package:phoosar/src/data/response/point_list_response.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/data/response/purchase_history_list_response.dart';
import 'package:phoosar/src/data/response/questions_response.dart';
import 'package:phoosar/src/data/response/rewind_list_response.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
import 'package:phoosar/src/data/response/whats_new_list_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';

final findListProvider =
    FutureProvider.family<ProfileData?, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.findList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return FindResponse.fromJson(jsonDecode(response.body)).data;
  } else {
    throw Exception('Failed to load find list');
  }
});

final matchListProvider =
    FutureProvider.family<List<MatchData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.matchList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return MatchListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final likedYouListProvider =
    FutureProvider.family<List<LikedYouData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.likedYouList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return LikedYouListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final likedProfilesListProvider =
    FutureProvider.family<List<LikedYouData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.likedProfilesList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return LikedYouListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final packageListProvider =
    FutureProvider.family<List<PackageData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.packagesList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return PackageListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final pointListProvider =
    FutureProvider.family<List<PointData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.pointsList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return PointListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final likeListProvider =
    FutureProvider.family<List<LikeData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.likesList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return LikeListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final rewindListProvider =
    FutureProvider.family<List<RewindData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.rewindsList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return RewindListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load match list');
  }
});

final whatsNewProvider =
    FutureProvider.family<List<WhatsNewData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.whatNewsList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return WhatsNewListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final purchaseHistoryProvider =
    FutureProvider.family<List<PurchaseHistoryData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.purchaseHistory(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return PurchaseHistoryListResponse.fromJson(jsonDecode(response.body))
            .data ??
        [];
  } else {
    throw Exception('Failed to load purchase history');
  }
});

final questionListProvider =
    FutureProvider.family<List<QuestionData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.getQuestionList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return QuestionsResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final countryListProvider =
    FutureProvider.family<List<CountryData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.countryList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return CountryListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final cityListProvider =
    FutureProvider.family<List<CityData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final cityRequest = ref.watch(cityRequestProvider);
  final response = await repository.cityList(jsonEncode(cityRequest), context);
  if (response.statusCode == 200) {
    return CityListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final matchCityListProvider =
    FutureProvider.family<List<CityData>, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final matchCityRequest = ref.watch(matchCityRequestProvider);
  final response =
      await repository.cityList(jsonEncode(matchCityRequest), context);
  if (response.statusCode == 200) {
    return CityListResponse.fromJson(jsonDecode(response.body)).data ?? [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final selfProfileProvider = StateProvider<SelfProfileResponse?>((ref) {
  return null; // Initial value
});

final profileDataProvider =
    FutureProvider.family<ProfileData?, BuildContext>((ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.getProfile(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return FindResponse.fromJson(jsonDecode(response.body)).data;
  } else {
    throw Exception('Failed to load profile data');
  }
});

final moreDetailsQuestionListProvider =
    FutureProvider.family<List<QuestionAnswerData>, BuildContext>(
        (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.getMoreDetailsQuestions(context);
  if (response.statusCode == 200) {
    return MoreDetailsQuestionResponse.fromJson(jsonDecode(response.body))
            .data ??
        [];
  } else {
    throw Exception('Failed to load whats new');
  }
});

final profileSaveRequestProvider = StateProvider<ProfileSaveRequest>((ref) {
  return ProfileSaveRequest();
});

final questionSaveRequestProvider = StateProvider<QuestionSaveRequest>((ref) {
  return QuestionSaveRequest();
});

final cityRequestProvider = StateProvider<CityRequest>((ref) {
  return CityRequest();
});

final matchCityRequestProvider = StateProvider<CityRequest>((ref) {
  return CityRequest();
});
