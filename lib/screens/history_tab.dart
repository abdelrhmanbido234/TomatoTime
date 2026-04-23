import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_time/providers/app_state.dart';
import 'package:intl/intl.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    
    // Group history by date (ignoring time)
    final Map<String, List<SessionRecord>> groupedHistory = {};
    for (var session in appState.history) {
      final dateKey = DateFormat('MMM d, yyyy').format(session.date);
      if (!groupedHistory.containsKey(dateKey)) {
        groupedHistory[dateKey] = [];
      }
      groupedHistory[dateKey]!.add(session);
    }
    
    // Sort keys descending (newest first)
    final sortedKeys = groupedHistory.keys.toList()
      ..sort((a, b) => DateFormat('MMM d, yyyy').parse(b).compareTo(DateFormat('MMM d, yyyy').parse(a)));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined, 
                  color: isDark ? Colors.white : Colors.black87,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Session History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (sortedKeys.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'No sessions yet. Start working to see your history!',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              )
            else
              ...sortedKeys.map((dateStr) {
                final sessions = groupedHistory[dateStr]!;
                final totalMin = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
                
                return _buildHistoryDayRow(dateStr, sessions, totalMin, isDark);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDayRow(String date, List<SessionRecord> sessions, int totalMinutes, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 2,
            height: 48,
            color: isDark ? const Color(0xFF374151) : Colors.grey.shade300,
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      '${sessions.length} sessions • ${totalMinutes}min',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: sessions.map((s) {
                    Color boxColor;
                    switch (s.mode) {
                      case TimerMode.work:
                        boxColor = const Color(0xFFFA5252);
                        break;
                      case TimerMode.shortBreak:
                        boxColor = const Color(0xFF69D788);
                        break;
                      case TimerMode.longBreak:
                        boxColor = const Color(0xFF8AB4F8);
                        break;
                    }
                    return Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
