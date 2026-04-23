import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_time/providers/app_state.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _workController;
  late TextEditingController _shortBreakController;
  late TextEditingController _longBreakController;
  late TextEditingController _sessionsController;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    // Convert to string, format double to drop trailing zeros if possible, but simplest is toString
    _workController = TextEditingController(text: _formatNumber(appState.workDuration));
    _shortBreakController = TextEditingController(text: _formatNumber(appState.shortBreakDuration));
    _longBreakController = TextEditingController(text: _formatNumber(appState.longBreakDuration));
    _sessionsController = TextEditingController(text: appState.sessionsUntilLongBreak.toString());
  }

  String _formatNumber(double num) {
    if (num == num.toInt()) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  @override
  void dispose() {
    _workController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final appState = context.read<AppState>();
    final work = double.tryParse(_workController.text);
    final shortBreak = double.tryParse(_shortBreakController.text);
    final longBreak = double.tryParse(_longBreakController.text);
    final sessions = int.tryParse(_sessionsController.text);

    appState.updateSettings(
      work: work,
      shortBreak: shortBreak,
      longBreak: longBreak,
      sessions: sessions,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppState>().isDarkMode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : const Color(0xFF475569),
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    alignment: Alignment.centerRight,
                  ),
                  onPressed: _saveSettings,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildInputField('WORK DURATION (MINUTES)', _workController, isDark),
            const SizedBox(height: 20),
            _buildInputField('SHORT BREAK (MINUTES)', _shortBreakController, isDark),
            const SizedBox(height: 20),
            _buildInputField('LONG BREAK (MINUTES)', _longBreakController, isDark),
            const SizedBox(height: 20),
            _buildInputField('SESSIONS UNTIL LONG BREAK', _sessionsController, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
