import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/event_data.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';
import 'event_detail_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<EventTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tasks = EventData.plannerTasks;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registered = EventData.registered;
    final favorites = EventData.favorites;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Text(
                'My Planner',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppTheme.cardShadow,
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                dividerHeight: 0,
                tabs: const [
                  Tab(text: 'My Events'),
                  Tab(text: 'Tasks'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // My Events tab
                  _buildEventsTab(registered, favorites),
                  // Tasks tab
                  _buildTasksTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab(List<Event> registered, List<Event> favorites) {
    if (registered.isEmpty && favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_note, size: 56, color: AppTheme.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              'No events in your planner',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Register or favorite events to see them here',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (registered.isNotEmpty) ...[
          _SectionHeader(title: 'Registered', count: registered.length),
          const SizedBox(height: 8),
          ...registered.map((e) => _PlannerEventTile(
            event: e,
            badge: 'REGISTERED',
            badgeColor: AppTheme.success,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => EventDetailScreen(event: e),
            )),
          )),
        ],
        if (favorites.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(title: 'Favorites', count: favorites.length),
          const SizedBox(height: 8),
          ...favorites.map((e) => _PlannerEventTile(
            event: e,
            badge: 'FAVORITE',
            badgeColor: AppTheme.accent,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => EventDetailScreen(event: e),
            )),
          )),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTasksTab() {
    final pending = _tasks.where((t) => !t.isDone).toList();
    final done = _tasks.where((t) => t.isDone).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Quick stats
        Row(
          children: [
            _StatChip(label: 'Pending', value: '${pending.length}', color: AppTheme.accent),
            const SizedBox(width: 10),
            _StatChip(label: 'Done', value: '${done.length}', color: AppTheme.success),
          ],
        ),
        const SizedBox(height: 16),
        if (pending.isNotEmpty) ...[
          _SectionHeader(title: 'To Do', count: pending.length),
          const SizedBox(height: 8),
          ...pending.map((task) => _TaskTile(
            task: task,
            onToggle: () => setState(() => task.isDone = !task.isDone),
          )),
        ],
        if (done.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(title: 'Completed', count: done.length),
          const SizedBox(height: 8),
          ...done.map((task) => _TaskTile(
            task: task,
            onToggle: () => setState(() => task.isDone = !task.isDone),
          )),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary),
          ),
        ),
      ],
    );
  }
}

class _PlannerEventTile extends StatelessWidget {
  final Event event;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _PlannerEventTile({
    required this.event,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = AppTheme.categoryColors[event.category.colorIndex];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Date block
            Container(
              width: 50, height: 54,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM').format(event.date).toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: catColor),
                  ),
                  Text(
                    '${event.date.day}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: catColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.location,
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(color: badgeColor, fontWeight: FontWeight.w800, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final EventTask task;
  final VoidCallback onToggle;

  const _TaskTile({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: task.isDone ? AppTheme.success : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: task.isDone ? AppTheme.success : AppTheme.textSecondary.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: task.isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: task.isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (task.dueDate != null)
            Text(
              DateFormat('MMM d').format(task.dueDate!),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: task.dueDate!.isBefore(DateTime.now()) && !task.isDone
                    ? AppTheme.error
                    : AppTheme.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
