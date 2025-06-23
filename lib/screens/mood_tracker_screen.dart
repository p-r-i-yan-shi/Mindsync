import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood_log.dart';
import '../providers/mood_provider.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  int _selectedMood = 3;
  final TextEditingController _noteController = TextEditingController();

  Future<void> _saveMood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final log = MoodLog(
      id: const Uuid().v4(),
      userId: user.uid,
      mood: _selectedMood,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      createdAt: DateTime.now(),
    );
    await ref.read(addMoodLogProvider(log).future);
    _noteController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood logged!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodsAsync = ref.watch(moodLogsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('How are you feeling today?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setState(() => _selectedMood = i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedMood == i + 1 ? Colors.amberAccent : Colors.grey[200],
                  ),
                  child: Text(
                    ['😢', '😔', '😐', '😊', '😁'][i],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add a note (optional)',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saveMood,
              icon: const Icon(Icons.check_circle),
              label: const Text('Log Mood'),
            ),
            const SizedBox(height: 24),
            const Text('Mood Trend', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: moodsAsync.when(
                data: (moods) => moods.isEmpty
                    ? const Center(child: Text('No mood logs yet.'))
                    : Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: LineChart(
                          LineChartData(
                            minY: 1,
                            maxY: 5,
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (v, _) => Text(
                                    ['😢', '😔', '😐', '😊', '😁'][v.toInt() - 1],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (v, meta) {
                                    final idx = v.toInt();
                                    if (idx < 0 || idx >= moods.length) return const SizedBox();
                                    final date = moods[idx].createdAt;
                                    return Text('${date.month}/${date.day}', style: const TextStyle(fontSize: 12));
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  for (int i = 0; i < moods.length; i++)
                                    FlSpot(i.toDouble(), moods[i].mood.toDouble()),
                                ],
                                isCurved: true,
                                color: Colors.amber,
                                barWidth: 4,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 