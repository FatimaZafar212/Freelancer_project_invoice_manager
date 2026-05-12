import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

/// Lightweight singleton that manages meetings and reminder state.
/// Uses ValueNotifier so any widget can react to changes with no packages.
class MeetingReminderService {
  MeetingReminderService._();
  static final MeetingReminderService instance = MeetingReminderService._();
  factory MeetingReminderService() => instance;

  /// Master list of all meetings (starts from dummy data).
  final ValueNotifier<List<Meeting>> meetings =
      ValueNotifier<List<Meeting>>(List.from(dummyMeetings));

  /// Meetings whose reminder window is currently active.
  final ValueNotifier<List<Meeting>> activeReminders =
      ValueNotifier<List<Meeting>>([]);

  // ─── CRUD ────────────────────────────────────────────────────────────────

  void addMeeting(Meeting meeting) {
    meetings.value = [...meetings.value, meeting];
    checkReminders();
  }

  void deleteMeeting(String id) {
    meetings.value = meetings.value.where((m) => m.id != id).toList();
    checkReminders();
  }

  void markDone(String id) {
    for (final m in meetings.value) {
      if (m.id == id) m.isDone = true;
    }
    meetings.value = [...meetings.value]; // trigger notifier
    checkReminders();
  }

  void dismissReminder(String id) {
    // Mark as done so reminder stops firing for this session
    markDone(id);
  }

  // ─── REMINDER LOGIC ──────────────────────────────────────────────────────

  /// Call this periodically (e.g. every 60 s) to refresh active reminders.
  void checkReminders() {
    activeReminders.value =
        meetings.value.where((m) => m.isReminderDue).toList();
  }

  // ─── GETTERS ─────────────────────────────────────────────────────────────

  List<Meeting> get upcomingMeetings =>
      meetings.value.where((m) => m.isUpcoming).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  List<Meeting> get pastMeetings =>
      meetings.value.where((m) => m.isPast).toList()
        ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

  String? clientNameFor(String? clientId) {
    if (clientId == null) return null;
    return dummyClients
        .firstWhere((c) => c.id == clientId,
            orElse: () => dummyClients.first)
        .name;
  }

  String? projectTitleFor(String? projectId) {
    if (projectId == null) return null;
    return dummyProjects
        .firstWhere((p) => p.id == projectId,
            orElse: () => dummyProjects.first)
        .title;
  }
}
