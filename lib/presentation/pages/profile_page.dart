// Create a new file: lib/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:metro_link/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileOptions(context),
            const SizedBox(height: 24),
            _buildAppOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@example.com',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // Edit profile
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          context,
          Icons.credit_card,
          'My Cards',
          'Manage your metro cards',
        ),
        _buildOptionTile(
          context,
          Icons.history,
          'Journey History',
          'View all your journeys',
        ),
        _buildOptionTile(
          context,
          Icons.notifications,
          'Notifications',
          'Manage your notifications',
        ),
        _buildOptionTile(
          context,
          Icons.security,
          'Security',
          'Manage account security',
        ),
      ],
    );
  }

  Widget _buildAppOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          context,
          Icons.language,
          'Language',
          'Change app language',
        ),
        _buildOptionTile(
          context,
          Icons.dark_mode,
          'Theme',
          'Change app theme',
        ),
        _buildOptionTile(
          context,
          Icons.info,
          'About',
          'App information and version',
        ),
        _buildOptionTile(
          context,
          Icons.help,
          'Help & Support',
          'Get help with the app',
        ),
        _buildOptionTile(
          context,
          Icons.logout,
          'Logout',
          'Sign out from your account',
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildOptionTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle, {
        bool isDestructive = false,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('$title Coming Soon'),
            content: Text('We\'re working on bringing you the $title functionality. Stay tuned for updates!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}