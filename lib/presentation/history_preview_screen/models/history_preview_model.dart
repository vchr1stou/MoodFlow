import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'history_preview_item_model.dart';

// ignore_for_file: must_be_immutable
class HistoryPreviewModel {
  String? mood;
  String? time;
  String? date;
  List<String>? photos;
  List<String>? positiveFeelings;
  List<String>? negativeFeelings;
  Map<String, dynamic>? spotifyTrack;
  List<String>? toggledIcons;
  List<Map<String, dynamic>>? contacts;
  List<HistoryPreviewItemModel> historyPreviewItemList;

  HistoryPreviewModel({
    this.mood,
    this.time,
    this.date,
    this.photos,
    this.positiveFeelings,
    this.negativeFeelings,
    this.spotifyTrack,
    this.toggledIcons,
    this.contacts,
    this.historyPreviewItemList = const [],
  });
}
