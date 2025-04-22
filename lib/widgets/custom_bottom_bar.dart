import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { Home, Littlelifts }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

// ignore_for_file: must_be_immutable
class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgHouseFill1Pink100,
      activeIcon: ImageConstant.imgHouseFill1Pink100,
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgImage3,
      activeIcon: ImageConstant.imgImage3,
      title: "lbl_little_lifts".tr,
      type: BottomBarEnum.Littlelifts,
      isCircle: true,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavLittleLifts,
      activeIcon: ImageConstant.imgNavLittleLifts,
      title: "lbl_little_lifts".tr,
      type: BottomBarEnum.Littlelifts,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 14.h, right: 14.h, bottom: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
          ),
          BoxShadow(
            color: appTheme.blueGray1007f,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(1, 1.5),
          )
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          if (bottomMenuList[index].isCircle) {
            return BottomNavigationBarItem(
              icon: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                margin: EdgeInsets.zero,
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.18),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5.h),
                  borderRadius: BorderRadiusStyle.circleBorder18,
                ),
                child: Container(
                  height: 36.h,
                  decoration: AppDecoration.outline10.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder18,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].icon,
                        height: 36.h,
                        width: double.maxFinite,
                        color: appTheme.pink100,
                      ),
                      CustomImageView(
                        imagePath: bottomMenuList[index].icon,
                        height: 36.h,
                        width: double.maxFinite,
                        color: appTheme.pink100,
                      )
                    ],
                  ),
                ),
              ),
              label: '',
            );
          }
          return BottomNavigationBarItem(
            icon: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].icon,
                  height: 14.h,
                  width: 16.h,
                  color: appTheme.pink100,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.h),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: appTheme.pink100,
                      fontSize: 13.fSize,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            activeIcon: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: AppDecoration.outline11.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder18,
                    ),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: bottomMenuList[index].activeIcon,
                          height: 16.h,
                          width: 16.h,
                          color: theme.colorScheme.onPrimary,
                        ),
                        Expanded(
                          child: Text(
                            bottomMenuList[index].title ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.labelLargeOnPrimary13_1
                                .copyWith(color: theme.colorScheme.onPrimary),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
    this.isCircle = false,
  });

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
  bool isCircle;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
