import 'package:flutter/material.dart';

void main() {
  runApp(const ApiSettingsApp());
}

// --- Data Structures ---

// Defines the API provider data (name and primary color)
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

// List of available providers with their distinct colors
const List<ApiProvider> apiProviders = [
  ApiProvider(
    name: 'Gemini',
    color: Color(0xFF6A0DAD), // Deep Violet/Purple for Google AI
    placeholder: 'Enter your GEMINI-2.5-FLASH API key...',
  ),
  ApiProvider(
    name: 'OpenAI (GPT)',
    color: Color(0xFF10A37F), // Distinct Mint Green
    placeholder: 'Enter your sk-xxxxxxxxxx API key...',
  ),
  ApiProvider(
    name: 'Claude (Anthropic)',
    color: Color(0xFF4C8CD2), // Muted Anthropic Blue
    placeholder: 'Enter your ant-key-xxxxxxxx API key...',
  ),
  ApiProvider(
    name: 'Replit AI',
    color: Color(0xFFF73B8A), // Replit's signature Pink/Magenta
    placeholder: 'Enter your Replit Token...',
  ),
];

// --- Main Application Widget ---

class ApiSettingsApp extends StatelessWidget {
  const ApiSettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplay OS - API Settings',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Navy Background
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const ApiSettingsScreen(),
    );
  }
}

// --- Screen Widget ---

class ApiSettingsScreen extends StatefulWidget {
  const ApiSettingsScreen({super.key});

  @override
  State<ApiSettingsScreen> createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends State<ApiSettingsScreen> {
  // State to hold the currently selected provider
  ApiProvider? selectedProvider = apiProviders.first;
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Visual Effect (Optional: a subtle gradient or light glow)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    selectedProvider!.color.withOpacity(0.3),
                    Colors.transparent
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 2. Main Centered Content (Detachable Card)
          Center(
            child: SizedBox(
              width: isMobile ? size.width * 0.9 : 500,
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selectedProvider!.color.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                color: const Color(0xFF1E293B), // Slightly lighter slate background for the card
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: Provider Name with Color Tone
                      ProviderHeader(provider: selectedProvider!),
                      const SizedBox(height: 32),

                      // Dropdown (API Selector)
                      _buildDropdown(),
                      const SizedBox(height: 16),

                      // Input Field (API Key)
                      _buildKeyInput(isMobile),
                      const SizedBox(height: 24),

                      // Save Button
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement save logic
                          _showFeedback(context, selectedProvider!.name);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: selectedProvider!.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save ${selectedProvider!.name} Key',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Terms and Conditions (Bottom Right)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {
                  // TODO: Implement navigation to T&C page
                },
                child: const Text(
                  'Terms & Conditions | Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8), // Slate Gray
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Provider',
          style: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.7), // Darker than card for contrast
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: selectedProvider!.color.withOpacity(0.6), width: 1.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ApiProvider>(
              value: selectedProvider,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E293B), // Card background color
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFCBD5E1)),
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 16),
              onChanged: (ApiProvider? newValue) {
                setState(() {
                  selectedProvider = newValue;
                  // Clear input when switching providers
                  _keyController.clear(); 
                });
              },
              items: apiProviders.map<DropdownMenuItem<ApiProvider>>((ApiProvider provider) {
                return DropdownMenuItem<ApiProvider>(
                  value: provider,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: provider.color,
                      ),
                      const SizedBox(width: 8),
                      Text(provider.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyInput(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${selectedProvider!.name} API Key',
          style: const TextStyle(fontSize: 14, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _keyController,
          obscureText: true, // Hide the key
          style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.5),
          decoration: InputDecoration(
            hintText: selectedProvider!.placeholder,
            hintStyle: TextStyle(color: const Color(0xFF94A3B8).withOpacity(0.6), fontSize: isMobile ? 14 : 16),
            filled: true,
            fillColor: const Color(0xFF0F172A).withOpacity(0.7), // Darker than card for contrast
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: selectedProvider!.color, // Color tone on focus
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  // Simple feedback modal instead of alert()
  void _showFeedback(BuildContext context, String providerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            'Configuration Saved',
            style: TextStyle(color: selectedProvider!.color, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'The API Key for $providerName has been processed. You can now use $providerName features.',
            style: const TextStyle(color: Color(0xFFCBD5E1)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: selectedProvider!.color)),
            ),
          ],
        );
      },
    );
  }
}

// --- Custom Header Widget for Cool Effect ---

class ProviderHeader extends StatelessWidget {
  final ApiProvider provider;
  const ProviderHeader({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Provider Setup',
          style: TextStyle(
            fontSize: 14,
            color: provider.color.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        ShaderMask(
          // Use a gradient shader for the "cool effect"
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                provider.color.withOpacity(0.8),
                Colors.white,
                provider.color,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            provider.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white, // Color is masked by the shader
            ),
          ),
        ),
        const Divider(height: 24, thickness: 1, color: Color(0xFF334155)),
      ],
    );
  }
}