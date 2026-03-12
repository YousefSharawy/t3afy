// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:t3afy/app/resources/color_manager.dart';
// import 'package:t3afy/app/resources/font_manager.dart';
// import 'package:t3afy/app/resources/style_manager.dart';
// import 'package:t3afy/app/resources/values_manager.dart';


// class UiUtils {
//   // ==================== TOAST MESSAGES ====================
//   static void showMessage(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: ColorManager.primaryText,
//       textColor: ColorManager.white,
//     );
//   }

//   static void showErrorMessage(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: ColorManager.error,
//       textColor: ColorManager.white,
//     );
//   }

//   static void showSuccessMessage(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: ColorManager.success,
//       textColor: ColorManager.white,
//     );
//   }

//   static void showInfoMessage(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: ColorManager.tealSoft,
//       textColor: ColorManager.primaryText,
//       fontSize: FontSize.s14,
//     );
//   }

//   // ==================== LOADING DIALOG ====================

//   static void showLoading(BuildContext context, {String? message}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       useRootNavigator: true,
//       builder:
//           (_) => PopScope(
//             canPop: false,
//             child: Center(
//               child: Container(
//                 padding: EdgeInsets.all(24.sp),
//                 decoration: BoxDecoration(
//                   color: ColorManager.white,
//                   borderRadius: BorderRadius.circular(AppRadius.s16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const CustomLoadingIndicator(),
//                     SizedBox(height: AppHeight.s16),
//                     Text(
//                       "Loading",
//                       style: getBoldStyle(
//                         fontSize: FontSize.s20,
//                         fontFamily: FontConstants.interFamily,
//                         color: ColorManager.primaryText,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );
//   }

//   static void hideLoading(BuildContext context) {
//     final navigator = Navigator.of(context, rootNavigator: true);
//     if (navigator.canPop()) {
//       navigator.pop();
//     }
//   }

//   static Widget loadingWidget({double? size}) {
//     return Center(
//       child: SizedBox(
//         width: size ?? AppWidth.s40,
//         height: size ?? AppHeight.s40,
//         child: const CustomLoadingIndicator(),
//       ),
//     );
//   }

//   static Widget loadingCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: AppHeight.s50),
//       decoration: cardDecoration(),
//       child: const Center(child: CustomLoadingIndicator()),
//     );
//   }

//   static Widget shimmerLoading({
//     required double width,
//     required double height,
//     double? borderRadius,
//   }) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: ColorManager.grey.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.s8),
//       ),
//     );
//   }


// }
