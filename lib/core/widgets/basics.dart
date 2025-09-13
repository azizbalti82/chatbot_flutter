import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget simpleAppBarWidget(BuildContext context, {required Widget child}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.07), // cardColor equivalent
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            "assets/icons/close.svg",
            width: 20,
            color: colorScheme.onSurface, // textColor equivalent
          ),
        ),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: child
        ),
      ),
    ],
  );
}
Widget simpleAppBar(BuildContext context, {required String text}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.07), // cardColor equivalent
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            "assets/icons/back.svg",
            width: 20,
            color: colorScheme.onSurface, // textColor equivalent
          ),
        ),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
            softWrap: true,
          ),
        ),
      ),
      const SizedBox(width: 45),
    ],
  );
}
Widget roomAppBar(
    BuildContext context, {
      required String text,
      required VoidCallback settingsClick,
      required VoidCallback reportClick,
    }) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset(
          "assets/icons/close.svg",
          width: 21,
          color: colorScheme.onSurface,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
            softWrap: true,
          ),
        ),
      ),
      IconButton(
        onPressed: reportClick,
        icon: SvgPicture.asset(
          "assets/icons/flag.svg",
          width: 22,
          color: colorScheme.onSurface,
        ),
      ),
      IconButton(
        onPressed: settingsClick,
        icon: SvgPicture.asset(
          "assets/icons/settings.svg",
          width: 23,
          color: colorScheme.onSurface,
        ),
      ),
    ],
  );
}
