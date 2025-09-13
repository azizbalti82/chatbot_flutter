import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? iconPath;
  final double? iconSize;
  final Color? color;
  final bool? locked;
  final BuildContext context;

  CardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.context,
    this.iconPath,
    this.iconSize,
    this.color,
    this.locked,
  });

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;

    final Color effectiveColor = color ?? Theme.of(context).colorScheme.secondary;
    final TextStyle subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
    ) ?? const TextStyle(fontSize: 13);

    return Container(
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: effectiveColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: effectiveColor.withOpacity(0.25),
              width: 2.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (iconPath != null)
                  Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(iconSize ?? 10),
                    decoration: BoxDecoration(
                      color: effectiveColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/$iconPath.svg",
                      width: iconSize ?? 30,
                      color: effectiveColor,
                    ),
                  ),
                if (iconPath != null)
                  const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: subtitleStyle,
                      ),
                    ],
                  ),
                ),
                if(locked ?? false)
                SvgPicture.asset(
                  "assets/icons/lock.svg",
                  width: 18,
                  color: errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CardSquareWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? iconPath;
  final double? iconSize;
  final bool? locked;

  const CardSquareWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconPath,
    this.iconSize,
    this.locked,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.primary;
    final Color errorColor = Theme.of(context).colorScheme.error;
    final TextStyle titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    final TextStyle subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
    ) ?? const TextStyle(fontSize: 22);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.08),
            border: Border(
              bottom: BorderSide(
                color: accentColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withOpacity(0.25),
                  width: 2.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (iconPath != null)
                      Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(iconSize ?? 10),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/$iconPath.svg",
                          width: iconSize ?? 30,
                          color: accentColor,
                        ),
                      ),
                    if (iconPath != null)
                      const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: subtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (locked == true)
          Positioned(
            top: 10,
            left: 10,
            child: SvgPicture.asset(
              "assets/icons/lock.svg",
              width: 18,
              color: errorColor,
            ),
          ),
      ],
    );
  }
}
