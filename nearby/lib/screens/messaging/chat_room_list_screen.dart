import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../services/messaging_service.dart';
import '../../mock/services/mock_data_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/user_avatar.dart';
import '../../utils/logger.dart';

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  final MessagingService _messagingService = MessagingService();
  final MockDataService _mockDataService = MockDataService();
  List<Conversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the widget is fully built before loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConversations();
    });
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final conversations = _messagingService.getConversations();
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      Logger.error('Error loading conversations: $e');
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages')),
        );
      }
    }
  }

  // Check if the current user is the creator of the group based on MockUser data
  bool _isUserGroupCreator(String groupId) {
    final mockUser = _mockDataService.getCurrentMockUser();
    if (mockUser == null) return false;

    final conversations = _messagingService.getConversations();
    final groupIndex = conversations.indexWhere((conv) => conv.id == groupId);

    // If this is one of the first N conversations where N = groupsCreated,
    // then this group should be considered as created by the user
    return groupIndex < mockUser.activity.groupsCreated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchMessages,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _newMessage,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadConversations,
        color: AppTheme.primaryColor,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_conversations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return _buildConversationItem(conversation);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No group messages yet',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join dining groups to start chatting\nwith fellow food enthusiasts',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _discoverPeople,
            icon: const Icon(Icons.groups),
            label: const Text('Discover Groups'),
            style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(Conversation conversation) {
    return InkWell(
      onTap: () => _openConversation(conversation),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildAvatar(conversation),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                conversation.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Show "Owner" badge if user created this group
                            if (conversation.isGroup && _isUserGroupCreator(conversation.id)) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'OWNER',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        conversation.formattedTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildLastMessage(conversation.lastMessage),
                      ),
                      _buildUnreadIndicator(conversation),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Conversation conversation) {
    if (conversation.isGroup) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.group,
          color: Colors.white,
          size: 24,
        ),
      );
    } else {
      return UserAvatar(
        size: 48,
        imageUrl: '', // In real app, would have user image
        name: conversation.name,
      );
    }
  }

  Widget _buildLastMessage(Message message) {
    IconData messageIcon;
    switch (message.type) {
      case MessageType.image:
        messageIcon = Icons.image;
        break;
      case MessageType.system:
        messageIcon = Icons.info_outline;
        break;
      case MessageType.text:
        messageIcon = Icons.message;
    }

    return Row(
      children: [
        if (message.type == MessageType.image) ...[
          Icon(
            messageIcon,
            size: 16,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            _formatLastMessage(message),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getMessageColor(message),
              fontWeight: message.status == MessageStatus.sent
                ? FontWeight.w500
                : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (message.status == MessageStatus.sent ||
            message.status == MessageStatus.delivered) ...[
          const SizedBox(width: 4),
          _buildMessageStatusIcon(message.status),
        ],
      ],
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.sent:
        iconData = Icons.check;
        iconColor = AppTheme.textSecondary;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = AppTheme.textSecondary;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        iconColor = AppTheme.primaryColor;
        break;
      case MessageStatus.failed:
        iconData = Icons.error_outline;
        iconColor = AppTheme.errorColor;
        break;
    }

    return Icon(
      iconData,
      size: 14,
      color: iconColor,
    );
  }

  Widget _buildUnreadIndicator(Conversation conversation) {
    if (conversation.unreadCount == 0) {
      return const SizedBox.shrink();
    }

    final count = conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatLastMessage(Message message) {
    if (message.type == MessageType.image) {
      return '📷 Photo';
    } else if (message.type == MessageType.system) {
      return message.text;
    } else {
      return message.text;
    }
  }

  Color _getMessageColor(Message message) {
    if (message.isFromCurrentUser('current_user')) {
      return message.status == MessageStatus.sent
        ? AppTheme.textSecondary
        : AppTheme.textPrimary;
    }
    return AppTheme.textPrimary;
  }

  void _openConversation(Conversation conversation) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'conversationId': conversation.id,
        'conversationName': conversation.name,
        'isGroup': conversation.isGroup,
      },
    );
  }

  void _searchMessages() {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search coming soon')),
    );
  }

  void _newMessage() {
    // TODO: Implement new message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New message coming soon')),
    );
  }

  void _discoverPeople() {
    Navigator.pushNamed(context, '/discover');
  }
}