# my_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# MindSync

MindSync is a full-stack, AI-powered mental wellness mobile app built with Flutter. It features a modern, beautiful UI, AI chat, journaling, mood tracking, suggestions, notifications, and more.

## Features
- Beautiful dark/light themes, pastel accents, rounded cards, soft shadows, and clean sans-serif fonts
- Onboarding, Google Auth (Firebase)
- Home: Journal (text & speech-to-text, Firestore)
- Suggestions: AI-powered (music, quotes, self-care, ZenQuotes API)
- Talk to AI (Numa): GPT-3.5, context-aware, emotional, Firestore chat history
- Mood Tracker: Mood logging, Firestore, fl_chart
- Profile & Settings: User info, dark mode, mood streaks, achievements
- Zomato-style local notifications
- Clean architecture with Riverpod
- Responsive, animated, and production-ready for Android/iOS

## Setup
1. **Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
   - Enable Firestore and Google Auth in Firebase Console.
2. **OpenAI:**
   - Create a `.env` file in the root:
     ```
     OPENAI_API_KEY=sk-...
     ```
3. **Dependencies:**
   - Run `flutter pub get` to install all packages.
4. **Run the app:**
   - `flutter run`

## Optional: Email Reminders
- To enable email reminders, deploy a Firebase Function using Nodemailer. See `/functions` for a code stub.

## Production
- All features are integrated and tested.
- Code is clean, modular, and ready for deployment.

---
Enjoy your emotionally intelligent, fast, and elegant MindSync experience!
