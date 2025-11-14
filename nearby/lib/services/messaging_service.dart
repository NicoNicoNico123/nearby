import 'dart:async';
import 'dart:math';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/logger.dart';
import '../mock/services/mock_data_service.dart';

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
    final mockUser = MockDataService().getCurrentMockUser();

    // Calculate total conversations needed based on MockUser data
    int totalConversations = 3; // Default fallback
    if (mockUser != null) {
      final activity = mockUser.activity;
      totalConversations = activity.groupsCreated + activity.groupsJoined;
    }

    // Group messages - use actual groups from MockDataService
    final groups = MockDataService().getGroups();

    // Get MockUser data to determine how many groups user created
    int groupsCreatedByUser = 1; // Default fallback
    if (mockUser != null) {
      groupsCreatedByUser = mockUser.activity.groupsCreated;
    }

    for (int i = 0; i < groups.length && i < totalConversations; i++) { // Use MockUser data
      final group = groups[i];
      final groupId = group.id;
      final messages = <Message>[];

      // Determine if this group should be created by current user
      final isUserCreator = i < groupsCreatedByUser;

      messages.add(Message.system(
        id: 'msg_${groupId}_system1',
        text: '${group.name} - ${group.venue}${isUserCreator ? ' (You are the host)' : ''}',
        timestamp: DateTime.now().subtract(Duration(hours: 8 + i * 2)),
      ));

      // Create messages from actual group members
      final groupMembers = MockDataService().getUsers().take(5).toList();
      final messageCount = _random.nextInt(4) + 3; // 3-6 messages per conversation

      for (int j = 0; j < messageCount; j++) {
        final member = groupMembers[_random.nextInt(groupMembers.length)];
        if (member.id != currentUser.id) { // Don't create message from current user
          messages.add(Message.text(
            id: 'msg_${groupId}_${j + 1}',
            senderId: member.id,
            senderName: member.name,
            text: _getExpandedGroupMessage(j, group.category),
            timestamp: DateTime.now().subtract(Duration(hours: 6 + i - j, minutes: _random.nextInt(60))),
          ));
        }
      }

      // Add 1-2 messages from current user
      final currentUserMessages = _random.nextInt(2) + 1;
      for (int k = 0; k < currentUserMessages; k++) {
        messages.add(Message.text(
          id: 'msg_${groupId}_current_$k',
          senderId: currentUser.id,
          senderName: currentUser.name,
          text: _getExpandedRandomMessage(isCurrentUser: true, category: group.category),
          timestamp: DateTime.now().subtract(Duration(hours: 3 + i - k, minutes: _random.nextInt(30))),
        ));
      }

      // Add a more recent message to keep conversation active
      if (_random.nextBool()) {
        final recentMember = groupMembers[_random.nextInt(groupMembers.length)];
        if (recentMember.id != currentUser.id) {
          messages.add(Message.text(
            id: 'msg_${groupId}_recent',
            senderId: recentMember.id,
            senderName: recentMember.name,
            text: _getExpandedGroupMessage(99, group.category),
            timestamp: DateTime.now().subtract(Duration(minutes: _random.nextInt(120) + 10)),
          ));
        }
      }

      _conversations[groupId] = messages;
    }

    Logger.info('Created ${_conversations.length} mock conversations');
  }

  // Get random user name
  String _getRandomUserName() {
    final names = ['Alex Chen', 'Maya Patel', 'Jordan Lee', 'Taylor Kim'];
    return names[_random.nextInt(names.length)];
  }

  // Get expanded group-specific message
  String _getExpandedGroupMessage(int index, String? category) {
    final generalMessages = [
      'Hey everyone! Excited for this meetup',
      'Same here! Should we meet at the venue?',
      'Looking forward to trying some $category food!',
      'This is going to be amazing! 🎉',
      'Anyone want to carpool?',
      'First time joining this group, excited to meet everyone!',
      'The venue looks great from the photos',
      'Should we make reservations?',
      'Counting down the hours!',
      'Hope the weather is nice',
    ];

    final italianMessages = [
      'Can\'t wait for some authentic pasta! 🍝',
      'Hope they have good tiramisu',
      'Anyone else love garlic bread as much as I do?',
      'Italian food is my comfort food',
      'Might need to unbutton my pants after this 😄',
    ];

    final sushiMessages = [
      'Sushi!!! 🍣🍣🍣',
      'I\'m bringing my appetite',
      'Who\'s down for some sake bombs?',
      'Fresh fish is the best fish',
      'Hope they have good miso soup',
    ];

    final coffeeMessages = [
      'Coffee addicts unite! ☕',
      'I wonder if they have oat milk',
      'Anyone tried their cold brew?',
      'Pastries and coffee = perfect combo',
      'Might be over-caffeinated after this',
    ];

    final spicyMessages = [
      'Bring on the heat! 🌶️',
      'Hope they have water ready',
      'I can handle anything they throw at me',
      'Spicy food is my weakness',
      'Anyone else bring tissues? 😂',
    ];

    List<String> categoryMessages = generalMessages;

    if (category != null) {
      switch (category.toLowerCase()) {
        case 'italian':
        case 'pizza':
          categoryMessages = [...generalMessages, ...italianMessages];
          break;
        case 'japanese':
        case 'sushi':
          categoryMessages = [...generalMessages, ...sushiMessages];
          break;
        case 'coffee':
          categoryMessages = [...generalMessages, ...coffeeMessages];
          break;
        case 'mexican':
        case 'spicy':
          categoryMessages = [...generalMessages, ...spicyMessages];
          break;
      }
    }

    if (index == 99) { // Recent message
      final recentMessages = [
        'Just confirmed my spot!',
        'Running 5 minutes late, sorry!',
        'See you all soon!',
        'Can\'t wait! 🎊',
        'Anyone parking at the venue?',
      ];
      return recentMessages[_random.nextInt(recentMessages.length)];
    }

    return categoryMessages[index % categoryMessages.length];
  }

  // Get expanded random message
  String _getExpandedRandomMessage({bool isCurrentUser = false, String? category}) {
    final currentUserMessages = [
      'Sounds fun! I\'d love to join.',
      'What time are you thinking?',
      'I\'m free this weekend',
      'That sounds perfect!',
      'Count me in!',
      'Looking forward to it',
      'Should I bring anything?',
      'Can I invite a friend?',
      'This is exactly what I needed!',
      'You guys are the best! 🙏',
    ];

    final otherUserMessages = [
      'Hey! Want to grab dinner sometime?',
      'Found this cool new restaurant downtown',
      'Anyone up for brunch this weekend?',
      'Join our group for food adventures!',
      'Let\'s explore some new places',
      'Food lovers unite! 🍕',
      'The food scene here is amazing',
      'Who\'s up for trying something new?',
      'Life is too short for bad food!',
      'Good food, good company, good times ✨',
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