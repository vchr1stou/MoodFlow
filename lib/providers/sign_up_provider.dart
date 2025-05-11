import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  String? name;
  String? pronouns;
  String? email;
  String? password;
  List<String> dailyCheckInTimes = [];
  String? spotifyToken;

  void updateStepOneData(String name, String pronouns, String email, String password) {
    this.name = name;
    this.pronouns = pronouns;
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  void updateStepTwoData(List<String> dailyCheckInTimes) {
    this.dailyCheckInTimes = dailyCheckInTimes;
    notifyListeners();
  }

  void updateStepThreeData(String spotifyToken) {
    this.spotifyToken = spotifyToken;
    notifyListeners();
  }

  void updateStepFourData(String spotifyToken) {
    this.spotifyToken = spotifyToken;
    notifyListeners();
  }
}