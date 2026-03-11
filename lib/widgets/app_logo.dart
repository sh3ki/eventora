import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool light;

  const AppLogo({super.key, this.size = 42, this.showText = true, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/eventora logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        if (showText) ...[
          SizedBox(width: size * 0.2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Event',
                  style: TextStyle(
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w800,
                    color: light ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'ora',
                  style: TextStyle(
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w400,
                    color: light ? Colors.white70 : AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
