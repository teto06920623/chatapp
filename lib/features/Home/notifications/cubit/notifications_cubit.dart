import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../models/notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. الاستماع لإشعارات المستخدم الحالي Real-time
  void fetchNotifications() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    emit(NotificationsLoading());

    _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
      emit(NotificationsLoaded(notifications: notifications));
    }, onError: (e) {
      emit(NotificationsError(message: e.toString()));
    });
  }

  // 2. دالة عامة لإرسال إشعار لأي مستخدم (تُستدعى عند الشات أو اللايك)
  static Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    String? targetId,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid == receiverId) return;

    // جلب بيانات الحساب الحالي (المرسل)
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    String senderName = currentUser.displayName ?? 'مستخدم';
    String? senderImage;

    if (userDoc.exists && userDoc.data() != null) {
      senderName = userDoc.data()!['name'] ?? senderName;
      senderImage = userDoc.data()!['urlImage'];
    }

    final docRef = FirebaseFirestore.instance.collection('notifications').doc();

    final notification = NotificationModel(
      id: docRef.id,
      senderId: currentUser.uid,
      senderName: senderName,
      senderImage: senderImage,
      receiverId: receiverId,
      title: title,
      body: body,
      type: type,
      targetId: targetId,
      createdAt: DateTime.now(),
    );

    await docRef.set(notification.toMap());
  }

  // 3. تحديد الإشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (_) {}
  }
}
