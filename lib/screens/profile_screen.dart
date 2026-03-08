import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifs = true;
  bool _reminders = true;

  @override
  Widget build(BuildContext context) {
    final favCount = MockData.favorites.length;
    final regCount = MockData.registered.length;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppTheme.heroGradient),
                child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                    child: const Center(child: Text('🎪', style: TextStyle(fontSize: 38))),
                  ),
                  const SizedBox(height: 8),
                  const Text('Jordan Parker', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const Text('Event Enthusiast', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ])),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.softShadow),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _Stat('${MockData.events.length}', 'Events'),
                      _Div(),
                      _Stat('$regCount', 'Registered'),
                      _Div(),
                      _Stat('$favCount', 'Favorites'),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  const Text('Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.softShadow),
                    child: Column(children: [
                      ListTile(
                        leading: Icon(Icons.notifications_outlined, color: AppTheme.primary),
                        title: const Text('Event Notifications', style: TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Switch(value: _notifs, onChanged: (v) => setState(() => _notifs = v), activeColor: AppTheme.primary),
                      ),
                      Divider(height: 1, color: Colors.grey[100]),
                      ListTile(
                        leading: Icon(Icons.alarm_outlined, color: AppTheme.primary),
                        title: const Text('Day-Before Reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Switch(value: _reminders, onChanged: (v) => setState(() => _reminders = v), activeColor: AppTheme.primary),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.softShadow),
                    child: Column(children: [
                      _Item(Icons.share_outlined, 'Share Eventora', () {}),
                      Divider(height: 1, color: Colors.grey[100]),
                      _Item(Icons.help_outline, 'Help & Support', () {}),
                      Divider(height: 1, color: Colors.grey[100]),
                      _Item(Icons.info_outline, 'About', () => showAboutDialog(context: context, applicationName: 'Eventora', applicationVersion: '1.0.0')),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Center(child: Text('Eventora v1.0.0  ·  Plan. Connect. Celebrate.', style: TextStyle(color: Colors.grey[400], fontSize: 12))),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary)),
    Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
  ]);
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: Colors.grey[200]);
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Item(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: AppTheme.primary),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
  );
}
