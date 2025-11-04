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
  final _nameController = TextEditingController(text: 'Alexandra Davis');
  final _bioController = TextEditingController(text: 'Lover of coffee and minimalist design. Exploring the world one city at a time.');
  final _usernameController = TextEditingController(text: 'alexandra_d');

  int _age = 28;
  String _selectedGender = 'Prefer not to say';
    List<String> _selectedInterests = ['#Design', '#Travel', '#Photography', '#Coffee', '#Minimalism'];

  // Individual editing states
  bool _isEditingName = false;
  bool _isEditingUsername = false;
  bool _isEditingAge = false;
  bool _isEditingBio = false;
  bool _isEditingGender = false;
  bool _isEditingInterests = false;

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
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Profile',
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
        actions: [
          IconButton(
            onPressed: () {
              // More options menu
            },
            icon: const Icon(Icons.more_horiz, color: AppTheme.textPrimary),
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _changePhoto,
            child: Stack(
              children: [
                UserAvatar(
                  name: user.name,
                  imageUrl: user.imageUrl,
                  size: 128,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
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
        ],
      ),
    );
  }

  Widget _buildBasicInfo(User user) {
    final List<String> genderOptions = [
      'Male', 'Female', 'Non-binary', 'Prefer not to say'
    ];

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

            // Name Field
            GestureDetector(
              onTap: () => _toggleEdit('name'),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingSM),
                decoration: BoxDecoration(
                  color: _isEditingName ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Name:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: _isEditingName
                          ? TextField(
                              controller: _nameController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your name',
                              ),
                              onSubmitted: (_) => _saveField('name'),
                            )
                          : Text(
                              user.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                    ),
                    if (!_isEditingName)
                      const Icon(Icons.edit, color: AppTheme.textSecondary, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // Age Field
            GestureDetector(
              onTap: () => _toggleEdit('age'),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingSM),
                decoration: BoxDecoration(
                  color: _isEditingAge ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Age:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMD),
                    if (_isEditingAge) ...[
                      IconButton(
                        onPressed: _age > 18 ? () => setState(() => _age--) : null,
                        icon: const Icon(Icons.remove, size: 20),
                      ),
                      Text(
                        '$_age',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        onPressed: _age < 100 ? () => setState(() => _age++) : null,
                        icon: const Icon(Icons.add, size: 20),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      IconButton(
                        onPressed: () => _saveField('age'),
                        icon: const Icon(Icons.check, color: AppTheme.successColor, size: 20),
                      ),
                    ] else ...[
                      Text(
                        user.age != null ? '${user.age}' : 'Not set',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, color: AppTheme.textSecondary, size: 16),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // Gender Field
            GestureDetector(
              onTap: () => _toggleEdit('gender'),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingSM),
                decoration: BoxDecoration(
                  color: _isEditingGender ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Gender:',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMD),
                        Expanded(
                          child: Text(
                            _selectedGender,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        if (!_isEditingGender)
                          const Icon(Icons.edit, color: AppTheme.textSecondary, size: 16),
                        if (_isEditingGender)
                          IconButton(
                            onPressed: () => _saveField('gender'),
                            icon: const Icon(Icons.check, color: AppTheme.successColor, size: 20),
                          ),
                      ],
                    ),
                    if (_isEditingGender) ...[
                      const SizedBox(height: AppTheme.spacingSM),
                      Wrap(
                        spacing: AppTheme.spacingSM,
                        runSpacing: AppTheme.spacingSM,
                        children: genderOptions.map((gender) {
                          final isSelected = gender == _selectedGender;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingMD,
                                vertical: AppTheme.spacingSM,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // Bio Field
            GestureDetector(
              onTap: () => _toggleEdit('bio'),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingSM),
                decoration: BoxDecoration(
                  color: _isEditingBio ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Bio:',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (!_isEditingBio)
                          const Icon(Icons.edit, color: AppTheme.textSecondary, size: 16),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
                    _isEditingBio
                        ? TextField(
                            controller: _bioController,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tell us about yourself',
                            ),
                            onSubmitted: (_) => _saveField('bio'),
                          )
                        : Text(
                            user.bio,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.4,
                            ),
                          ),
                    if (_isEditingBio) ...[
                      const SizedBox(height: AppTheme.spacingSM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_bioController.text.length}/150 characters',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _bioController.text.length > 150
                                  ? AppTheme.errorColor
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _saveField('bio'),
                            icon: const Icon(Icons.check, color: AppTheme.successColor, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterests() {
    final List<String> suggestedInterests = [
      '#Italian', '#Japanese', '#Mexican', '#Thai', '#Indian', '#French',
      '#Coffee', '#Wine', '#Cocktails', '#Brunch', '#Desserts', '#BBQ',
      '#Vegan', '#GlutenFree', '#SpicyFood', '#Seafood', '#Sushi',
      '#Pizza', '#Tacos', '#Ramen', '#Tapas', '#Fusion', '#FarmToTable',
      '#Design', '#Travel', '#Photography', '#Minimalism', '#Art',
      '#Music', '#LiveMusic', '#Jazz', '#Classical', '#Rock',
      '#Sports', '#Fitness', '#Yoga', '#Running', '#Cycling',
      '#Reading', '#Books', '#Writing', '#Poetry', '#Film',
      '#Tech', '#Startups', '#Programming', '#AI', '#Gaming',
      '#Nature', '#Hiking', '#Beach', '#Mountains', '#Parks',
      '#Fashion', '#Style', '#Shopping', '#Vintage', '#Sustainable',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Interests',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSM),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSM, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_selectedInterests.length}/5',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _toggleEdit('interests'),
                child: Icon(
                  _isEditingInterests ? Icons.check : Icons.edit,
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),

          // Selected Interests
          if (_selectedInterests.isNotEmpty) ...[
            Wrap(
              spacing: AppTheme.spacingSM,
              runSpacing: AppTheme.spacingSM,
              children: _selectedInterests.asMap().entries.map((entry) {
                final index = entry.key;
                final interest = entry.value;
                return Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        interest,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isEditingInterests) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _removeInterest(index),
                          child: const Icon(
                            Icons.close,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingMD),
          ],

          // Add Interest Section (only in edit mode)
          if (_isEditingInterests) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: _selectedInterests.length >= 5
                          ? 'Maximum interests reached'
                          : 'Add new interest (e.g., Coffee)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      prefixText: '#',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMD,
                        vertical: AppTheme.spacingSM,
                      ),
                    ),
                    enabled: _selectedInterests.length < 5,
                    onSubmitted: (value) => _addInterest(value),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSM),
                IconButton(
                  onPressed: _showInterestSuggestions,
                  icon: const Icon(Icons.lightbulb_outline),
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),

            // Suggestions Section
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSM),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested Interests:',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSM),
                  Wrap(
                    spacing: AppTheme.spacingSM,
                    runSpacing: AppTheme.spacingSM,
                    children: suggestedInterests.take(12).map((suggestion) {
                      final isSelected = _selectedInterests.contains(suggestion);
                      return GestureDetector(
                        onTap: isSelected ? null : () => _addInterest(suggestion.substring(1)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSM,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.textTertiary
                                : AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.textTertiary
                                  : AppTheme.primaryColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            suggestion,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.textSecondary
                                  : AppTheme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: isSelected ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              _selectedInterests.isEmpty
                  ? 'No interests added yet. Tap edit to add some!'
                  : 'Tap edit to modify interests',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  User _getCurrentUser() {
    return User(
      id: 'current_user',
      name: _nameController.text,
      username: _usernameController.text,
      age: _age,
      bio: _bioController.text,
      imageUrl: 'https://picsum.photos/200/200?random=current',
      interests: _selectedInterests,
    );
  }

  void _toggleEdit(String field) {
    setState(() {
      // Reset all editing states first
      _isEditingName = false;
      _isEditingUsername = false;
      _isEditingAge = false;
      _isEditingBio = false;
      _isEditingGender = false;
      _isEditingInterests = false;

      // Set the specific field to editing mode
      switch (field) {
        case 'name':
          _isEditingName = !_isEditingName;
          break;
        case 'username':
          _isEditingUsername = !_isEditingUsername;
          break;
        case 'age':
          _isEditingAge = !_isEditingAge;
          break;
        case 'bio':
          _isEditingBio = !_isEditingBio;
          break;
        case 'gender':
          _isEditingGender = !_isEditingGender;
          break;
        case 'interests':
          _isEditingInterests = !_isEditingInterests;
          break;
      }
    });
  }

  void _saveField(String field) {
    setState(() {
      switch (field) {
        case 'name':
          _isEditingName = false;
          break;
        case 'username':
          _isEditingUsername = false;
          break;
        case 'age':
          _isEditingAge = false;
          break;
        case 'bio':
          if (_bioController.text.length > 150) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bio must be 150 characters or less'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            return;
          }
          _isEditingBio = false;
          break;
        case 'gender':
          _isEditingGender = false;
          break;
        case 'interests':
          _isEditingInterests = false;
          break;
      }
    });

    Logger.info('Profile field saved: $field');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Field updated successfully!'),
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

  void _addInterest(String interest) {
    if (interest.trim().isEmpty) return;

    final formattedInterest = interest.trim().startsWith('#')
        ? interest.trim()
        : '#${interest.trim()}';

    if (_selectedInterests.contains(formattedInterest)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$formattedInterest is already in your interests'),
          backgroundColor: AppTheme.textSecondary,
        ),
      );
      return;
    }

    if (_selectedInterests.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 interests allowed'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _selectedInterests.add(formattedInterest);
    });

    Logger.info('Interest added: $formattedInterest');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$formattedInterest added!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _removeInterest(int index) {
    if (index < 0 || index >= _selectedInterests.length) return;

    final removedInterest = _selectedInterests[index];
    setState(() {
      _selectedInterests.removeAt(index);
    });

    Logger.info('Interest removed: $removedInterest');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$removedInterest removed'),
        backgroundColor: AppTheme.textSecondary,
      ),
    );
  }

  void _showInterestSuggestions() {
    final List<String> allSuggestions = [
      '#Italian', '#Japanese', '#Mexican', '#Thai', '#Indian', '#French',
      '#Coffee', '#Wine', '#Cocktails', '#Brunch', '#Desserts', '#BBQ',
      '#Vegan', '#GlutenFree', '#SpicyFood', '#Seafood', '#Sushi',
      '#Pizza', '#Tacos', '#Ramen', '#Tapas', '#Fusion', '#FarmToTable',
      '#Design', '#Travel', '#Photography', '#Minimalism', '#Art',
      '#Music', '#LiveMusic', '#Jazz', '#Classical', '#Rock',
      '#Sports', '#Fitness', '#Yoga', '#Running', '#Cycling',
      '#Reading', '#Books', '#Writing', '#Poetry', '#Film',
      '#Tech', '#Startups', '#Programming', '#AI', '#Gaming',
      '#Nature', '#Hiking', '#Beach', '#Mountains', '#Parks',
      '#Fashion', '#Style', '#Shopping', '#Vintage', '#Sustainable',
      '#Cooking', '#Baking', '#CraftBeer', '#WineTasting', '#Foodie',
      '#Dancing', '#Nightlife', '#Karaoke', '#Socializing', '#Networking',
      '#Entrepreneurship', '#Innovation', '#Science', '#Space', '#Environment',
      '#Animals', '#Pets', '#Dogs', '#Cats', '#Wildlife',
      '#History', '#Museums', '#Architecture', '#Culture', '#Languages',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMD),
                child: Row(
                  children: [
                    Text(
                      'All Interest Suggestions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
                  itemCount: (allSuggestions.length / 3).ceil(),
                  itemBuilder: (context, rowIndex) {
                    final startIndex = rowIndex * 3;
                    final endIndex = (startIndex + 3).clamp(0, allSuggestions.length);
                    final rowItems = allSuggestions.sublist(startIndex, endIndex);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingSM),
                      child: Row(
                        children: rowItems.map((suggestion) {
                          final isSelected = _selectedInterests.contains(suggestion);
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: AppTheme.spacingSM),
                              child: GestureDetector(
                                onTap: isSelected ? null : () {
                                  _addInterest(suggestion.substring(1));
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingSM,
                                    vertical: AppTheme.spacingMD,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.textTertiary
                                        : AppTheme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.textTertiary
                                          : AppTheme.primaryColor.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppTheme.textSecondary
                                          : AppTheme.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: isSelected ? TextDecoration.lineThrough : null,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}