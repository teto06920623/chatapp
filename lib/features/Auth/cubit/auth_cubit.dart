// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, await_only_futures, non_constant_identifier_names, unnecessary_null_comparison, strict_top_level_inference, depend_on_referenced_packages, unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:chat_app_ui/core/service/cache_helper.dart';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> saveDeviceToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': token});
      }
    }
  }

  Future<void> saveUserData(UserModel usermodel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(usermodel.uid)
        .set(usermodel.tomap());
  }

  registerUser(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user == null) {
        emit(AuthError(error: 'User registration failed'));
      } else {
        final UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          password: password,
          urlImage: null,
        );
        await user.updateDisplayName(name);
        await user.sendEmailVerification();
        await saveUserData(userModel);
        await CacheHelper.saveUserData(userModel,
            'User'); //دي البتاخد الكاش محليا لحظه التسجيل عشان ما يطرش يسجل تاني
        emit(AuthSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(error: handelEorror(e.code)));
    } catch (e) {
      emit(AuthError(error: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  String handelEorror(String error) {
    if (error.contains('invalid-email')) {
      return 'Email is invalid';
    } else if (error.contains('user-disabled')) {
      return 'User is disabled';
    } else if (error.contains('user-not-found')) {
      return 'User not found';
    } else if (error.contains('wrong-password')) {
      return 'Wrong password';
    } else if (error.contains('email-already-in-use')) {
      return 'Email already in use';
    } else if (error.contains('operation-not-allowed')) {
      return 'Operation not allowed';
    } else if (error.contains('weak-password')) {
      return 'Weak password';
    } else {
      return 'An undefined Error happened.';
    }
  }

  loginUser({required String email, required String password}) async {
    emit(AuthLoading());
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    try {
      if (user == null) {
        emit(AuthError(error: 'User login failed'));
      } else {
        user.reload();
        final User? current = FirebaseAuth.instance.currentUser;
        if (!current!.emailVerified) {
          emit((AuthEmailNotVerificationSent()));
          return;
        }
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          emit(AuthError(error: ''));
          return;
        }
        if (userDoc.data() == null) {
          emit(AuthError(error: ''));
          return;
        }
        UserModel userModel = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>,
        );

        await CacheHelper.saveUserData(userModel, 'User');
        emit(AuthSuccess(user: current));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(error: handelEorror(e.code)));
    }
  }
// داخل AuthCubit في lib/features/Auth/cubit/auth_cubit.dart

  Future<UserModel> getUserorCreate(User? user) async {
    if (user == null) throw Exception('المستخدم غير موجود');

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final DocumentSnapshot userDoc = await ref.get();

    // 1. إذا كان الحساب مسجلاً من قبل، نجلب بياناته
    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    }

    // 2. إذا لم يكن مسجلاً، ننشئ حساماً جديداً ونحفظه في Firestore
    UserModel userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ??
          (user.email != null ? user.email!.split('@')[0] : 'Google User'),
      password: '',
      urlImage: user.photoURL, // حفظ صورة حساب جوجل
    );

    await ref.set(userModel.tomap());
    return userModel;
  }

  bool isGoogleInit = false;
  initGoogle() async {
    if (isGoogleInit) {
      GoogleSignIn.instance.initialize();
      isGoogleInit = true;
    }
  }

  final String webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  Future<void> LoginWithGoogle() async {
    emit(AuthLoading());
    try {
      // 1. تهيئة GoogleSignIn وتمرير serverClientId في الإصدار الحديث
      await GoogleSignIn.instance.initialize(
        serverClientId: webClientId,
      );

      // 2. تفريغ الجلسة السابقة لإظهار قائمة اختيار الحسابات (Account Picker) دائماً
      await GoogleSignIn.instance.signOut();

      // 3. طلب تسجيل الدخول (استخدام authenticate بدلاً من signIn)
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        emit(AuthError(error: 'تم إلغاء عملية تسجيل الدخول.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. إنشاء كود الاعتماد لـ Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        emit(AuthError(error: 'فشل تسجيل الدخول بواسطة جوجل'));
        return;
      }

      final UserModel userModel = await getUserorCreate(user);
      await CacheHelper.saveUserData(userModel, 'User');

      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(error: 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}'));
    }
  }

// دالة تسجيل الخروج المتوافقة مع الإصدار الحديث
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      // معالجة الأخطاء
    }
  }
}
