enum EventCategory { conference, wedding, birthday, networking, music, sports, workshop, festival }

extension EventCategoryExt on EventCategory {
  String get label => const {
        EventCategory.conference: 'Conference',
        EventCategory.wedding: 'Wedding',
        EventCategory.birthday: 'Birthday',
        EventCategory.networking: 'Networking',
        EventCategory.music: 'Music',
        EventCategory.sports: 'Sports',
        EventCategory.workshop: 'Workshop',
        EventCategory.festival: 'Festival',
      }[this]!;

  String get emoji => const {
        EventCategory.conference: '🎤',
        EventCategory.wedding: '💍',
        EventCategory.birthday: '🎂',
        EventCategory.networking: '🤝',
        EventCategory.music: '🎵',
        EventCategory.sports: '⚽',
        EventCategory.workshop: '🛠️',
        EventCategory.festival: '🎪',
      }[this]!;

  int get colorIndex => index;
}

enum EventStatus { upcoming, ongoing, past, cancelled }

extension EventStatusExt on EventStatus {
  String get label => const {
        EventStatus.upcoming: 'Upcoming',
        EventStatus.ongoing: 'Ongoing',
        EventStatus.past: 'Past',
        EventStatus.cancelled: 'Cancelled',
      }[this]!;
}

class Event {
  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final DateTime date;
  final String time;
  final String location;
  final String organizer;
  final int attendees;
  final int maxAttendees;
  final double price;
  final List<String> tags;
  final String emoji;
  final bool isFeatured;
  bool isRegistered;
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.attendees,
    required this.maxAttendees,
    required this.price,
    required this.tags,
    required this.emoji,
    this.isFeatured = false,
    this.isRegistered = false,
    this.isFavorite = false,
  });

  EventStatus get status {
    final now = DateTime.now();
    if (date.isBefore(now)) return EventStatus.past;
    if (date.difference(now).inDays <= 0) return EventStatus.ongoing;
    return EventStatus.upcoming;
  }

  bool get isFull => attendees >= maxAttendees;
  double get fillRate => (attendees / maxAttendees).clamp(0, 1);
  bool get isFree => price == 0;
}

class EventTask {
  final String title;
  bool isDone;
  final DateTime? dueDate;

  EventTask({required this.title, this.isDone = false, this.dueDate});
}
