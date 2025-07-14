import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter/screens/login_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF16213E),
                        Color(0xFF1A1A2E),
                        Color(0xFF0A0A0A)
                      ],
                      stops: [0.6, 0.8, 1],
                      begin: AlignmentDirectional(1, 1),
                      end: AlignmentDirectional(-1, -1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Color(0x4D6C5CE7),
                              offset: Offset(0, 10),
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
                            stops: [0.8, 1],
                            begin: AlignmentDirectional(0, -1),
                            end: AlignmentDirectional(0, 1),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Icon(
                            Icons.psychology_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'MindSync',
                        style: GoogleFonts.interTight(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your AI-powered companion for mental wellness and emotional growth',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Color(0xFFB2B2B2),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 64),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              color: Color(0x33000000),
                              offset: Offset(0, 8),
                            )
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
                            stops: [0.7, 0.9],
                            begin: AlignmentDirectional(0, -1),
                            end: AlignmentDirectional(0, 1),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _FeatureRow(
                                icon: Icons.edit_note_rounded,
                                iconBg: Color(0xFF74B9FF),
                                title: 'Smart Journaling',
                                subtitle: 'Voice & text entries with AI insights',
                              ),
                              const SizedBox(height: 16),
                              _FeatureRow(
                                icon: Icons.chat_bubble_rounded,
                                iconBg: Color(0xFF00B894),
                                title: 'Talk to Numa',
                                subtitle: 'Your empathetic AI companion',
                              ),
                              const SizedBox(height: 16),
                              _FeatureRow(
                                icon: Icons.mood_rounded,
                                iconBg: Color(0xFFFDCB6E),
                                title: 'Mood Tracking',
                                subtitle: 'Visual insights & progress charts',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C5CE7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.interTight(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Color(0xFFB2B2B2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Color(0xFF6C5CE7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.interTight(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xFFB2B2B2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
