import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../../services/messaging_service.dart';
import '../../services/mock/mock_data_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/member_profile_popup.dart';
import '../../utils/logger.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;
  final bool isGroup;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.conversationName,
    required this.isGroup,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessagingService _messagingService = MessagingService();
  final MockDataService _dataService = MockDataService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isTyping = false;

  // Group data for synchronization
  Group? _group;

  @override
  void initState() {
    super.initState();
    _loadGroupData();
    _loadMessages();
    _markAsRead();
  }

  void _loadMessages() {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = _messagingService.getMessages(widget.conversationId);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      Logger.error('Error loading messages: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages')),
        );
      }
    }
  }

  void _loadGroupData() {
    if (widget.isGroup) {
      _group = _dataService.getGroupById(widget.conversationId);
      Logger.info('Loaded group data for chat: ${_group?.name ?? "Not found"}');
    }
  }

  void _markAsRead() {
    _messagingService.markAsRead(widget.conversationId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showConversationInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    if (widget.isGroup) {
      return InkWell(
        onTap: _navigateToGroupInfo,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.group,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.conversationName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                  Text(
                    _group != null
                        ? '${_group!.memberCount}/${_group!.maxMembers} members • ${_messages.length} messages'
                        : '${_messages.length} messages',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // For direct messages (though we don't have them anymore, keeping for completeness)
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              _showMemberProfile(widget.conversationName);
            },
            child: UserAvatar(
              size: 36,
              imageUrl: '', // In real app, would have user image
              name: widget.conversationName,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMessagesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
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
            'Start the conversation',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to begin chatting',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isCurrentUser = message.isFromCurrentUser('current_user');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser && widget.isGroup) ...[
            GestureDetector(
              onTap: () {
                _showMemberProfile(message.senderName);
              },
              child: UserAvatar(
                size: 32,
                imageUrl: '', // In real app, would have sender image
                name: message.senderName,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (widget.isGroup && !isCurrentUser) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(message, isCurrentUser),
                    borderRadius: _getBubbleBorderRadius(isCurrentUser),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(message),
                ),
                const SizedBox(height: 4),
                _buildMessageMetadata(message, isCurrentUser),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage(message);
      case MessageType.system:
        return _buildSystemMessage(message);
      case MessageType.text:
        return _buildTextMessage(message);
    }
  }

  Widget _buildTextMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isFromCurrentUser('current_user')
            ? Colors.white
            : AppTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildImageMessage(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.imageUrl ?? '',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: AppTheme.cardColor,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    color: AppTheme.textSecondary,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ),
        if (message.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSystemMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        message.text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMessageMetadata(Message message, bool isCurrentUser) {
    return Padding(
      padding: EdgeInsets.only(
        left: isCurrentUser ? 0 : 8,
        right: isCurrentUser ? 8 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.formattedTime,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
          if (isCurrentUser && message.status != MessageStatus.failed) ...[
            const SizedBox(width: 4),
            _buildMessageStatusIcon(message.status),
          ],
        ],
      ),
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
      size: 12,
      color: iconColor,
    );
  }

  Widget _buildTypingIndicator() {
    final typingUsers = _messagingService.getTypingUsers(widget.conversationId);

    if (typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${typingUsers.join(", ")} is typing...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _sendImage,
            color: AppTheme.primaryColor,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
                maxLines: 5,
                minLines: 1,
                onChanged: _onTextChanged,
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Color _getBubbleColor(Message message, bool isCurrentUser) {
    if (message.type == MessageType.system) {
      return AppTheme.cardColor;
    }

    if (isCurrentUser) {
      return AppTheme.primaryColor;
    }

    return AppTheme.cardColor;
  }

  BorderRadius _getBubbleBorderRadius(bool isCurrentUser) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isCurrentUser ? const Radius.circular(20) : const Radius.circular(8),
      bottomRight: isCurrentUser ? const Radius.circular(8) : const Radius.circular(20),
    );
  }

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  Future<void> _sendMessage([String? text]) async {
    final messageText = text ?? _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      final message = await _messagingService.sendMessage(
        conversationId: widget.conversationId,
        text: messageText,
      );

      setState(() {
        _messages.add(message);
      });

      _messageController.clear();
      _scrollToBottom();
      _markAsRead();
    } catch (e) {
      Logger.error('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message')),
        );
      }
    }
  }

  Future<void> _sendImage() async {
    // TODO: Implement image sending
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image sending coming soon')),
    );
  }

  void _showConversationInfo() {
    _navigateToGroupInfo();
  }

  void _navigateToGroupInfo() {
    if (widget.isGroup) {
      // Navigate to group info screen with consistent data
      if (_group != null) {
        // Pass actual group object for consistency
        Navigator.pushNamed(
          context,
          '/group_info',
          arguments: {'group': _group},
        );
      } else {
        // Fallback to ID-based lookup
        Navigator.pushNamed(
          context,
          '/group_info',
          arguments: {
            'groupId': widget.conversationId,
          },
        );
      }
    } else {
      // For direct messages (not used anymore, but keeping for completeness)
      _showMemberProfile(widget.conversationName);
    }
  }

  void _showMemberProfile(String userName) {
    // Create a mock user for demo purposes
    // In a real app, you would fetch the actual user data from your service
    final mockUser = User(
      id: 'user_${userName.hashCode.abs()}',
      name: userName,
      username: userName.toLowerCase().replaceAll(' ', '_'),
      age: 22 + (userName.hashCode % 25), // Mock age between 22-47
      bio: 'Active participant in the ${widget.conversationName} conversation. Loves meeting new people and sharing dining experiences.',
      imageUrl: 'https://picsum.photos/400/600?random=${userName.hashCode}',
      interests: ['Dining', 'Social', 'Food', 'Conversation'],
      isAvailable: true,
      distance: 2.0 + (userName.hashCode % 8).toDouble(), // Mock distance 2-10 miles
      lastSeen: DateTime.now().subtract(Duration(minutes: userName.hashCode % 120)),
      intents: ['dining', 'friendship', 'networking'],
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MemberProfilePopup(
        user: mockUser,
        onClose: () {
          Logger.info('Member profile popup closed for: $userName');
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}