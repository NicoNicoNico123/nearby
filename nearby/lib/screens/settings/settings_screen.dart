import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/logger.dart';
import '../user_profile/profile_screen.dart';
import '../../widgets/user_avatar.dart';
import '../../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController(text: 'Alexandra Davis');
  final _bioController = TextEditingController(text: 'Lover of coffee and minimalist design. Exploring the world one city at a time.');
  final _usernameController = TextEditingController(text: 'alexandra_d');

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  User _getCurrentUser() {
    return User(
      id: 'current_user',
      name: _nameController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      imageUrl: 'https://picsum.photos/200/200?random=current',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppTheme.spacingXL),

            // User Statistics Section
            _buildUserStatistics(),
            const SizedBox(height: AppTheme.spacingXL),

            // Premium Subscription Section
            _buildPremiumSection(),
            const SizedBox(height: AppTheme.spacingXL),

            Text(
              'Settings',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Card(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Push notifications and alerts',
                    onTap: () => _showComingSoon('Notifications', context),
                  ),
                  const Divider(height: 1, color: AppTheme.borderColor),
                  _buildSettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy',
                    subtitle: 'Privacy controls and data settings',
                    onTap: () => _showComingSoon('Privacy', context),
                  ),
                  const Divider(height: 1, color: AppTheme.borderColor),
                  _buildSettingsTile(
                    icon: Icons.security,
                    title: 'Safety',
                    subtitle: 'Block and report users',
                    onTap: () => _showComingSoon('Safety', context),
                  ),
                  const Divider(height: 1, color: AppTheme.borderColor),
                  _buildSettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () => _showComingSoon('Help & Support', context),
                  ),
                  const Divider(height: 1, color: AppTheme.borderColor),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and legal information',
                    onTap: () => _showComingSoon('About', context),
                  ),
                  const Divider(height: 1, color: AppTheme.borderColor),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    onTap: () => _showSignOutDialog(context),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final user = _getCurrentUser();
    return Center(
      child: Column(
        children: [
          UserAvatar(
            name: user.name,
            imageUrl: user.imageUrl,
            size: 128,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            user.name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${_usernameController.text}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              user.bio,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLG),
          OutlinedButton(
            onPressed: () => _navigateToProfile(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppTheme.borderColor),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatistics() {
    // Mock statistics with limits - in a real app, these would come from a service
    final int currentJoinedGroups = 3;
    final int maxJoinedGroups = 5;
    final int pointsBalance = 250;
    final int currentCreatedGroups = 0;
    final int maxCreatedGroups = 2;
    final int eventsAttended = 8;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSM),
                Text(
                  'Your Statistics',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _refreshStatistics,
                  icon: const Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.group,
                    title: 'Joined Groups',
                    value: '$currentJoinedGroups/$maxJoinedGroups',
                    color: AppTheme.primaryColor,
                    isNearLimit: currentJoinedGroups >= maxJoinedGroups - 1,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.monetization_on,
                    title: 'Points Balance',
                    value: pointsBalance.toString(),
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.add_circle,
                    title: 'Groups Created',
                    value: '$currentCreatedGroups/$maxCreatedGroups',
                    color: AppTheme.successColor,
                    isNearLimit: currentCreatedGroups >= maxCreatedGroups - 1,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.event,
                    title: 'Events Attended',
                    value: eventsAttended.toString(),
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isNearLimit = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: isNearLimit
            ? Colors.red.withValues(alpha: 0.1)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNearLimit
              ? Colors.red.withValues(alpha: 0.5)
              : color.withValues(alpha: 0.3),
          width: isNearLimit ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isNearLimit ? Colors.red : color,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingSM),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isNearLimit)
                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isNearLimit ? Colors.red : color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (value.contains('/')) ...[
                const SizedBox(width: 4),
                Text(
                  _getProgressText(value),
                  style: TextStyle(
                    color: isNearLimit ? Colors.red : color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          if (value.contains('/')) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _getProgressValue(value),
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isNearLimit ? Colors.red : color,
              ),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ],
      ),
    );
  }

  String _getProgressText(String ratio) {
    final parts = ratio.split('/');
    if (parts.length == 2) {
      final current = int.tryParse(parts[0]) ?? 0;
      final max = int.tryParse(parts[1]) ?? 1;
      final percentage = (current / max * 100).round();
      return '($percentage%)';
    }
    return '';
  }

  double _getProgressValue(String ratio) {
    final parts = ratio.split('/');
    if (parts.length == 2) {
      final current = int.tryParse(parts[0]) ?? 0;
      final max = int.tryParse(parts[1]) ?? 1;
      return current / max;
    }
    return 0.0;
  }

  Widget _buildPremiumSection() {
    final bool isPremium = false; // Mock premium status

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.diamond,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPremium ? 'Premium Member' : 'Upgrade to Premium',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPremium
                            ? 'Enjoying all premium benefits'
                            : 'Unlock exclusive features and benefits',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isPremium)
                  ElevatedButton(
                    onPressed: _showPremiumUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMD,
                        vertical: AppTheme.spacingSM,
                      ),
                    ),
                    child: const Text('Upgrade'),
                  ),
              ],
            ),
            if (!isPremium) ...[
              const SizedBox(height: AppTheme.spacingMD),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMD),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Benefits:',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
                    _buildPremiumBenefit(icon: Icons.all_inclusive, text: 'Unlimited group creation'),
                    _buildPremiumBenefit(icon: Icons.visibility, text: 'See who liked your profile'),
                    _buildPremiumBenefit(icon: Icons.bolt, text: 'Priority matching'),
                    _buildPremiumBenefit(icon: Icons.emoji_events, text: 'Exclusive badges'),
                    _buildPremiumBenefit(icon: Icons.support_agent, text: 'Priority support'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBenefit({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingSM),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textTertiary,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showComingSoon(String feature, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature - Coming Soon'),
        content: Text('This feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Logger.info('User signed out');
              // Navigate back to welcome screen or handle sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _refreshStatistics() {
    // Mock refresh - in a real app, this would fetch fresh data
    Logger.info('Refreshing user statistics');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Statistics refreshed!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showPremiumUpgrade() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Upgrade to Premium',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your premium plan:',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _buildPremiumPlanOption(
              title: 'Monthly',
              price: '\$9.99/month',
              benefits: [
                'All premium features',
                'Cancel anytime',
                'Priority support',
              ],
              isSelected: true,
            ),
            const SizedBox(height: 12),
            _buildPremiumPlanOption(
              title: 'Annual',
              price: '\$79.99/year',
              benefits: [
                'Save 33%',
                'All premium features',
                'Priority support',
                'Exclusive annual badge',
              ],
              isSelected: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Maybe Later',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPremiumConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlanOption({
    required String title,
    required String price,
    required List<String> benefits,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.successColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Confirm Premium Upgrade',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'re about to upgrade to Premium!',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '• Your payment will be processed securely\n• You can cancel anytime\n• Premium features activate immediately',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Premium upgrade coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Upgrade'),
          ),
        ],
      ),
    );
  }
}