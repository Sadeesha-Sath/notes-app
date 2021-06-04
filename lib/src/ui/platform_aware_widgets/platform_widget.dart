import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class PlatformWidget<M extends Widget, C extends Widget> extends StatelessWidget {
  PlatformWidget({Key? key}) : super(key: key);

  C buildCupertinoWidget(BuildContext context);
  M buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // return material widget if platform is android
      return buildMaterialWidget(context);
    }
    //else return cupertino widget
    else if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    }
    // TODO Implement more widgets for more platforms
    // ! A placeholder until other platforms are added
    return buildMaterialWidget(context);
  }
}
