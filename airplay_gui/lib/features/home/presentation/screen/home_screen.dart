import 'dart:async';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// A. App Theme Definition (Custom Palette)
// -----------------------------------------------------------------------------

class AppTheme {
  // Common Colors (Defined as per original request)
  static const Color errorRed = Color(0xFFB00020);
  static const Color customDarkGray = Color(0xFF292828);
  static const Color contentWhite = Color(0xFFFFFFFF);
  static const Color darkAccentBlue = Color(0xFF32B2FC);
  static const Color lightPrimaryPurple = Color(0xFF7532FC);
  static const Color lightAccentYellow = Color(0xFFEFFF9E);

  // Dark Theme (Used by the app)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkAccentBlue,
      brightness: Brightness.dark,
      primary: darkAccentBlue,
      secondary: lightPrimaryPurple,
      error: errorRed,
      background: customDarkGray,
      surface: customDarkGray,
      onBackground: contentWhite,
      onSurface: contentWhite,
      onPrimary: contentWhite,
    ),
    scaffoldBackgroundColor: customDarkGray,
    appBarTheme: AppBarTheme(
      color: customDarkGray,
      foregroundColor: contentWhite,
      elevation: 0,
      iconTheme: const IconThemeData(color: darkAccentBlue),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: contentWhite),
      bodyMedium: TextStyle(color: Color(0xBBFFFFFF)),
      titleLarge: TextStyle(color: contentWhite),
    ),
  );
}

// -----------------------------------------------------------------------------
// B. Data Structures
// -----------------------------------------------------------------------------

class ApiProvider {
  final String name;
  final Color color;
  final String placeholder;
  const ApiProvider({
    required this.name,
    required this.color,
    required this.placeholder,
  });
}

const List<ApiProvider> apiProviders = [
  ApiProvider(name: 'Gemini', color: Color(0xFF6A0DAD), placeholder: 'Enter your GEMINI-2.5-FLASH API key...'),
  ApiProvider(name: 'OpenAI (GPT)', color: Color(0xFF10A37F), placeholder: 'Enter your sk-xxxxxxxxxx API key...'),
  ApiProvider(name: 'Claude (Anthropic)', color: Color(0xFF4C8CD2), placeholder: 'Enter your ant-key-xxxxxxxx API key...'),
  ApiProvider(name: 'Replit AI', color: Color(0xFFF73B8A), placeholder: 'Enter your Replit Token...'),
];

// -----------------------------------------------------------------------------
// 1. LoadingScreen
// -----------------------------------------------------------------------------

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late final AnimationController _titleSlideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  late final Animation<Offset> _titleSlideAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.2),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _titleSlideController, curve: Curves.easeOutCubic),
  );
  
  late final AnimationController _statusFadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _cursorBlinkController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..repeat(reverse: true);

  final List<String> _statusMessages = [
    "Initializing core services...", "Loading Airplay protocols...", 
    "Verifying system resources...", "Starting interface...", "Ready to launch."
  ];
  int _currentStatusIndex = 0;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _startLoadingProcess();
  }
  
  Future<void> _startLoadingProcess() async {
    _statusFadeController.forward();

    _statusTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) { _statusTimer?.cancel(); return; }

      if (_currentStatusIndex < _statusMessages.length - 1) {
        _statusFadeController.reverse().then((_) {
          setState(() => _currentStatusIndex++);
          _statusFadeController.forward();
        });
      } else {
        _statusTimer?.cancel();
      }
    });

    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      _statusTimer?.cancel();
      _titleSlideController.stop();
      _statusFadeController.stop();
      _cursorBlinkController.stop();
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _titleSlideController.dispose();
    _statusFadeController.dispose();
    _cursorBlinkController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  // Helper method to build the staggered character animation for 'Airplay'
  List<Widget> _buildStaggeredAirplayTitle(Color color) {
    const String text = 'Airplay';
    const TextStyle baseStyle = TextStyle(
      color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold, letterSpacing: 0,
    );
    const double staggerFactor = 0.6;
    const double dropHeight = 30.0;
    
    return List.generate(text.length, (i) {
      final char = text[i];
      final double startDelay = i * (staggerFactor / text.length);
      final double endDelay = startDelay + (1.0 - staggerFactor);
      final animation = CurvedAnimation(
        parent: _titleSlideController,
        curve: Interval(startDelay, endDelay, curve: Curves.easeOutCubic),
      );

      final charWidget = AnimatedBuilder(
        animation: _titleSlideController,
        builder: (context, child) {
          final double dropOffset = (1.0 - animation.value) * -dropHeight;
          return Transform.translate(
            offset: Offset(0, dropOffset),
            child: Opacity(
              opacity: animation.value,
              child: Text(char, style: baseStyle.copyWith(color: color)),
            ),
          );
        },
      );
      
      // Add character and separator, but no separator after the last character
      return i < text.length - 1 
          ? Row(mainAxisSize: MainAxisSize.min, children: [charWidget, const SizedBox(width: 8)])
          : charWidget;
    });
  }
  
  // Consolidating title row logic
  Widget _buildTitleRow(Color textColor, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildStaggeredAirplayTitle(textColor.withOpacity(0.9)),
        const SizedBox(width: 40),
        SizedBox(
          height: 60, width: 60,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            backgroundColor: Colors.transparent,
          ),
        ),
        Text(
          'S',
          style: TextStyle(
            color: accentColor, fontSize: 60, fontWeight: FontWeight.bold, letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = AppTheme.darkAccentBlue;
    final Color textColor = AppTheme.contentWhite;
    final Color baseColor = AppTheme.customDarkGray;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [baseColor, const Color(0xFF212121)], 
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _titleSlideAnimation,
                child: FadeTransition(
                  opacity: _titleSlideController,
                  child: _buildTitleRow(textColor, accentColor),
                ),
              ),
              const SizedBox(height: 120),
              FadeTransition(
                opacity: _statusFadeController,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _statusMessages[_currentStatusIndex],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: textColor.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _cursorBlinkController,
                      builder: (context, child) {
                        return _currentStatusIndex >= _statusMessages.length - 1
                          ? const SizedBox.shrink()
                          : Opacity(
                              opacity: _cursorBlinkController.value,
                              child: Text('|', style: TextStyle(fontFamily: 'monospace', color: accentColor, fontSize: 18)),
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

// -----------------------------------------------------------------------------
// 2. HomeScreen (Condensed: Inlined Input Row)
// -----------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiProvider? selectedProvider = apiProviders.first;
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _showFeedback(BuildContext context, String providerName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.customDarkGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: selectedProvider!.color, width: 2),
        ),
        title: Text('Configuration Saved', style: TextStyle(color: selectedProvider!.color, fontWeight: FontWeight.bold)),
        content: const Text('The API Key has been processed. You can now use this provider\'s features.', style: TextStyle(color: AppTheme.contentWhite)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: selectedProvider!.color)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProvider = selectedProvider ?? apiProviders.first;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final inputStyle = TextStyle(color: AppTheme.contentWhite, fontSize: 16, letterSpacing: 1.5);
    final borderColor = currentProvider.color.withOpacity(0.4);

    return Scaffold(
      backgroundColor: AppTheme.customDarkGray,
      body: Stack(
        children: [
          // Background Glow
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [currentProvider.color.withOpacity(0.15), AppTheme.customDarkGray],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          // Main Content
          Center(
            child: Container(
              width: isMobile ? size.width * 0.9 : 500,
              padding: const EdgeInsets.all(32.0), 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProviderHeader(provider: currentProvider),
                  const SizedBox(height: 48),

                  // --- Inlined Combined Input Row (formerly _buildCombinedInputRow) ---
                  const Text('Select Provider and Enter API Key', style: TextStyle(fontSize: 14, color: AppTheme.contentWhite, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. Dropdown Selector
                      Expanded(
                        flex: 1, 
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: AppTheme.customDarkGray.withOpacity(0.9), 
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: borderColor, width: 1.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ApiProvider>(
                              value: selectedProvider, isExpanded: true,
                              dropdownColor: AppTheme.customDarkGray,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.contentWhite),
                              style: inputStyle.copyWith(fontSize: 15),
                              onChanged: (ApiProvider? newValue) {
                                setState(() {
                                  selectedProvider = newValue;
                                  _keyController.clear();
                                });
                              },
                              items: apiProviders.map((p) => DropdownMenuItem<ApiProvider>(
                                  value: p,
                                  child: Row(children: [
                                    CircleAvatar(radius: 4, backgroundColor: p.color),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(p.name, overflow: TextOverflow.ellipsis)),
                                  ]),
                                )).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 2. Input Field
                      Expanded(
                        flex: 2, 
                        child: TextField(
                          controller: _keyController, obscureText: true, style: inputStyle,
                          decoration: InputDecoration(
                            hintText: currentProvider.placeholder,
                            hintStyle: TextStyle(color: AppTheme.contentWhite.withOpacity(0.4), fontSize: isMobile ? 14 : 16),
                            filled: true,
                            fillColor: AppTheme.customDarkGray.withOpacity(0.9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor, width: 1.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: currentProvider.color, width: 2.0)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // -------------------------------------------------------------
                  
                  const SizedBox(height: 32),
                  // Save Button
                  ElevatedButton(
                    onPressed: () => _showFeedback(context, currentProvider.name),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: currentProvider.color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                    ),
                    child: Text('Save ${currentProvider.name} Key', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.contentWhite)),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Information Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.customDarkGray.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: currentProvider.color.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      'The key is stored locally for session use. For persistent storage or collaborative features, Firebase is required.',
                      style: TextStyle(color: AppTheme.contentWhite.withOpacity(0.7), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Terms and Conditions
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Terms & Conditions | Privacy Policy',
                  style: TextStyle(fontSize: 12, color: AppTheme.contentWhite.withOpacity(0.5), decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Custom Header Widget
// -----------------------------------------------------------------------------

class ProviderHeader extends StatelessWidget {
  final ApiProvider provider;
  const ProviderHeader({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Text(
          'API Provider Setup',
          style: TextStyle(
            fontSize: 18,
            color: provider.color.withOpacity(0.9),
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [provider.color.withOpacity(0.9), AppTheme.contentWhite, provider.color],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            provider.name,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. Main Application Wrapper and Entry Point
// -----------------------------------------------------------------------------

class AirplayOsApp extends StatelessWidget {
  const AirplayOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplay OS',
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}

void main() => runApp(const AirplayOsApp());