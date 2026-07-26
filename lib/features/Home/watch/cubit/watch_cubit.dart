import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app_ui/features/Home/watch/models/reel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'watch_state.dart';

class WatchCubit extends Cubit<WatchState> {
  WatchCubit() : super(WatchInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  List<ReelModel> _reels = [];

  // جلب الـ Reels في الوقت الفعلي
  void fetchReels() {
    emit(WatchLoading());
    try {
      _firestore
          .collection('reels')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        _reels =
            snapshot.docs.map((doc) => ReelModel.fromJson(doc.data())).toList();
        emit(WatchLoaded(reels: _reels));
      });
    } catch (e) {
      emit(WatchError(message: 'حدث خطأ أثناء تحميل المقاطع: ${e.toString()}'));
    }
  }

  // رفع الفيديو إلى Cloudinary وحفظ البيانات في Firestore
  Future<void> uploadReel(
      {required File videoFile, required String caption}) async {
    emit(WatchUploading());
    try {
      // 1. رفع مقطع الفيديو إلى Cloudinary API
      Uri uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/video/upload");
      var request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', videoFile.path));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(responseData.body);
        String videoUrl = jsonResult['secure_url'];

        // 2. جلب بيانات المستخدم الحالي
        User? currentUser = _auth.currentUser;
        if (currentUser == null) return;

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        String userName = currentUser.displayName ?? 'User';
        String? userImage;

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          userName = userData['name'] ?? userName;
          userImage = userData['urlImage'];
        }

        // 3. إنشاء وثيقة الـ Reel داخل Firestore
        DocumentReference reelRef = _firestore.collection('reels').doc();
        ReelModel newReel = ReelModel(
          reelId: reelRef.id,
          userId: currentUser.uid,
          userName: userName,
          userImage: userImage,
          videoUrl: videoUrl,
          caption: caption,
          createdAt: DateTime.now(),
        );

        await reelRef.set(newReel.toMap());
        fetchReels();
      } else {
        emit(WatchError(
            message: 'فشل رفع الفيديو إلى السيرفر: ${responseData.body}'));
      }
    } catch (e) {
      emit(WatchError(message: 'حدث خطأ أثناء الرفع: ${e.toString()}'));
    }
  }

  // التفاعل بالإعجاب / إلغاء الإعجاب
  Future<void> toggleLike(String reelId, List<String> currentLikes) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      String uid = currentUser.uid;
      DocumentReference reelRef = _firestore.collection('reels').doc(reelId);

      if (currentLikes.contains(uid)) {
        await reelRef.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await reelRef.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // التعامل مع الخطأ عند الحاجة
    }
  }

  // حذف المقطع
  Future<void> deleteReel(String reelId) async {
    try {
      await _firestore.collection('reels').doc(reelId).delete();
    } catch (e) {
      // التعامل مع الخطأ
    }
  }
}
