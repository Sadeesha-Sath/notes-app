import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RatingController extends GetxController {
  static late final Rx<RateMyApp?> _rateMyApp = Rx<RateMyApp?>(null);
  // static const String _appStoreIdentifier = "";
  static const String _playStoreId = "com.android.chrome";

  @override
  void onInit() {
    var instance = RateMyApp(
      // appStoreIdentifier: _appStoreIdentifier,
      googlePlayIdentifier: _playStoreId,
      // ! Change these values
      minDays: 0,
      minLaunches: 1,
      remindDays: 0,
      remindLaunches: 3,
    );
    instance.init().then((value) {
      _rateMyApp.value = instance;
      if (_rateMyApp.value != null) {
        showWillRateDialog();
        // ! For debug only
        // _rateMyApp.value!.showRateDialog(Get.context!);
      }
    });

    super.onInit();
  }

  void showWillRateDialog() {
    if (_rateMyApp.value!.shouldOpenDialog) {
      _rateMyApp.value!.showRateDialog(Get.context!);
    }
  }

  void showStarRatingDialog(BuildContext context) async {
    await _rateMyApp.value!.showStarRateDialog(context,
        title: "Leave us a Rating",
        message: "Tell us how much you enjoyed using our app.",
        starRatingOptions: StarRatingOptions(
          initialRating: 4,
          minRating: 1,
        ), actionsBuilder: (context, stars) {
      if (stars == null) {
        return [buildCancelButton()];
      } else if (Platform.isAndroid) {
        return [buildCancelButton(), buildOkButton(context, stars)];
      } else {
        return [buildOkButton(context, stars), buildCancelButton()];
      }
    });
    // _rateMyApp.value!.showStarRateDialog(context);
  }

  Widget buildOkButton(BuildContext context, double stars) {
    return RateMyAppRateButton(
      _rateMyApp.value!,
      text: Platform.isAndroid ? "OK" : "Ok",
      callback: () async {
        if (stars < 3) {
          // ? Redirect to review page
          print("this one is too dangerous to be left alone");
        } else {
          await _rateMyApp.value!.launchStore();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thank you for your kind rating"),
          ),
        );
      },
    );
  }

  Widget buildCancelButton() {
    return RateMyAppLaterButton(
      _rateMyApp.value!,
      text: Platform.isAndroid ? "CANCEL" : "Cancel",
    );
  }
}
