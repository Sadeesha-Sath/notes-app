import 'package:flutter/cupertino.dart';

class InheritedPreferences extends InheritedWidget {
  InheritedPreferences({
    Key? key,
    required this.preferences,
    required Widget child,
  }) : super(key: key, child: child);

  final Map<String, bool?> preferences;

  // InheritedPreferences.fromJson({
  //   required Map<String, dynamic> preferencesDynamic,
  //   required Widget child,
  //   Key? key,
  // })  : preferences = preferencesDynamic.cast(),
  //       super(key: key, child: child);

  static InheritedPreferences? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPreferences>();
  }

  @override
  bool updateShouldNotify(InheritedPreferences oldWidget) {
    return true;
  }
}
