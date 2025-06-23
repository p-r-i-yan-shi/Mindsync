import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter/providers/theme_provider.dart';
import 'package:my_flutter/screens/splash_screen.dart';
import 'package:my_flutter/screens/auth/login_screen.dart';
import 'package:my_flutter/screens/home_dashboard_screen.dart';
import 'package:my_flutter/screens/settings_screen.dart';
import 'package:my_flutter/screens/main_shell.dart';
import 'package:my_flutter/screens/get_started_screen.dart';
import 'package:my_flutter/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Define custom colors based on the UI Kit
class AppColors {
  static const Color primaryDark = Color(0xFF181829); // Deeper, modern
  static const Color accentPurple = Color(0xFF8F5CFF); // Vibrant accent
  static const Color cardBackground = Color(0xFF23233A); // Softer card
  static const Color textColor = Color(0xFFF5F5FA); // Lighter text
  static const Color lightGrey = Color(0xFFB0B0C3);
  static const Color darkGrey = Color(0xFF35354D);
  static const Color accentBlue = Color(0xFF5AC8FA); // For highlights
  static const Color accentGreen = Color(0xFF4ADE80); // For success
  static const Color accentRed = Color(0xFFFF6B6B); // For errors
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  // Schedule a daily notification at 8:00 AM
  NotificationService().scheduleDailyNotification(
    id: 1,
    title: 'Good Morning!',
    body: 'Uth gaye? Start your day with MindSync!',
    time: const TimeOfDay(hour: 8, minute: 0),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderNotifier);
    
    return MaterialApp(
      title: 'MindSync',
      theme: themeProvider.theme.copyWith(
        scaffoldBackgroundColor: AppColors.primaryDark,
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          shadowColor: AppColors.accentPurple.withOpacity(0.15),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textColor),
          titleTextStyle: const TextStyle(
            color: AppColors.textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'GoogleSans',
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
          ),
          hintStyle: const TextStyle(color: AppColors.lightGrey),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accentPurple,
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textColor, fontFamily: 'GoogleSans'),
          bodySmall: TextStyle(fontSize: 12, color: AppColors.lightGrey, fontFamily: 'GoogleSans'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const GetStartedScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return _buildRoute(const LoginScreen());
          case '/home':
            return _buildRoute(const HomeDashboardScreen());
          case '/settings':
            return _buildRoute(const SettingsScreen());
          default:
            return _buildRoute(const SplashScreen());
        }
      },
    );
  }

  PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}

// Enhanced Splash Screen with animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Navigate to login screen after animation completes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            var offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.darkGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo or icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      size: 80,
                      color: AppColors.accentPurple,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'MindSync',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.textColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your mental wellness companion',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.lightGrey,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 80),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
