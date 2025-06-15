import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class ProfileAchievementsScreen extends StatelessWidget {
  const ProfileAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'Profile & Achievements',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.cardBackground,
              child: Icon(Icons.person, size: 60, color: AppColors.lightGrey), // Placeholder for user avatar
            ),
            const SizedBox(height: 20),
            Text(
              'John Doe', // Placeholder for user name
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 24,
                  ),
            ),
            Text(
              'johndoe@example.com', // Placeholder for user email
              style: TextStyle(color: AppColors.lightGrey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6, // Placeholder for number of achievements
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 40, color: AppColors.accentPurple), // Placeholder for achievement icon
                        const SizedBox(height: 5),
                        Text(
                          'Achievement ${index + 1}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textColor, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 