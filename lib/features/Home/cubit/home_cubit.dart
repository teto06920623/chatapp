import 'package:bloc/bloc.dart';
import 'package:chat_app_ui/features/Home/models/comment_model.dart';
import 'package:chat_app_ui/features/Home/models/post_model.dart';
import 'package:chat_app_ui/features/Home/models/story_model.dart';
import 'package:chat_app_ui/features/Home/notifications/cubit/notifications_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PostModel> _posts = [];
  List<StoryModel> _stories = [];

  // دالة لجلب البيانات دفعة واحدة (Posts & Stories) بالـ Real-time
  void loadHomeData() {
    emit(HomeLoading());
    try {
      // استماع للبوستات
      _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        _posts =
            snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
        emit(HomeLoaded(posts: _posts, stories: _stories));
      });

      // استماع للستوريز
      _firestore
          .collection('stories')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        _stories = snapshot.docs
            .map((doc) => StoryModel.fromJson(doc.data()))
            .toList();
        emit(HomeLoaded(posts: _posts, stories: _stories));
      });
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

// داخل ملف lib/features/Home/cubit/home_cubit.dart

// 1. تأكد من وضع API Key الخاص بـ ImgBB هنا (يمكنك استخدام نفس المفتاح الموجود في ProfileCubit)
  final String imgBbApiKey = dotenv.env['IMGBB_API_KEY'] ?? '';

  Future<void> createPost({required String postText, File? imageFile}) async {
    try {
      String? imageUrl;

      // رفع الصورة إلى ImgBB إذا تم اختيار صورة
      if (imageFile != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.imgbb.com/1/upload?key=$imgBbApiKey'),
        );

        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          // استخراج رابط الصورة من استجابة ImgBB
          imageUrl = jsonResponse['data']['url'];
        } else {
          throw Exception('فشل رفع الصورة إلى ImgBB');
        }
      }

      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // جلب بيانات المستخدم من Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      String userName = currentUser.displayName ?? 'User';
      String? userImage;

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['name'] ?? userName;
        userImage = userData['urlImage'];
      }

      // إنشاء مستند المنشور في Firestore
      DocumentReference postRef = _firestore.collection('posts').doc();
      PostModel post = PostModel(
        postId: postRef.id,
        userId: currentUser.uid,
        userName: userName,
        userImage: userImage,
        postText: postText,
        postImage: imageUrl, // الرابط العائد من ImgBB
        createdAt: DateTime.now(),
      );

      await postRef.set(post.toMap());
    } catch (e) {
      emit(HomeError(message: 'حدث خطأ أثناء نشر المنشور: ${e.toString()}'));
      // إعادة تحميل البيانات لضمان استقرار الواجهة
      loadHomeData();
    }
  }

  // إضافة ستوري جديدة في الخلفية بدون تغيير حالة الشاشة العامة
  Future<void> createStory({String? mediaUrl, String? storyText}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      String userName = currentUser.displayName ?? 'User';
      String? userImage;

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['name'] ?? userName;
        userImage = userData['urlImage'];
      }

      DocumentReference storyRef = _firestore.collection('stories').doc();
      StoryModel story = StoryModel(
        storyId: storyRef.id,
        userId: currentUser.uid,
        userName: userName,
        userImage: userImage,
        mediaUrl: mediaUrl,
        storyText: storyText,
        createdAt: DateTime.now(),
      );

      await storyRef.set(story.toMap());
      // الستريم سيتكفل بتحديث واجهة المستخدم فوراً تلقائياً
    } catch (e) {
      // التعامل مع الخطأ
    }
  }

// حذف بوست من فايربيس
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      // الستريم سيقوم بتحديث واجهة المستخدم فوراً تلقائياً
    } catch (e) {
      // التعامل مع الخطأ بصمت أو حسب الرغبة
    }
  }

  // حذف ستوري من فايربيس
  Future<void> deleteStory(String storyId) async {
    try {
      await _firestore.collection('stories').doc(storyId).delete();
      // الستريم سيقوم بتحديث واجهة المستخدم فوراً تلقائياً
    } catch (e) {
      // التعامل مع الخطأ
    }
  }

// داخل HomeCubit في lib/features/Home/cubit/home_cubit.dart

// 1. دالة إضافة/إلغاء الإعجاب
  Future<void> toggleLike({
    required String postId,
    required List<String> currentLikes,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      String uId = currentUser.uid;
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      if (currentLikes.contains(uId)) {
        // 1. إلغاء الإعجاب
        await postRef.update({
          'likes': FieldValue.arrayRemove([uId]),
        });
      } else {
        // 2. إضافة الإعجاب
        await postRef.update({
          'likes': FieldValue.arrayUnion([uId]),
        });

        // 3. إرسال إشعار لصاحب المنشور فقط في حالة الإضافة
        final postDoc = await postRef.get();
        if (postDoc.exists) {
          final postOwnerId = postDoc.data() is Map
              ? (postDoc.data() as Map<String, dynamic>)['userId']
              : null;

          if (postOwnerId != null && postOwnerId != uId) {
            await NotificationsCubit.sendNotification(
              receiverId: postOwnerId,
              title: 'إعجاب جديد',
              body: 'قام بالإعجاب بمنشورك',
              type: 'like',
              targetId: postId,
            );
          }
        }
      }
    } catch (e) {
      // Handling error
    }
  }

// 2. دالة إضافة تعليق جديد
  Future<void> addComment(
      {required String postId, required String commentText}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null || commentText.trim().isEmpty) return;

      // جلب بيانات المستخدم لربطها بالتعليق
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      String userName = currentUser.displayName ?? 'User';
      String? userImage;

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['name'] ?? userName;
        userImage = userData['urlImage'];
      }

      DocumentReference commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      CommentModel comment = CommentModel(
        commentId: commentRef.id,
        userId: currentUser.uid,
        userName: userName,
        userImage: userImage,
        commentText: commentText.trim(),
        createdAt: DateTime.now(),
      );

      await commentRef.set(comment.toMap());
    } catch (e) {
      // التعامل مع الخطأ
    }
  }
}
