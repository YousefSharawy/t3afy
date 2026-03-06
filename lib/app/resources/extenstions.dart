import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

import 'constants_manager.dart';
import 'font_manager.dart';
import 'style_manager.dart';

enum Toast { error, success, info, warning }

extension ToastExtenstion on Toast {
  void show(BuildContext context, {required String title}) {
    final style = getSemiBoldStyle(fontSize: FontSize.s14);
    const toastDuration = Duration(seconds: ConstantsManager.splashTimer);
    switch (this) {
      case Toast.error:
        return CherryToast.error(
          title: Text(title, style: style),
          toastDuration: toastDuration,
        ).show(context);
      case Toast.success:
        return CherryToast.success(
          title: Text(title, style: style),
          toastDuration: toastDuration,
        ).show(context);
      case Toast.info:
        return CherryToast.info(
          title: Text(title, style: style),
          toastDuration: toastDuration,
        ).show(context);
      case Toast.warning:
        return CherryToast.warning(
          title: Text(title, style: style),
          toastDuration: toastDuration,
        ).show(context);
    }
  }
}
