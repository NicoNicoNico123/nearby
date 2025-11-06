import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LanguageSearchScreen extends StatefulWidget {
  final Set<String> initiallySelectedLanguages;

  const LanguageSearchScreen({
    super.key,
    required this.initiallySelectedLanguages,
  });

  @override
  State<LanguageSearchScreen> createState() => _LanguageSearchScreenState();
}

class _LanguageSearchScreenState extends State<LanguageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Set<String> _selectedLanguages = {};
  List<String> _availableLanguages = [];
  List<String> _filteredLanguages = [];
  List<String> _recommendedLanguages = [];

  static const List<String> _popularLanguages = [
    'English', 'Spanish', 'French', 'German', 'Italian',
    'Portuguese', 'Chinese', 'Japanese', 'Korean', 'Arabic',
    'Hindi', 'Russian', 'Dutch', 'Swedish', 'Norwegian',
    'Danish', 'Finnish', 'Polish', 'Turkish', 'Greek'
  ];

  static const List<String> _allLanguages = [
    'English', 'Spanish', 'French', 'German', 'Italian',
    'Portuguese', 'Chinese', 'Japanese', 'Korean', 'Arabic',
    'Hindi', 'Russian', 'Dutch', 'Swedish', 'Norwegian',
    'Danish', 'Finnish', 'Polish', 'Turkish', 'Greek',
    'Czech', 'Hungarian', 'Romanian', 'Ukrainian', 'Bulgarian',
    'Croatian', 'Serbian', 'Slovak', 'Estonian', 'Latvian',
    'Lithuanian', 'Thai', 'Vietnamese', 'Indonesian', 'Malay',
    'Filipino', 'Hebrew', 'Persian', 'Urdu', 'Bengali',
    'Tamil', 'Telugu', 'Marathi', 'Gujarati', 'Kannada',
    'Malayalam', 'Punjabi', 'Nepali', 'Sinhala', 'Burmese',
    'Khmer', 'Lao', 'Mongolian', 'Kazakh', 'Uzbek'
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguages = Set.from(widget.initiallySelectedLanguages);
    _loadAvailableLanguages();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadAvailableLanguages() {
    setState(() {
      _availableLanguages = _allLanguages;
      _recommendedLanguages = _getRecommendedLanguages();
      _filteredLanguages = _recommendedLanguages;
    });
  }

  List<String> _getRecommendedLanguages() {
    // Return popular languages as recommendations
    return _popularLanguages.take(12).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLanguages = _recommendedLanguages;
      } else {
        _filteredLanguages = _availableLanguages
            .where((language) => language.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleLanguage(String language) {
    setState(() {
      if (_selectedLanguages.contains(language)) {
        _selectedLanguages.remove(language);
      } else if (_selectedLanguages.length < 3) {
        _selectedLanguages.add(language);
      } else {
        // Show message that maximum 3 languages can be selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 3 languages can be selected'),
            backgroundColor: AppTheme.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _applySelection() {
    Navigator.pop(context, _selectedLanguages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Select Languages',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: _selectedLanguages.isNotEmpty
                ? () => setState(() => _selectedLanguages.clear())
                : null,
            child: Text(
              'Clear',
              style: TextStyle(
                color: _selectedLanguages.isNotEmpty
                    ? AppTheme.primaryColor
                    : AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search languages...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppTheme.spacingMD),
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),

          // Selection status
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSM),
                Expanded(
                  child: Text(
                    '${_selectedLanguages.length}/3 languages selected',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMD),

          // Language list
          Expanded(
            child: _filteredLanguages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: AppTheme.spacingMD),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No languages available'
                              : 'No languages found',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
                    itemCount: _filteredLanguages.length,
                    itemBuilder: (context, index) {
                      final language = _filteredLanguages[index];
                      final isSelected = _selectedLanguages.contains(language);

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            language,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : null,
                          onTap: () => _toggleLanguage(language),
                        ),
                      );
                    },
                  ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedLanguages.isNotEmpty ? _applySelection : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.textTertiary,
                ),
                child: Text(
                  'Apply Selection (${_selectedLanguages.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}