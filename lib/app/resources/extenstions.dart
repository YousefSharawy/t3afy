import 'package:flutter/material.dart';
import 'package:t3afy/base/widgets/app_toast.dart';

enum Toast { error, success, info, warning }

extension ToastExtenstion on Toast {
  void show(BuildContext context, {required String title}) {
    switch (this) {
      case Toast.error:
        AppToast.show(context, message: title, type: AppToastType.error);
      case Toast.success:
        AppToast.show(context, message: title, type: AppToastType.success);
      case Toast.info:
        AppToast.show(context, message: title, type: AppToastType.info);
      case Toast.warning:
        AppToast.show(context, message: title, type: AppToastType.warning);
    }
  }
}
