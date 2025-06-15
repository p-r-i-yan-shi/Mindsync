import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'Mood Tracker',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textColor,
                fontSize: 22,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentPurple,
          labelColor: AppColors.accentPurple,
          unselectedLabelColor: AppColors.lightGrey,
          tabs: const [
            Tab(text: 'Day'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Daily Mood Data', style: TextStyle(color: AppColors.textColor))),
          Center(child: Text('Weekly Mood Data', style: TextStyle(color: AppColors.textColor))),
          Center(child: Text('Monthly Mood Data', style: TextStyle(color: AppColors.textColor))),
        ],
      ),
    );
  }
} 