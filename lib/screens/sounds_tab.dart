import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_time/providers/app_state.dart';

class SoundsTab extends StatelessWidget {
  const SoundsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;

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
                  Icons.music_note_outlined,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ambient Sounds',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSoundButton('Lo-Fi Beats', appState, isDark)),
                const SizedBox(width: 8),
                Expanded(child: _buildSoundButton('Rain', appState, isDark)),
                const SizedBox(width: 8),
                Expanded(child: _buildSoundButton('White Noise', appState, isDark)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                GestureDetector(
                  onTap: appState.toggleSoundPlay,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF111827),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      appState.isPlayingSound ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      activeTrackColor: const Color(0xFF111827),
                      inactiveTrackColor: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                      thumbColor: const Color(0xFF111827),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: appState.soundVolume,
                      onChanged: appState.setSoundVolume,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${(appState.soundVolume * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundButton(String title, AppState appState, bool isDark) {
    final isSelected = appState.selectedSound == title;
    
    final bgColor = isSelected 
        ? (isDark ? const Color(0xFF4B5563) : const Color(0xFF111827))
        : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6));
        
    final textColor = isSelected 
        ? Colors.white 
        : (isDark ? Colors.white60 : const Color(0xFF1F2937));

    return GestureDetector(
      onTap: () => appState.setSound(title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
