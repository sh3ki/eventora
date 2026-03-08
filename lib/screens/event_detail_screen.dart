import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final color = AppTheme.categoryColors[e.category.colorIndex % AppTheme.categoryColors.length];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: color,
            leading: BackButton(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(e.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                onPressed: () => setState(() => e.isFavorite = !e.isFavorite),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Center(child: Text(e.emoji, style: const TextStyle(fontSize: 80))),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.category.label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(e.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(e.description, style: TextStyle(color: Colors.grey[600], height: 1.6)),
                  const SizedBox(height: 20),

                  // Key info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.softShadow),
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.calendar_today_outlined, label: 'Date & Time', value: '${DateFormat('EEEE, MMMM d, yyyy').format(e.date)} at ${e.time}'),
                        const Divider(height: 20),
                        _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: e.location),
                        const Divider(height: 20),
                        _InfoRow(icon: Icons.person_outline, label: 'Organizer', value: e.organizer),
                        const Divider(height: 20),
                        _InfoRow(icon: Icons.people_outline, label: 'Attendees', value: '${e.attendees} / ${e.maxAttendees} (${(e.fillRate * 100).toInt()}% full)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Attendees progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: e.fillRate,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(e.isFull ? Colors.red : color),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(e.isFull ? '⚠️ Event is full' : '${e.maxAttendees - e.attendees} spots remaining',
                      style: TextStyle(fontSize: 12, color: e.isFull ? Colors.red : Colors.grey[600])),
                  const SizedBox(height: 20),

                  // Tags
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: e.tags.map((t) => Chip(
                      label: Text(t),
                      backgroundColor: color.withOpacity(0.1),
                      labelStyle: TextStyle(color: color, fontSize: 12),
                      padding: EdgeInsets.zero,
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: e.isFull && !e.isRegistered ? null : () => setState(() => e.isRegistered = !e.isRegistered),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: e.isRegistered ? AppTheme.success : color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        e.isRegistered ? '✓ Registered — Cancel' : e.isFull ? 'Event Full' : e.isFree ? 'Register for Free' : 'Register — \$${e.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        )),
      ],
    );
  }
}
