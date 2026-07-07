import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/settings_provider.dart';
import 'translation_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/illustrations/hero_settings.png',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Settings', style: AppTextStyles.heading1),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Translation Preferences'),
                subtitle: const Text('Select your preferred author & view details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TranslationPreferencesScreen(),
                    ),
                  );
                },
              ),
              const Divider(),

              SwitchListTile(
                title: const Text('Show Transliteration'),
                subtitle: const Text('Display English phonetics for Sanskrit verses'),
                value: settings.showTransliteration,
                activeColor: AppColors.primaryAccent,
                onChanged: (val) {
                  settings.toggleTransliteration();
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Font Size'),
                subtitle: Slider(
                  value: settings.fontSize,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  activeColor: AppColors.primaryAccent,
                  onChanged: (val) {
                    settings.setFontSize(val);
                  },
                ),
              ),
            ],
          );
        },
      ),
          ),
        ],
      ),
    );
  }
}
