// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String imgBbApiKey = dotenv.env['IMGBB_API_KEY'] ?? '';// استبدل هذا بـ API Key الخاص بك من ImgBB

  // جلب بيانات المستخدم الحالي
  Future<void> getUserProfile() async {
    emit(ProfileLoading());
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        emit(ProfileError(message: 'User not authenticated'));
        return;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        emit(ProfileLoaded(
          name: data['name'] ?? 'User',
          email: data['email'] ?? user.email ?? '',
          imageUrl: data['urlImage'],
        ));
      } else {
        emit(ProfileLoaded(
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          imageUrl: user.photoURL,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // اختيار صورة من المعرض ورفعها لـ ImgBB ثم تحديثها في Firestore
// اختيار صورة (من المعرض أو الكاميرا) ورفعها لـ ImgBB ثم تحديثها في Firestore
  Future<void> updateProfileImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    emit(ProfileUpdating());
    try {
      File imageFile = File(image.path);

      // 1. رفع الصورة إلى ImgBB API
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$imgBbApiKey'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String downloadUrl = jsonResponse['data']['url'];

        // 2. تحديث الرابط في Firestore تحت جدول users
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).update({
            'urlImage': downloadUrl,
          });
        }

        getUserProfile();
      } else {
        emit(ProfileError(message: 'فشل رفع الصورة على السيرفر'));
        getUserProfile();
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      getUserProfile();
    }
  }
}
