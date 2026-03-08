import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late List<EventTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tasks = MockData.plannerTasks;
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final registered = MockData.registered;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('My Planner'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: 'My Events'), Tab(text: 'Task List')],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // My Events
          registered.isEmpty
              ? _EmptyState(emoji: '📅', title: 'No events yet', subtitle: 'Register for events to see them here')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: registered.length,
                  itemBuilder: (_, i) {
                    final e = registered[i];
                    return EventCard(
                      event: e,
                      compact: true,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: e))),
                      onFavoriteToggle: (_) => setState(() => e.isFavorite = !e.isFavorite),
                    );
                  },
                ),

          // Task list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${_tasks.where((t) => t.isDone).length}/${_tasks.length} tasks completed',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() { for (final t in _tasks) t.isDone = true; }),
                      child: Text('Mark All Done', style: TextStyle(color: AppTheme.primary, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (_, i) {
                      final task = _tasks[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppTheme.softShadow),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () => setState(() => task.isDone = !task.isDone),
                            child: Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                color: task.isDone ? AppTheme.success : Colors.transparent,
                                border: Border.all(color: task.isDone ? AppTheme.success : Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: task.isDone ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone ? TextDecoration.lineThrough : null,
                              color: task.isDone ? Colors.grey : AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: task.dueDate != null
                              ? Text('Due ${DateFormat('MMM d').format(task.dueDate!)}', style: const TextStyle(fontSize: 12))
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                            onPressed: () => setState(() => _tasks.removeAt(i)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabCtrl.index == 1
          ? FloatingActionButton(
              backgroundColor: AppTheme.primary,
              onPressed: () => _showAddTask(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _showAddTask(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(hintText: 'Task name...', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  setState(() => _tasks.add(EventTask(title: ctrl.text)));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji, title, subtitle;
  const _EmptyState({required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text(subtitle, style: TextStyle(color: Colors.grey[600])),
    ]));
  }
}
