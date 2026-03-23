import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0E3E), AppTheme.surfaceDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Settings', style: AppTheme.titleMedium),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                     _buildSection('Account', [
                       SettingItem(Icons.person, 'Profile', 'Edit your profile'),
                       SettingItem(Icons.link, 'Link Account', 'Google, Apple'),
                       SettingItem(Icons.cloud_upload, 'Cloud Save', 'Backup your progress'),
                    ]),
                    const SizedBox(height: 20),
                     _buildSection('Game', [
                       SettingItem(Icons.volume_up, 'Sound', 'ON', hasToggle: true),
                       SettingItem(Icons.music_note, 'Music', 'ON', hasToggle: true),
                       SettingItem(Icons.vibration, 'Vibration', 'ON', hasToggle: true),
                       SettingItem(Icons.notifications, 'Push Notifications', 'ON', hasToggle: true),
                       SettingItem(Icons.language, 'Language', 'English'),
                    ]),
                    const SizedBox(height: 20),
                     _buildSection('Support', [
                       SettingItem(Icons.help_outline, 'Help & FAQ', ''),
                       SettingItem(Icons.email, 'Contact Us', ''),
                       SettingItem(Icons.info_outline, 'Terms of Service', ''),
                       SettingItem(Icons.privacy_tip, 'Privacy Policy', ''),
                    ]),
                    const SizedBox(height: 20),
                     _buildSection('App Info', [
                       SettingItem(Icons.new_releases, 'Version', '1.0.4 (192)'),
                       SettingItem(Icons.code, 'Build', 'Flutter Edition'),
                    ]),
                    const SizedBox(height: 20),
                    
                    // Delete / Logout
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.hpRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.hpRed.withValues(alpha: 0.2)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: AppTheme.hpRed),
                        title: Text('Sign Out', style: AppTheme.bodyLarge.copyWith(color: AppTheme.hpRed)),
                        onTap: () {},
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text('Slime Quest', style: AppTheme.bodySmall.copyWith(color: AppTheme.slimeGreen)),
 Text('2024.0 LoadComplete', style: AppTheme.bodySmall.copyWith(fontSize: 10)),
                          Text('Rebuilt with Flutter_', style: AppTheme.bodySmall.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List< SettingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.labelBold.copyWith(color: AppTheme.slimeGreen, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppTheme.textSecondary, size: 22),
                    title: Text(item.title, style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary, fontSize: 14)),
                    trailing: item.hasToggle
                        ? Switch(
                            value: true,
                            onChanged: (_) {},
                            activeTrackColor: AppTheme.slimeGreen.withValues(alpha: 0.5),
                            activeThumbColor: AppTheme.slimeGreen,
                          )
                        : item.subtitle.isNotEmpty
                            ? Text(item.subtitle, style: AppTheme.bodySmall)
                            : const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
                    onTap: () {},
                  ),
                  if (i < items.length - 1)
                    Divider(height: 1, color: Colors.white.withValues(alpha: 0.1), indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class  SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool hasToggle;

  const  SettingItem(this.icon, this.title, this.subtitle, {this.hasToggle = false});
}
