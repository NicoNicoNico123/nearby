import 'dart:async';
import 'dart:math';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/logger.dart';
import 'mock_data_service.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final Map<String, List<Message>> _conversations = {};
  final Map<String, DateTime> _lastRead = {};
  final Random _random = Random();

  // Get all conversations for current user (group chats only)
  List<Conversation> getConversations() {
    _initializeMockConversations();
    final conversations = <Conversation>[];

    // Add only group conversations
    for (final entry in _conversations.entries) {
      final messages = entry.value;
      if (messages.isNotEmpty && entry.key.startsWith('group_')) {
        final lastMessage = messages.last;
        final unreadCount = _getUnreadCount(entry.key);

        conversations.add(Conversation(
          id: entry.key,
          name: _getConversationName(entry.key),
          lastMessage: lastMessage,
          unreadCount: unreadCount,
          timestamp: lastMessage.timestamp,
          isGroup: true,
        ));
      }
    }

    // Sort by most recent message
    conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return conversations;
  }

  // Get messages for a specific conversation
  List<Message> getMessages(String conversationId) {
    _initializeMockConversations();
    return _conversations[conversationId] ?? [];
  }

  // Send a message
  Future<Message> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    final currentUser = _getCurrentUser();
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUser.id,
      senderName: currentUser.name,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
      type: imageUrl != null ? MessageType.image : MessageType.text,
      imageUrl: imageUrl,
    );

    if (!_conversations.containsKey(conversationId)) {
      _conversations[conversationId] = [];
    }

    _conversations[conversationId]!.add(message);

    // Simulate message delivery
    _simulateMessageDelivery(conversationId, message);

    Logger.info('Message sent to $conversationId: ${message.text}');
    return message;
  }

  // Mark messages as read
  void markAsRead(String conversationId) {
    _lastRead[conversationId] = DateTime.now();
    final messages = _conversations[conversationId] ?? [];

    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].status != MessageStatus.read) {
        messages[i] = messages[i].copyWith(status: MessageStatus.read);
      } else {
        break;
      }
    }

    Logger.info('Marked $conversationId as read');
  }

  // Get unread count for a conversation
  int _getUnreadCount(String conversationId) {
    final lastReadTime = _lastRead[conversationId];
    if (lastReadTime == null) return _conversations[conversationId]?.length ?? 0;

    final messages = _conversations[conversationId] ?? [];
    return messages.where((msg) => msg.timestamp.isAfter(lastReadTime)).length;
  }

  // Get conversation name (groups only)
  String _getConversationName(String conversationId) {
    // Only handle group conversations
    return _getGroupName(conversationId);
  }

  
  // Get group name from MockDataService
  String _getGroupName(String groupId) {
    final group = MockDataService().getGroupById(groupId);
    if (group != null) {
      return group.name;
    }

    // Fallback for mock conversations
    final groupNames = [
      'Weekend Brunch Club',
      'Tech Talk & Coffee',
      'Pizza Lovers Meetup',
      'Sushi Adventure',
    ];
    return groupNames[_random.nextInt(groupNames.length)];
  }

  // Simulate message delivery
  void _simulateMessageDelivery(String conversationId, Message message) {
    // Simulate delivery
    Future.delayed(const Duration(seconds: 1), () {
      final messages = _conversations[conversationId] ?? [];
      final index = messages.indexWhere((msg) => msg.id == message.id);
      if (index != -1) {
        messages[index] = messages[index].copyWith(status: MessageStatus.delivered);

        // Simulate read
        Future.delayed(const Duration(seconds: 2), () {
          final updatedMessages = _conversations[conversationId] ?? [];
          final updatedIndex = updatedMessages.indexWhere((msg) => msg.id == message.id);
          if (updatedIndex != -1) {
            updatedMessages[updatedIndex] = updatedMessages[updatedIndex].copyWith(status: MessageStatus.read);
          }
        });
      }
    });
  }

  // Initialize mock conversations
  void _initializeMockConversations() {
    if (_conversations.isEmpty) {
      _createMockConversations();
    }
  }

  // Create mock conversation data (group chats only)
  void _createMockConversations() {
    final currentUser = _getCurrentUser();

    // Group messages - use actual groups from MockDataService
    final groups = MockDataService().getGroups();
    for (int i = 0; i < groups.length && i < 3; i++) { // Limit to 3 group conversations
      final group = groups[i];
      final groupId = group.id;
      final messages = <Message>[];

      messages.add(Message.system(
        id: 'msg_${groupId}_system1',
        text: _getGroupName(groupId),
        timestamp: DateTime.now().subtract(Duration(hours: 5 + i)),
      ));

      // Create messages from actual group members
      final groupMembers = MockDataService().getUsers().take(3).toList();

      for (int j = 0; j < groupMembers.length; j++) {
        final member = groupMembers[j];
        if (member.id != currentUser.id) { // Don't create message from current user
          messages.add(Message.text(
            id: 'msg_${groupId}_${j + 1}',
            senderId: member.id,
            senderName: member.name,
            text: _getGroupMessage(j),
            timestamp: DateTime.now().subtract(Duration(hours: 4 + i - j)),
          ));
        }
      }

      // Add message from current user
      messages.add(Message.text(
        id: 'msg_${groupId}_current',
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: _getRandomMessage(isCurrentUser: true),
        timestamp: DateTime.now().subtract(Duration(hours: 2 + i)),
      ));

      _conversations[groupId] = messages;
    }

    Logger.info('Created ${_conversations.length} mock conversations');
  }

  // Get random user name
  String _getRandomUserName() {
    final names = ['Alex Chen', 'Maya Patel', 'Jordan Lee', 'Taylor Kim'];
    return names[_random.nextInt(names.length)];
  }

  // Get group-specific message
  String _getGroupMessage(int index) {
    final groupMessages = [
      'Hey everyone! Excited for this meetup',
      'Same here! Should we meet at the venue?',
      'Looking forward to trying the ${MockDataService().getGroups().isNotEmpty ? MockDataService().getGroups().first.category : 'food'}',
    ];
    return groupMessages[index % groupMessages.length];
  }

  // Get random message
  String _getRandomMessage({bool isCurrentUser = false}) {
    final currentUserMessages = [
      'Sounds fun! I\'d love to join.',
      'What time are you thinking?',
      'I\'m free this weekend',
      'That sounds perfect!',
      'Count me in!',
      'Looking forward to it',
    ];

    final otherUserMessages = [
      'Hey! Want to grab dinner sometime?',
      'Found this cool new restaurant downtown',
      'Anyone up for brunch this weekend?',
      'Join our group for food adventures!',
      'Let\'s explore some new places',
      'Food lovers unite! 🍕',
    ];

    final messages = isCurrentUser ? currentUserMessages : otherUserMessages;
    return messages[_random.nextInt(messages.length)];
  }

  // Get current user from MockDataService
  User _getCurrentUser() {
    return MockDataService().getCurrentUser();
  }

  // Get typing users in conversation
  List<String> getTypingUsers(String conversationId) {
    // Mock typing users - in real app this would come from WebSocket
    if (_random.nextBool() && _random.nextBool()) {
      return [_getRandomUserName()];
    }
    return [];
  }
}

class Conversation {
  final String id;
  final String name;
  final Message lastMessage;
  final int unreadCount;
  final DateTime timestamp;
  final bool isGroup;

  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
    required this.timestamp,
    required this.isGroup,
  });

  // Format timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}