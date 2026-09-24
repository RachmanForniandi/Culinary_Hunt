import 'package:culinary_hunt/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appearance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// 🌙 DARK MODE SWITCH
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),

                    title: const Text('Dark Mode'),

                    subtitle: Text(
                      provider.isDarkMode
                          ? 'Dark theme enabled'
                          : 'Light theme enabled',
                    ),

                    value: provider.isDarkMode,

                    onChanged: (value) {
                      provider.toggleTheme(value);
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorItem(String title, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 6),

          Text(title),
        ],
      ),
    );
  }
}
