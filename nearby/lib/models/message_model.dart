class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;
  final String? imageUrl;
  final String? groupImage;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
    this.imageUrl,
    this.groupImage,
  });

  // Helper constructor for text messages
  Message.text({
    required String id,
    required String senderId,
    required String senderName,
    required String text,
    required DateTime timestamp,
    MessageStatus status = MessageStatus.sent,
  }) : this(
    id: id,
    senderId: senderId,
    senderName: senderName,
    text: text,
    timestamp: timestamp,
    status: status,
    type: MessageType.text,
  );

  // Helper constructor for image messages
  Message.image({
    required String id,
    required String senderId,
    required String senderName,
    required DateTime timestamp,
    MessageStatus status = MessageStatus.sent,
    required String imageUrl,
  }) : this(
    id: id,
    senderId: senderId,
    senderName: senderName,
    text: '',
    timestamp: timestamp,
    status: status,
    type: MessageType.image,
    imageUrl: imageUrl,
  );

  // Helper constructor for system messages
  Message.system({
    required String id,
    required String text,
    required DateTime timestamp,
  }) : this(
    id: id,
    senderId: 'system',
    senderName: 'System',
    text: text,
    timestamp: timestamp,
    status: MessageStatus.read,
    type: MessageType.system,
  );

  // Check if message is sent by current user
  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }

  // Format timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Format full timestamp
  String get fullFormattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    final year = timestamp.year.toString();
    return '$day/$month/$year $hour:$minute';
  }

  // Create a copy with updated status
  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? text,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
    String? imageUrl,
    String? groupImage,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      groupImage: groupImage ?? this.groupImage,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, text: $text, status: $status, type: $type)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Create a copy for safe modifications
  Message copy() {
    return Message(
      id: id,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: timestamp,
      status: status,
      type: type,
      imageUrl: imageUrl,
      groupImage: groupImage,
    );
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
}

enum MessageType {
  text,
  image,
  system,
}