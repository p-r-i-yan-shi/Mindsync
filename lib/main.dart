import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/journal_data.dart';
import 'providers/theme_notifier.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/get_started_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2196F3),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFBBDEFB),
  onPrimaryContainer: Color(0xFF0D47A1),
  secondary: Color(0xFF1976D2),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF90CAF9),
  onSecondaryContainer: Color(0xFF0D47A1),
  tertiary: Color(0xFF5E6037),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE4E6B1),
  onTertiaryContainer: Color(0xFF1B1D00),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBF8F0),
  onBackground: Color(0xFF1F1B18),
  surface: Color(0xFFFBF8F0),
  onSurface: Color(0xFF1F1B18),
  surfaceVariant: Color(0xFFF0E0D7),
  onSurfaceVariant: Color(0xFF504540),
  outline: Color(0xFF82756E),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF34302C),
  onInverseSurface: Color(0xFFF8F0E8),
  inversePrimary: Color(0xFF1976D2),
  surfaceTint: Color(0xFF2196F3),
  surfaceContainerHighest: Color(0xFFE9E0DB),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7B61FF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF5A4FFF),
  onPrimaryContainer: Color(0xFFFFFFFF),
  secondary: Color(0xFF8F9BFF),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF232A4D),
  onSecondaryContainer: Color(0xFFFFFFFF),
  tertiary: Color(0xFFD1D8FF),
  onTertiary: Color(0xFF232A4D),
  tertiaryContainer: Color(0xFF232A4D),
  onTertiaryContainer: Color(0xFFD1D8FF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF232A4D),
  onBackground: Color(0xFFFFFFFF),
  surface: Color(0xFF232A4D),
  onSurface: Color(0xFFFFFFFF),
  surfaceVariant: Color(0xFF313A5A),
  onSurfaceVariant: Color(0xFFB6B8D6),
  outline: Color(0xFF3C4466),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFB6B8D6),
  onInverseSurface: Color(0xFF232A4D),
  inversePrimary: Color(0xFF7B61FF),
  surfaceTint: Color(0xFF7B61FF),
  surfaceContainerHighest: Color(0xFF2D3656),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<JournalData>(
          create: (BuildContext context) => JournalData(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (BuildContext context) => ThemeNotifier(),
        ),
      ],
      builder: (BuildContext context, Widget? child) {
        return Consumer<ThemeNotifier>(
          builder: (
            BuildContext context,
            ThemeNotifier themeNotifier,
            Widget? child,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MindSync Journal',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                appBarTheme: AppBarTheme(
                  backgroundColor: lightColorScheme.surface,
                ),
                cardTheme: CardThemeData(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: lightColorScheme.surfaceContainerHighest,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: lightColorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: lightColorScheme.primary,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(color: lightColorScheme.onSurfaceVariant),
                  hintStyle: TextStyle(color: lightColorScheme.onSurfaceVariant),
                ),
                chipTheme: ChipThemeData(
                  selectedColor: lightColorScheme.primary,
                  backgroundColor: lightColorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(color: lightColorScheme.onSurface),
                  secondaryLabelStyle: TextStyle(color: lightColorScheme.onPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                appBarTheme: AppBarTheme(
                  backgroundColor: darkColorScheme.surface,
                ),
                cardTheme: CardThemeData(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: darkColorScheme.surfaceContainerHighest,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: darkColorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: darkColorScheme.primary,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
                  hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
                ),
                chipTheme: ChipThemeData(
                  selectedColor: darkColorScheme.primary,
                  backgroundColor: darkColorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(color: darkColorScheme.onSurface),
                  secondaryLabelStyle: TextStyle(color: darkColorScheme.onPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              themeMode: themeNotifier.themeMode,
              routes: <String, WidgetBuilder>{
                '/': (BuildContext context) => const GetStartedScreen(),
                '/getStarted': (BuildContext context) => const GetStartedScreen(),
                '/login': (BuildContext context) => const LoginScreen(),
                '/home': (BuildContext context) => HomeScreen(),
              },
              initialRoute: '/',
            );
          },
        );
      },
    ),
  );
}
