import '../../../core/app_export.dart';

/// This class is used in the [listmovie_time_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListmovieTimeItemModel {
  ListmovieTimeItemModel(
      {this.movieTimeOne, this.movietime, this.description, this.id}) {
    movieTimeOne = movieTimeOne ?? ImageConstant.imgPopcornFill1;
    movietime = movietime ?? "lbl_movie_time2".tr;
    description = description ?? "msg_movies_can_offer".tr;
    id = id ?? "";
  }

  String? movieTimeOne;

  String? movietime;

  String? description;

  String? id;
}
