import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool lightText;

  const AppLogo({super.key, this.size = 48, this.showText = true, this.lightText = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Center(child: Text('🎪', style: TextStyle(fontSize: size * 0.52))),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: 'Event', style: TextStyle(fontFamily: 'DM Sans', fontSize: size * 0.48, fontWeight: FontWeight.w800, color: lightText ? Colors.white : AppTheme.primary)),
              TextSpan(text: 'ora', style: TextStyle(fontFamily: 'DM Sans', fontSize: size * 0.48, fontWeight: FontWeight.w400, color: lightText ? Colors.white70 : AppTheme.secondary)),
            ]),
          ),
        ],
      ],
    );
  }
}
