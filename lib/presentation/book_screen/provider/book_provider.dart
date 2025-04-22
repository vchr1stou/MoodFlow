import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/book_model.dart';

/// A provider class for the BookScreen.
///
/// This provider manages the state of the BookScreen, including the
/// current bookModelObj

// ignore_for_file: must_be_immutable
class BookProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();

  BookModel bookModelObj = BookModel();

  @override
  void dispose() {
    super.dispose();
    searchfieldoneController.dispose();
  }
}
