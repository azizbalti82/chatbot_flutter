import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void _showToast({
    required String message,
    required BuildContext context,
    required Color primaryColor,
    required Color backgroundColor,
    required ToastificationType type,
    IconData? icon,
    int autoCloseSeconds = 3,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: Duration(seconds: autoCloseSeconds),
      title: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        maxLines: 10,
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 500),
      icon: icon != null ? Icon(icon) : null,
      showIcon: false,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  static void showError(String message, BuildContext context, {int autoCloseSeconds = 3}) {
    _showToast(
      message: message,
      context: context,
      primaryColor: Colors.red,
      backgroundColor: Colors.red.withOpacity(0.05),
      type: ToastificationType.error,
      icon: Icons.warning_amber,
      autoCloseSeconds: autoCloseSeconds,
    );
  }

  static void showSuccess(String message, BuildContext context) {
    _showToast(
      message: message,
      context: context,
      primaryColor: Colors.green,
      backgroundColor: Colors.green.withOpacity(0.05),
      type: ToastificationType.success,
      icon: Icons.check,
    );
  }

  static void showMsg(String message, BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;

    _showToast(
      message: message,
      context: context,
      primaryColor: accentColor,
      backgroundColor: accentColor.withOpacity(0.05),
      type: ToastificationType.info,
    );
  }

}
