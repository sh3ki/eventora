import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;
  final bool compact;

  const EventCard({super.key, required this.event, this.onTap, this.onFavoriteToggle, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return compact
        ? _CompactCard(event: event, onTap: onTap, onFavoriteToggle: onFavoriteToggle)
        : _FullCard(event: event, onTap: onTap, onFavoriteToggle: onFavoriteToggle);
  }
}

class _FullCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;

  const _FullCard({required this.event, this.onTap, this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.categoryColors[event.category.colorIndex % AppTheme.categoryColors.length];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Center(child: Text(event.emoji, style: const TextStyle(fontSize: 52))),
                  Positioned(top: 10, left: 10, child: _StatusBadge(status: event.status)),
                  Positioned(top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => onFavoriteToggle?.call(!event.isFavorite),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(event.isFavorite ? Icons.favorite : Icons.favorite_border, color: event.isFavorite ? Colors.red : Colors.grey, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.category.label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(DateFormat('MMM d, yyyy').format(event.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(event.location, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text(event.isFree ? 'FREE' : '\$${event.price.toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.w800, color: event.isFree ? AppTheme.success : AppTheme.primary, fontSize: 14)),
                    const Spacer(),
                    Text('${event.attendees} attending', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;

  const _CompactCard({required this.event, this.onTap, this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.categoryColors[event.category.colorIndex % AppTheme.categoryColors.length];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(event.emoji, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _CategoryDot(color: color),
                    const SizedBox(width: 4),
                    Text(event.category.label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
                  ]),
                  const SizedBox(height: 3),
                  Text(event.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('${DateFormat('MMM d').format(event.date)} • ${event.time}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(event.isFree ? 'FREE' : '\$${event.price.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.w800, color: event.isFree ? AppTheme.success : AppTheme.primary, fontSize: 13)),
                const SizedBox(height: 4),
                if (event.isRegistered)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Text('Registered', style: TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final EventStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
      child: Text(status.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

class _CategoryDot extends StatelessWidget {
  final Color color;
  const _CategoryDot({required this.color});

  @override
  Widget build(BuildContext context) => Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
