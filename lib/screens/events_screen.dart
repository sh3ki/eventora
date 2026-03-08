import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventCategory? _selected;
  final _search = TextEditingController();
  String _query = '';

  List<Event> get _filtered {
    var list = _selected == null ? MockData.events : MockData.byCategory(_selected!);
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((e) => e.title.toLowerCase().contains(q) || e.tags.any((t) => t.toLowerCase().contains(q))).toList();
    }
    return list;
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(title: const Text('Browse Events'), backgroundColor: Colors.white, elevation: 0),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() { _query = ''; _search.clear(); })) : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true, fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _Pill('All', _selected == null, () => setState(() => _selected = null)),
                      ...MockData.allCategories.map((cat) => _Pill(
                        '${cat.emoji} ${cat.label}', _selected == cat,
                        () => setState(() => _selected = _selected == cat ? null : cat),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final e = _filtered[i];
                return EventCard(
                  event: e,
                  compact: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: e))),
                  onFavoriteToggle: (_) => setState(() => e.isFavorite = !e.isFavorite),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _Pill(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.grey[700])),
      ),
    );
  }
}
