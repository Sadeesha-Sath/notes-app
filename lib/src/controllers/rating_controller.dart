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
      minDays: 5,
      minLaunches: 10,
      remindDays: 6,
      remindLaunches: 7,
    );
    instance.init().then((value) {
      _rateMyApp.value = instance;
      if (_rateMyApp.value != null) {
        var launches = _rateMyApp.value!.conditions.whereType<MinimumAppLaunchesCondition>().first;
        print("Current Launches:    ${launches.launches}");
        print("Minimum Launches:    ${launches.minLaunches}");
        print(
            "Do not Open Again Condition:    ${_rateMyApp.value!.conditions.whereType<DoNotOpenAgainCondition>().first.doNotOpenAgain}");
        print("is conditions met :   ${_rateMyApp.value!.shouldOpenDialog}");
        showWillRateDialog();
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
    return TextButton(
      child: Text(
        Platform.isAndroid ? "OK" : "Ok",
      ),
      onPressed: () async {
        final event = RateMyAppEventType.rateButtonPressed;
        var result = await _rateMyApp.value!.launchStore();
        print(result);
        if (result != LaunchStoreResult.errorOccurred) {
          await _rateMyApp.value!.callEvent(event);
        }
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thank you for your kind rating"),
          ),
        );
        if (stars < 4) {
          // ? Redirect to review page after user finishes rating
          // TODO Make review
          // Get.toNamed(UnlockLockedNotesScreen.id);
        }
      },
    );
  }

  Widget buildCancelButton() {
    return RateMyAppLaterButton(
      _rateMyApp.value!,
      text: Platform.isAndroid ? "CANCEL" : "Cancel",
      callback: () {
        reset();
      },
    );
  }

  Future<void> reset() async {
    if (_rateMyApp.value != null) {
      _rateMyApp.value!.reset();
    }
  }
}
