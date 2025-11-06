import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class MemberProfilePopup extends StatefulWidget {
  final User user;
  final VoidCallback? onClose;

  const MemberProfilePopup({
    super.key,
    required this.user,
    this.onClose,
  });

  @override
  State<MemberProfilePopup> createState() => _MemberProfilePopupState();
}

class _MemberProfilePopupState extends State<MemberProfilePopup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  // Mock profile images for demo (in real app, these would come from user.profileImages)
  final List<String> _profileImages = [
    'https://picsum.photos/400/600?random=profile1',
    'https://picsum.photos/400/600?random=profile2',
    'https://picsum.photos/400/600?random=profile3',
    'https://picsum.photos/400/600?random=profile4',
    'https://picsum.photos/400/600?random=profile5',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _closePopup() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onClose?.call();
      }
    });
  }

  void _onImagePageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _showImageZoomDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Background dark overlay
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.9),
              ),
            ),
            // Image
            Center(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: AppTheme.textTertiary,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: child,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              _buildHeader(),

              // Image carousel
              _buildImageCarousel(),

              // Profile information
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and username
                      _buildNameSection(),

                      const SizedBox(height: AppTheme.spacingMD),

                      // Bio
                      if (widget.user.bio.isNotEmpty) ...[
                        _buildBioSection(),
                        const SizedBox(height: AppTheme.spacingMD),
                      ],

                      // Personal info
                      _buildPersonalInfo(),

                      const SizedBox(height: AppTheme.spacingMD),

                      // Interests
                      if (widget.user.interests.isNotEmpty) ...[
                        _buildInterestsSection(),
                        const SizedBox(height: AppTheme.spacingMD),
                      ],

                      // Intents
                      if (widget.user.intents.isNotEmpty) ...[
                        _buildIntentsSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLG, vertical: AppTheme.spacingMD),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _closePopup,
            icon: const Icon(
              Icons.close,
              color: AppTheme.textSecondary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 250,
      child: Stack(
        children: [
          // PageView for images
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onImagePageChanged,
            itemCount: _profileImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImageZoomDialog(_profileImages[index]),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(AppTheme.spacingMD),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme.backgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _profileImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 64,
                                color: AppTheme.textTertiary,
                              ),
                              const SizedBox(height: AppTheme.spacingSM),
                              Text(
                                'Profile Photo ${index + 1}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          // Image indicators
          Positioned(
            bottom: AppTheme.spacingMD,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _profileImages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentImageIndex
                        ? AppTheme.primaryColor
                        : AppTheme.textTertiary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.user.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.user.isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSM,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Available',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        if (widget.user.username != null) ...[
          const SizedBox(height: 4),
          Text(
            '@${widget.user.username}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBioSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            widget.user.bio,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          if (widget.user.age != null)
            _buildInfoRow(Icons.cake, 'Age', '${widget.user.age} years old'),
          if (widget.user.distance != null)
            _buildInfoRow(Icons.location_on, 'Distance', '${widget.user.distance!.toInt()} miles away'),
          _buildInfoRow(Icons.access_time, 'Last Seen',
            widget.user.lastSeen != null
                ? _formatLastSeen(widget.user.lastSeen!)
                : 'Unknown'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: Text(
              '$label: $value',
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

  Widget _buildInterestsSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Wrap(
            spacing: AppTheme.spacingSM,
            runSpacing: AppTheme.spacingSM,
            children: widget.user.interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSM,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIntentsSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Looking For',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Wrap(
            spacing: AppTheme.spacingSM,
            runSpacing: AppTheme.spacingSM,
            children: widget.user.intents.map((intent) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSM,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _formatIntent(intent),
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatIntent(String intent) {
    switch (intent.toLowerCase()) {
      case 'dining':
        return 'Casual Dining';
      case 'romantic':
        return 'Romantic';
      case 'networking':
        return 'Networking';
      case 'friendship':
        return 'Making Friends';
      default:
        return intent;
    }
  }
}