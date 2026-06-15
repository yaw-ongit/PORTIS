// ─── ENUM: ASSISTANT TYPE ───
enum AssistantType { suster, art, rs, pharmacy }

extension AssistantTypeExt on AssistantType {
  String get label {
    switch (this) {
      case AssistantType.suster:
        return 'Suster';
      case AssistantType.art:
        return 'ART';
      case AssistantType.rs:
        return 'RS';
      case AssistantType.pharmacy:
        return 'Apotek';
    }
  }
}

// ─── USER MODEL ───
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
  });

  // Convert to Map untuk Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
    );
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// ─── ASSISTANT MODEL (diperbaiki) ───
class AssistantModel {
  final String id;
  final String name;
  final AssistantType type;
  final double rating;
  final String imagePath;
  final String description;
  final String phoneNumber;
  final String location;
  final String email;
  final int age;
  final int experience; // tahun
  final String education;
  final List<String> certifications;
  final List<String> qualifications;
  final List<String> expertise;

  AssistantModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.imagePath,
    required this.description,
    required this.phoneNumber,
    required this.location,
    required this.email,
    required this.age,
    required this.experience,
    required this.education,
    required this.certifications,
    required this.qualifications,
    required this.expertise,
  });

  // Convert to Map untuk Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.label,
      'rating': rating,
      'imagePath': imagePath,
      'description': description,
      'phoneNumber': phoneNumber,
      'location': location,
      'email': email,
      'age': age,
      'experience': experience,
      'education': education,
      'certifications': certifications,
      'qualifications': qualifications,
      'expertise': expertise,
    };
  }

  // Create from Map
  factory AssistantModel.fromMap(Map<String, dynamic> map) {
    return AssistantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: _parseAssistantType(map['type']),
      rating: (map['rating'] ?? 0).toDouble(),
      imagePath: map['imagePath'] ?? '',
      description: map['description'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      location: map['location'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      experience: map['experience'] ?? 0,
      education: map['education'] ?? '',
      certifications: List<String>.from(map['certifications'] ?? []),
      qualifications: List<String>.from(map['qualifications'] ?? []),
      expertise: List<String>.from(map['expertise'] ?? []),
    );
  }

  static AssistantType _parseAssistantType(String? type) {
    switch (type) {
      case 'Suster':
        return AssistantType.suster;
      case 'ART':
        return AssistantType.art;
      case 'RS':
        return AssistantType.rs;
      case 'Apotek':
        return AssistantType.pharmacy;
      default:
        return AssistantType.suster;
    }
  }
}

// ─── SERVICE MODEL (backward compatible) ───
class ServiceModel {
  final String id;
  final String name;
  final String profession;
  final double rating;
  final String imagePath;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.profession,
    required this.rating,
    required this.imagePath,
  });

  // Untuk backward compatibility
  factory ServiceModel.fromAssistant(AssistantModel assistant) {
    return ServiceModel(
      id: assistant.id,
      name: assistant.name,
      profession: assistant.type.label,
      rating: assistant.rating,
      imagePath: assistant.imagePath,
    );
  }
}

// ─── CHAT MODEL ───
class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String imagePath;
  final int unreadCount;
  final String? userId;
  final String? assistantId;

  const ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imagePath,
    this.unreadCount = 0,
    this.userId,
    this.assistantId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      time: map['time'] ?? '',
      imagePath: map['imagePath'] ?? '',
      unreadCount: map['unreadCount'] is int
          ? map['unreadCount'] as int
          : map['unreadCount'] is String
              ? int.tryParse(map['unreadCount'] as String) ?? 0
              : 0,
      userId: map['userId'],
      assistantId: map['assistantId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'imagePath': imagePath,
      'unreadCount': unreadCount,
      'userId': userId,
      'assistantId': assistantId,
    };
  }

  static String buildChatId(String userId, String assistantId) {
    return '${userId}_$assistantId';
  }
}

class MessageModel {
  final String id;
  final String text;
  final bool isMe;
  final String time;

  const MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// ─── BOOKING MODEL ───
class BookingModel {
  final String id;
  final String userId;
  final String assistantId;
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String scheduleDate; // human readable or ISO
  final String scheduleTime;
  final String status; // pending, confirmed, cancelled, completed
  final String notes;
  final double price;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.assistantId,
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.status,
    required this.notes,
    required this.price,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'assistantId': assistantId,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'address': address,
      'scheduleDate': scheduleDate,
      'scheduleTime': scheduleTime,
      'status': status,
      'notes': notes,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      assistantId: map['assistantId'] ?? '',
      recipientName: map['recipientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      scheduleDate: map['scheduleDate'] ?? '',
      scheduleTime: map['scheduleTime'] ?? '',
      status: map['status'] ?? 'pending',
      notes: map['notes'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

// ─── NOTIFICATION MODEL ───
class NotificationModel {
  final String id;
  final String title;
  final String time;
  final NotifType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.time,
    required this.type,
  });
}

enum NotifType { service, location, payment, chat }

// ─── ACTIVITY MODEL ───
class ActivityModel {
  final String id;
  final String providerName;
  final String profession;
  final String description;
  final String imagePath;
  final String scheduleDate;
  final String scheduleTime;
  final String statusText;
  final String tipText;
  final ActivityStatus status;

  const ActivityModel({
    required this.id,
    required this.providerName,
    required this.profession,
    required this.description,
    required this.imagePath,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.statusText,
    required this.tipText,
    required this.status,
  });
}

enum ActivityStatus { ongoing, inProgress, scheduled }

// ─── CONTOH DATA ───
class AppData {
  static const List<ServiceModel> services = [
    ServiceModel(
      id: '1',
      name: 'Dania',
      profession: 'Perawat Geriatri',
      rating: 4.8,
      imagePath: 'assets/images/dania.jpg',
    ),
    ServiceModel(
      id: '2',
      name: 'Betty',
      profession: 'Asisten Rumah Tangga',
      rating: 4.4,
      imagePath: 'assets/images/betty.jpg',
    ),
    ServiceModel(
      id: '3',
      name: 'Sista',
      profession: 'Perawat Umum',
      rating: 4.7,
      imagePath: 'assets/images/sista.jpg',
    ),
    ServiceModel(
      id: '4',
      name: 'Siti Kumalasari',
      profession: 'Asisten Rumah Tangga',
      rating: 4.6,
      imagePath: 'assets/images/siti.webp',
    ),
  ];

  static const List<ChatModel> chats = [
    ChatModel(
      id: '1',
      name: 'Yuni',
      lastMessage: "Saya ingin membatalkan pesanan!",
      time: '10:25',
      imagePath: 'assets/images/yuni.png',
      unreadCount: 0,
    ),
    ChatModel(
      id: '2',
      name: 'Jayadi',
      lastMessage: 'Terimakasih',
      time: '22:20',
      imagePath: 'assets/images/jayadi.png',
      unreadCount: 1,
    ),
  ];

  static final Map<String, List<MessageModel>> chatMessages = {
    '1': [
      const MessageModel(
        id: '1-1',
        text: 'Selamat Siang! ada yang bisa saya bantu?',
        isMe: false,
        time: '10:20',
      ),
      const MessageModel(
        id: '1-2',
        text: 'Saya ingin membatalkan pesanan!',
        isMe: true,
        time: '10:22',
      ),
      const MessageModel(
        id: '1-3',
        text: 'Baik, saya bantu cek status pemesanan Anda.',
        isMe: false,
        time: '10:24',
      ),
    ],
    '2': [
      const MessageModel(
        id: '2-1',
        text: 'Halo, ada yang bisa saya bantu?',
        isMe: false,
        time: '22:10',
      ),
      const MessageModel(
        id: '2-2',
        text: 'Terimakasih, sudah dibantu.',
        isMe: true,
        time: '22:18',
      ),
    ],
  };

  static const List<NotificationModel> todayNotifs = [
    NotificationModel(
      id: '1',
      title: 'Layanan Suster Ariani Berakhir',
      time: '11.00 AM',
      type: NotifType.service,
    ),
    NotificationModel(
      id: '2',
      title: 'Anda belum mengatur alamat utama',
      time: '08.00 AM',
      type: NotifType.location,
    ),
    NotificationModel(
      id: '3',
      title: 'Pesanan berhasil dibayar',
      time: '01.00 AM',
      type: NotifType.payment,
    ),
  ];

  static const List<NotificationModel> yesterdayNotifs = [
    NotificationModel(
      id: '4',
      title: 'Chat terbaru dari Dr. Indah',
      time: '11.00 AM',
      type: NotifType.chat,
    ),
    NotificationModel(
      id: '5',
      title: 'Chat terbaru dari Dr. Indah',
      time: '11.00 AM',
      type: NotifType.chat,
    ),
    NotificationModel(
      id: '6',
      title: 'Berhasil menambahkan alamat baru !',
      time: '08.00 AM',
      type: NotifType.location,
    ),
  ];

  static const List<ActivityModel> ongoingActivities = [
    ActivityModel(
      id: '1',
      providerName: 'Yuni',
      profession: 'Suster',
      description: 'Layanan berlangsung hingga 17.00',
      imagePath: 'assets/images/yuni.png',
      scheduleDate: 'Selasa, 28 Mei 2025',
      scheduleTime: '09.00 - 12.00 WIB',
      statusText: 'Dalam Penugasan',
      tipText:
          'Mendengarkan cerita masa lalu dapat membantu menjaga kesehatan memori lansia',
      status: ActivityStatus.ongoing,
    ),
  ];
}
