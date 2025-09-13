import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiStyleWrapper extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? navBarColor;

  const SystemUiStyleWrapper({
    super.key,
    required this.child,
    this.statusBarColor,
    this.navBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? theme.scaffoldBackgroundColor,
        statusBarIconBrightness:
        theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: navBarColor ?? theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      child: child,
    );
  }
}

