//match list provider
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/request/profile_save_request.dart';
import 'package:phoosar/src/data/response/find_list_response.dart';
import 'package:phoosar/src/data/response/match_list_response.dart';
import 'package:phoosar/src/data/response/package_list_response.dart';
import 'package:phoosar/src/data/response/point_list_response.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/data/response/purchase_history_list_response.dart';
import 'package:phoosar/src/data/response/whats_new_list_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';

final findListProvider = FutureProvider.family<List<ProfileData>, BuildContext>(
    (ref, context) async {
  final repository = ref.watch(repositoryProvider);
  final response = await repository.findList(jsonEncode({}), context);
  if (response.statusCode == 200) {
    return FindListResponse.fromJson(jsonDecode(response.body)).data ?? [];
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

final whatsNewProvider = FutureProvider.family<List<WhatsNewData>, BuildContext>((ref, context) async {
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

final profileSaveRequestProvider = StateProvider<ProfileSaveRequest>((ref) {
  return ProfileSaveRequest();
});
