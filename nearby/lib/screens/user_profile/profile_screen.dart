import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/user_avatar.dart';
import '../../models/user_model.dart';
import '../../utils/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Alex Johnson');
  final _bioController = TextEditingController(text: 'Food enthusiast exploring the city one meal at a time');

  int _age = 28;
  final List<String> _availableInterests = [
    'Italian', 'Japanese', 'Mexican', 'Thai', 'Indian', 'French',
    'Coffee', 'Wine', 'Cocktails', 'Brunch', 'Desserts', 'BBQ',
    'Vegan', 'GlutenFree', 'SpicyFood', 'Seafood', 'Sushi',
    'Pizza', 'Tacos', 'Ramen', 'Tapas', 'Fusion', 'FarmToTable',
  ];
  final List<String> _availableIntents = ['dining', 'romantic', 'networking', 'friendship'];

  List<String> _selectedInterests = ['Italian', 'Coffee', 'Brunch'];
  List<String> _selectedIntents = ['dining', 'friendship'];
  bool _isAvailable = true;
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        actions: [
          IconButton(
            onPressed: _toggleEdit,
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: AppTheme.spacingXL),
            _buildBasicInfo(user),
            const SizedBox(height: AppTheme.spacingXL),
            _buildInterests(),
            const SizedBox(height: AppTheme.spacingXL),
            _buildIntents(),
            const SizedBox(height: AppTheme.spacingXL),
            _buildAvailabilityToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          UserAvatar(
            name: user.name,
            imageUrl: user.imageUrl,
            size: 120,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          if (!_isEditing) ...[
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (user.age != null)
              Text(
                'Age: ${user.age}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
          ],
          if (_isEditing)
            ElevatedButton.icon(
              onPressed: _changePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Change Photo'),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            if (_isEditing) ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMD),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Age:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _age > 18 ? () => setState(() => _age--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$_age',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        onPressed: _age < 100 ? () => setState(() => _age++) : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMD),
            ] else ...[
              _buildInfoRow('Name', user.name),
              if (user.age != null) _buildInfoRow('Age', '${user.age}'),
            ],
            const SizedBox(height: AppTheme.spacingMD),
            TextFormField(
              controller: _bioController,
              enabled: _isEditing,
              maxLines: _isEditing ? 3 : null,
              decoration: InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself',
                border: _isEditing ? null : InputBorder.none,
              ),
              style: _isEditing
                  ? null
                  : Theme.of(context).textTheme.bodyLarge,
            ),
            if (_isEditing)
              Text(
                '${_bioController.text.length}/150 characters',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _bioController.text.length > 150
                      ? AppTheme.errorColor
                      : AppTheme.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildInterests() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests (up to 5)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Wrap(
              spacing: AppTheme.spacingXS,
              runSpacing: AppTheme.spacingXS,
              children: _availableInterests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);

                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: _isEditing ? (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  } : null,
                  backgroundColor: AppTheme.cardColor,
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                  ),
                  disabledColor: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
                );
              }).toList(),
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacingSM),
                child: Text(
                  '${_selectedInterests.length}/5 selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntents() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Looking For',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            ..._availableIntents.map((intent) {
              final intentDisplay = {
                'dining': 'Casual Dining',
                'romantic': 'Romantic Meals',
                'networking': 'Professional Networking',
                'friendship': 'Making Friends',
              }[intent] ?? intent;

              return ListTile(
                title: Text(intentDisplay),
                leading: Radio<String>(
                  value: intent,
                  groupValue: _selectedIntents.isNotEmpty ? _selectedIntents.first : null,
                  onChanged: _isEditing ? (value) {
                    setState(() {
                      _selectedIntents.clear();
                      if (value != null) {
                        _selectedIntents.add(value);
                      }
                    });
                  } : null,
                ),
                onTap: _isEditing ? () {
                  setState(() {
                    _selectedIntents.clear();
                    _selectedIntents.add(intent);
                  });
                } : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Row(
          children: [
            Icon(
              _isAvailable ? Icons.visibility : Icons.visibility_off,
              color: _isAvailable ? AppTheme.successColor : AppTheme.textTertiary,
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available to Discover',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    _isAvailable
                        ? 'Other users can see you in Discover'
                        : 'You\'re hidden from Discover',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isAvailable,
              onChanged: _isEditing ? (value) {
                setState(() {
                  _isAvailable = value;
                });
              } : null,
            ),
          ],
        ),
      ),
    );
  }

  User _getCurrentUser() {
    return User(
      id: 'current_user',
      name: _nameController.text,
      age: _age,
      bio: _bioController.text,
      imageUrl: 'https://picsum.photos/200/200?random=current',
      interests: _selectedInterests,
      intents: _selectedIntents,
      isAvailable: _isAvailable,
    );
  }

  void _toggleEdit() {
    if (_isEditing) {
      _saveProfile();
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _saveProfile() {
    if (_bioController.text.length > 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bio must be 150 characters or less'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isEditing = false;
    });

    Logger.info('Profile saved: ${_nameController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _changePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Photo'),
        content: const Text('Photo upload coming soon! For now, using a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}