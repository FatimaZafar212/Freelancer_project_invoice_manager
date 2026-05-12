import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/meeting_reminder_service.dart';
import '../../utils/constants.dart';
import '../../theme/theme.dart';
import 'add_meeting_screen.dart';

class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddMeetingScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddMeetingScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Schedule Meeting'),
      ),
      body: ValueListenableBuilder<List<Meeting>>(
        valueListenable: MeetingReminderService().meetings,
        builder: (context, meetings, _) {
          final upcoming = MeetingReminderService().upcomingMeetings;
          final past = MeetingReminderService().pastMeetings;

          if (meetings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available_outlined,
                      size: 80, color: primaryColor.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No meetings scheduled',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Tap the button below to schedule your first meeting.',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5)),
                      textAlign: TextAlign.center),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              if (upcoming.isNotEmpty) ...[
                _sectionHeader('Upcoming', Icons.upcoming_rounded, primaryColor),
                ...upcoming
                    .map((m) => _MeetingCard(meeting: m, isPast: false)),
                const SizedBox(height: 8),
              ],
              if (past.isNotEmpty) ...[
                _sectionHeader('Past', Icons.history_rounded, Colors.grey),
                ...past.map((m) => _MeetingCard(meeting: m, isPast: true)),
              ],
              const SizedBox(height: 80), // space for FAB
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final bool isPast;

  const _MeetingCard({required this.meeting, required this.isPast});

  @override
  Widget build(BuildContext context) {
    final svc = MeetingReminderService();
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, MMM d • h:mm a');
    final clientName = svc.clientNameFor(meeting.clientId);
    final projectTitle = svc.projectTitleFor(meeting.projectId);
    final isReminderDue = meeting.isReminderDue;

    return Dismissible(
      key: Key(meeting.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Meeting?'),
            content: Text('Remove "${meeting.title}"?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red),
                  child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (_) => svc.deleteMeeting(meeting.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: isReminderDue
              ? Border.all(color: Colors.orange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Color dot / status indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPast
                          ? Colors.grey
                          : isReminderDue
                              ? Colors.orange
                              : primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      meeting.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: meeting.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: isPast
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                  ),
                  if (isReminderDue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.4)),
                      ),
                      child: const Text('⏰ Reminder Due',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(dateFormat.format(meeting.scheduledAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              if (clientName != null || projectTitle != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (clientName != null) ...[
                      const Icon(Icons.person_outline_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(clientName,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13)),
                      if (projectTitle != null)
                        const Text('  ·  ',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                    if (projectTitle != null) ...[
                      const Icon(Icons.work_outline_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(projectTitle,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ],
                ),
              ],
              if (meeting.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(meeting.description,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reminder chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.notifications_outlined,
                          size: 13, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(meeting.reminder.label,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  // Mark done (only for upcoming)
                  if (!isPast && !meeting.isDone)
                    TextButton.icon(
                      onPressed: () =>
                          MeetingReminderService().markDone(meeting.id),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Done',
                          style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
