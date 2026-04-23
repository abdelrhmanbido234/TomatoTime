import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_time/providers/app_state.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;

    final workSessions = appState.history.where((s) => s.mode == TimerMode.work).toList();
    final totalSessions = workSessions.length;
    final focusHours = workSessions.fold<double>(0, (sum, s) => sum + (s.durationMinutes / 60));

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
            Text(
              'Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Sessions', '$totalSessions', isDark)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Focus Hours', '${focusHours.toStringAsFixed(1)}h', isDark)),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Last 7 Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 24),
            _buildChart(workSessions, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151).withOpacity(0.5) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<SessionRecord> workSessions, bool isDark) {
    final borderColor = isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final gridColor = isDark ? const Color(0xFF374151) : Colors.grey.shade200;
    final textColor = isDark ? Colors.white54 : const Color(0xFF6B7280);

    // Calculate last 7 days focus hours
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final List<String> dayLabels = [];
    final List<double> dailyHours = [];

    const daysCount = 7;
    for (int i = daysCount - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      dayLabels.add(_getShortWeekday(date.weekday));
      
      final daySessions = workSessions.where((s) {
        final sDate = DateTime(s.date.year, s.date.month, s.date.day);
        return sDate.isAtSameMomentAs(date);
      });
      
      final hours = daySessions.fold<double>(0, (sum, s) => sum + (s.durationMinutes / 60));
      dailyHours.add(hours);
    }

    final maxHours = dailyHours.reduce((a, b) => a > b ? a : b);
    // Determine Y axis max (min 4 for visual padding)
    final yMax = maxHours > 0 ? maxHours * 1.2 : 4.0;
    
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y-axis labels
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(yMax.toStringAsFixed(1), style: TextStyle(color: textColor, fontSize: 12)),
              Text((yMax * 0.75).toStringAsFixed(2), style: TextStyle(color: textColor, fontSize: 12)),
              Text((yMax * 0.5).toStringAsFixed(1), style: TextStyle(color: textColor, fontSize: 12)),
              Text((yMax * 0.25).toStringAsFixed(2), style: TextStyle(color: textColor, fontSize: 12)),
              Text('0', style: TextStyle(color: textColor, fontSize: 12)),
              const SizedBox(height: 20), // align with bottom axis
            ],
          ),
          const SizedBox(width: 8),
          // Chart area
          Expanded(
            child: Stack(
              children: [
                // Horizontal grid lines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return Container(
                      height: 1,
                      color: index == 4 ? Colors.transparent : gridColor,
                    );
                  }),
                ),
                // X-axis and Bars
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(daysCount, (index) {
                            final fraction = yMax > 0 ? (dailyHours[index] / yMax) : 0.0;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: 24,
                                  height: constraints.maxHeight * fraction,
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF94A3B8),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                );
                              }
                            );
                          }),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: borderColor, // bottom solid line
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: dayLabels.map((label) {
                          return Text(label, style: TextStyle(color: textColor, fontSize: 12));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getShortWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}
