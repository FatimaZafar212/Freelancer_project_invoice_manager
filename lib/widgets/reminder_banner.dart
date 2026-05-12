import 'package:flutter/material.dart';
import '../services/meeting_reminder_service.dart';
import '../utils/constants.dart';
import '../screens/meetings/meetings_screen.dart';
import 'package:intl/intl.dart';

/// An in-app dismissible reminder banner shown when a meeting's
/// reminder window is active. Displayed at the top of the Dashboard.
class ReminderBanner extends StatelessWidget {
  final List<Meeting> reminders;
  const ReminderBanner({super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) return const SizedBox.shrink();
    final meeting = reminders.first; // show the most urgent one
    final timeFormat = DateFormat('h:mm a');
    final timeLeft = meeting.scheduledAt.difference(DateTime.now());
    final String timeLeftLabel = _formatTimeLeft(timeLeft);

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const MeetingsScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFFFAB40)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Text('⏰', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Starts at ${timeFormat.format(meeting.scheduledAt)} · $timeLeftLabel',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.close_rounded, color: Colors.white, size: 20),
              onPressed: () =>
                  MeetingReminderService().dismissReminder(meeting.id),
              tooltip: 'Dismiss',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeLeft(Duration d) {
    if (d.inMinutes <= 0) return 'Now!';
    if (d.inMinutes < 60) return 'in ${d.inMinutes} min';
    if (d.inHours < 24) return 'in ${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return 'in ${d.inDays} day${d.inDays > 1 ? 's' : ''}';
  }
}
