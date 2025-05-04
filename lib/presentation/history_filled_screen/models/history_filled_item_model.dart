import '../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';

/// This class is used in the [history_filled_item_widget] screen.

// ignore_for_file: must_be_immutable
class HistoryFilledItemModel {
  HistoryFilledItemModel({this.time, this.bright, this.partyintheu, this.id}) {
    time = time ?? "lbl_17_00".tr();
    bright = bright ?? "lbl_bright".tr();
    partyintheu = partyintheu ?? "msg_party_in_the_u_s_a".tr();
    id = id ?? "";
  }

  String? time;

  String? bright;

  String? partyintheu;

  String? id;
}
