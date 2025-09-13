import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButtonOutline extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? borderColor;
  final bool isLoading;
  final String? icon;
  final double? size;
  final bool isFullRow;

  const CustomButtonOutline({
    Key? key,
    required this.text,
    this.icon,
    this.isFullRow = true,
    this.size,
    required this.onPressed,
    required this.isLoading,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final outlineColor = borderColor ?? colorScheme.primary;

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineColor.withOpacity(0.6), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(0, 45),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: outlineColor.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            SvgPicture.asset(
              "assets/icons/$icon.svg",
              width: 22,
              color: outlineColor,
            ),
          if (isLoading) const SizedBox(width: 8),
          if (isLoading)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: outlineColor,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: size ?? 16,
              color: outlineColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return isFullRow ? SizedBox(width: double.infinity, child: button) : button;
  }
}

