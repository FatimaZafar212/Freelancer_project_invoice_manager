import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../clients/client_list_screen.dart';
import '../projects/project_list_screen.dart';
import '../invoices/invoice_list_screen.dart';
import '../meetings/meetings_screen.dart';
import '../meetings/add_meeting_screen.dart';
import '../../utils/constants.dart';
import '../../widgets/illustration_header.dart';
import '../../widgets/reminder_banner.dart';
import '../../services/meeting_reminder_service.dart';
import '../../theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _svc = MeetingReminderService();

  @override
  void initState() {
    super.initState();
    // Check reminders immediately on dashboard open
    _svc.checkReminders();
    // Listen to reminder updates to force rebuild
    _svc.activeReminders.addListener(_onReminderChange);
  }

  void _onReminderChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _svc.activeReminders.removeListener(_onReminderChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _svc.activeReminders.value;
    final upcomingMeetings = _svc.upcomingMeetings.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MeetingsScreen())),
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=u1'),
            radius: 16,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IllustrationHeader(
              icon: Icons.waving_hand_rounded,
              title: 'Welcome back!',
              subtitle:
                  'Here is what is happening with your freelance business today.',
              gradientColors: [Color(0xFF6B48FF), Color(0xFF9075FF)],
            ),
            const SizedBox(height: 20),

            // ── Reminder Banner ────────────────────────────────────────────
            if (reminders.isNotEmpty) ReminderBanner(reminders: reminders),

            // ── Overview ──────────────────────────────────────────────────
            const SizedBox(height: 12),
            const Text('Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildVividSummaryCard(context, 'Clients',
                        dummyClients.length.toString(), Icons.people, primaryColor)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildVividSummaryCard(context, 'Projects',
                        dummyProjects.length.toString(), Icons.work, secondaryColor)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildVividSummaryCard(context, 'Invoices',
                        dummyInvoices.length.toString(), Icons.receipt,
                        const Color(0xFF03DAC6))),
              ],
            ),
            const SizedBox(height: 32),

            // ── Quick Access ──────────────────────────────────────────────
            const Text('Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(context, 'Clients', Icons.people_outline,
                    const ClientListScreen()),
                _buildQuickAction(context, 'Projects', Icons.work_outline,
                    const ProjectListScreen()),
                _buildQuickAction(context, 'Invoices', Icons.receipt_long_outlined,
                    const InvoiceListScreen()),
                _buildQuickAction(context, 'Meetings',
                    Icons.calendar_month_outlined, const MeetingsScreen()),
              ],
            ),
            const SizedBox(height: 32),

            // ── Upcoming Meetings ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Upcoming Meetings',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MeetingsScreen())),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (upcomingMeetings.isEmpty)
              _buildNoMeetingsCard(context)
            else
              ...upcomingMeetings.map((m) => _buildMeetingTile(context, m)),
            const SizedBox(height: 32),

            // ── Monthly Income ────────────────────────────────────────────
            const Text('Monthly Income',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final style = TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Jan';
                              break;
                            case 1:
                              text = 'Feb';
                              break;
                            case 2:
                              text = 'Mar';
                              break;
                            case 3:
                              text = 'Apr';
                              break;
                            case 4:
                              text = 'May';
                              break;
                            case 5:
                              text = 'Jun';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: style));
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(0, 5000),
                    _buildBarGroup(1, 7000),
                    _buildBarGroup(2, 4000),
                    _buildBarGroup(3, 8000),
                    _buildBarGroup(4, 6000),
                    _buildBarGroup(5, 9000),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMeetingsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AddMeetingScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: primaryColor.withValues(alpha: 0.15),
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: primaryColor.withValues(alpha: 0.5)),
            const SizedBox(width: 8),
            Text('No upcoming meetings — tap to schedule one',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTile(BuildContext context, Meeting meeting) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('EEE, MMM d • h:mm a');
    final svc = MeetingReminderService();
    final isReminderDue = meeting.isReminderDue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: isReminderDue
            ? Border.all(color: Colors.orange.withValues(alpha: 0.6), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: isReminderDue
                  ? const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFFFAB40)])
                  : LinearGradient(
                      colors: [primaryColor, theme.colorScheme.secondary]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
                isReminderDue
                    ? Icons.notifications_active_rounded
                    : Icons.video_call_rounded,
                color: Colors.white,
                size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meeting.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(timeFormat.format(meeting.scheduledAt),
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (isReminderDue)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('⏰',
                  style: TextStyle(fontSize: 14)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                svc.clientNameFor(meeting.clientId) ?? meeting.reminder.label,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: primaryColor,
          width: 16,
          borderRadius: BorderRadius.circular(8),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10000,
            color: primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildVividSummaryCard(BuildContext context, String title,
      String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(title,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, String title, IconData icon, Widget screen) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}