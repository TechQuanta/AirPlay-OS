import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:airplay_gui/main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  // Controller for the main title's initial slide/fade entry
  late AnimationController _titleSlideController;
  late Animation<Offset> _titleSlideAnimation;

  // Controller for the status text fade effect (runs on every status update)
  late AnimationController _statusFadeController;
  
  // NEW: Controller for the blinking cursor in the status message
  late AnimationController _cursorBlinkController;

  // Status message logic
  final List<String> _statusMessages = [
    "Initializing core services...",
    "Loading Airplay protocols...",
    "Verifying system resources...",
    "Starting interface...",
    "Ready to launch.",
  ];
  int _currentStatusIndex = 0;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();

    // 1. Title Slide/Fade Setup (Runs once on start)
    _titleSlideController = AnimationController(
      vsync: this,
      // Increased duration for a smoother staggered effect
      duration: const Duration(milliseconds: 1800), 
    )..forward();

    // The main title container slides slightly, but the characters drop individually.
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // Start slightly offset to make the overall composition feel like it's entering
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleSlideController, curve: Curves.easeOutCubic),
    );

    // 2. Status Text Fade Setup (Short duration for clean text transitions)
    _statusFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // 3. NEW: Cursor Blink Setup
    _cursorBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _startLoadingProcess();
  }

  Future<void> _startLoadingProcess() async {
    // Initial status fade-in
    _statusFadeController.forward();

    // Start cycling status messages every second
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) {
        _statusTimer?.cancel();
        return;
      }

      // Cycle status messages by reversing the fade, updating text, then moving forward
      if (_currentStatusIndex < _statusMessages.length - 1) {
        _statusFadeController.reverse().then((_) {
          setState(() {
            _currentStatusIndex++;
          });
          _statusFadeController.forward();
        });
      } else {
        // Once the last message is reached, stop the status cycling timer
        _statusTimer?.cancel();
      }
    });

    // Total time before navigation (4.5 seconds for full cycle + buffer)
    await Future.delayed(const Duration(seconds: 4));

    // Navigate to the next screen
    if (mounted) {
      _statusTimer?.cancel();
      _titleSlideController.stop();
      _statusFadeController.stop();
      _cursorBlinkController.stop(); // Stop the cursor blink

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    }
  }

  @override
  void dispose() {
    // CRITICAL: Ensure all controllers are disposed and the timer is canceled.
    _titleSlideController.dispose();
    _statusFadeController.dispose();
    _cursorBlinkController.dispose(); // Dispose the new controller
    _statusTimer?.cancel();
    super.dispose();
  }

  // Helper method to build the staggered character animation for 'Airplay'
  List<Widget> _buildStaggeredAirplayTitle(Color color) {
    const String text = 'Airplay';
    final List<Widget> characters = [];
    
    // Base style for all characters
    const TextStyle baseStyle = TextStyle(
      color: Colors.white,
      fontSize: 60,
      fontWeight: FontWeight.bold, // Airplay is now BOLD
      letterSpacing: 0, // Letter spacing controlled by SizedBox below
    );
    
    const double staggerFactor = 0.6; // How much of the total duration is used for the staggered entrance
    const double dropHeight = 30.0; // Starting drop height

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      
      // Calculate a staggered interval based on the character index
      final double startDelay = i * (staggerFactor / text.length);
      final double endDelay = startDelay + (1.0 - staggerFactor); // Ensure all animations complete by 1.0

      final Animation<double> animation = CurvedAnimation(
        parent: _titleSlideController,
        curve: Interval(
          startDelay,
          endDelay,
          curve: Curves.easeOutCubic,
        ),
      );

      characters.add(
        // AnimatedBuilder listens to the main controller, but uses the staggered animation curve
        AnimatedBuilder(
          animation: _titleSlideController,
          builder: (context, child) {
            // Drop effect: value 0.0 -> 1.0. Offset goes from -dropHeight to 0.
            final double dropOffset = (1.0 - animation.value) * -dropHeight;
            
            return Transform.translate(
              offset: Offset(0, dropOffset),
              child: Opacity(
                opacity: animation.value,
                child: Text(
                  char,
                  style: baseStyle.copyWith(color: color), // Apply dynamic color
                ),
              ),
            );
          },
        ),
      );

      // Add horizontal spacing between characters
      if (i < text.length - 1) {
        characters.add(const SizedBox(width: 8)); // Match the old letterSpacing: 8
      }
    }

    return characters;
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the system theme is dark
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Retained Accent Color (Teal/Cyan for a modern, tech feel)
    final Color accentColor = isDarkMode ? const Color(0xFF00ADB5) : const Color(0xFF00897B);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    // Simplified Static Background Gradient (Non-bluish dark gray)
    const Color darkStartColor = Color(0xFF212121); // Deep Charcoal (slightly darker start)
    const Color darkEndColor = Color(0xFF292828); // User requested dark gray tone
    const Color lightStartColor = Colors.white;
    const Color lightEndColor = Color(0xFFF0F8FF); // Very subtle light blue

    final Color baseStartColor = isDarkMode ? darkStartColor : lightStartColor;
    final Color baseEndColor = isDarkMode ? darkEndColor : lightEndColor;

    return Scaffold(
      body: Container(
        // Static background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [baseStartColor, baseEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Title Animation (Slide and Fade)
              SlideTransition(
                position: _titleSlideAnimation,
                child: FadeTransition(
                  opacity: _titleSlideController,
                  child: Column(
                    children: [
                      // "Airplay <Loader> S" Text - Larger and more defined
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Staggered 'Airplay' characters
                          ..._buildStaggeredAirplayTitle(textColor.withOpacity(0.9)),
                          
                          // Increased gap for clear separation between 'Airplay' and 'OS'
                          const SizedBox(width: 40), 
                          
                          // Circular Progress Indicator replacing the 'O'
                          SizedBox(
                            height: 60, // Match font size height
                            width: 60, // Perfect circular container
                            child: CircularProgressIndicator(
                              strokeWidth: 6, // Thicker stroke for better visibility
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                              backgroundColor: Colors.transparent, // Background transparent so it looks like it's part of the text
                            ),
                          ),
                          
                          // 'S'
                          Text(
                            'S',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 60, // Larger size
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 120), // Increased separation from status text

              // 3. Status Text (Fades in/out on update + Pulsing Cursor)
              FadeTransition(
                opacity: _statusFadeController,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _statusMessages[_currentStatusIndex],
                      style: TextStyle(
                        // Monospaced font look for "terminal" feel
                        fontFamily: 'monospace', 
                        color: textColor.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                      ),
                    ),
                    
                    // Pulsing Cursor effect
                    AnimatedBuilder(
                      animation: _cursorBlinkController,
                      builder: (context, child) {
                        // Only show the cursor if the last status message hasn't been reached
                        if (_currentStatusIndex >= _statusMessages.length - 1) {
                          return const SizedBox.shrink(); 
                        }
                        
                        return Opacity(
                          opacity: _cursorBlinkController.value,
                          child: Text(
                            '|',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: accentColor,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
