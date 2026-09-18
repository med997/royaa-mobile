import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

String localized(BuildContext context, {required String ar, required String en}) {
  return context.locale.languageCode == 'ar' ? ar : en;
}
