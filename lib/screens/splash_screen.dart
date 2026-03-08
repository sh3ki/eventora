import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween<double>(begin: 0.4, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainNavigation()));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Opacity(
                opacity: _fade.value.clamp(0, 1),
                child: Transform.scale(
                  scale: _scale.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Center(child: Text('🎪', style: TextStyle(fontSize: 56))),
                      ),
                      const SizedBox(height: 24),
                      RichText(text: const TextSpan(children: [
                        TextSpan(text: 'Event', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
                        TextSpan(text: 'ora', style: TextStyle(color: Colors.white70, fontSize: 40, fontWeight: FontWeight.w400)),
                      ])),
                      const SizedBox(height: 8),
                      const Text('Plan. Connect. Celebrate.', style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1)),
                      const SizedBox(height: 48),
                      ...['🎤 Discover Events', '📅 Manage Your Plans', '🤝 Connect With People'].map((s) =>
                        Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 15)))
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
