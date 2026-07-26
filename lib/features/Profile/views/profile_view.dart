import 'package:chat_app_ui/core/cubit/theme_cubit.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/cubit/auth_cubit.dart';
import 'package:chat_app_ui/features/auth/views/login_view.dart';
import 'package:chat_app_ui/features/Profile/cubit/profile_cubit.dart';
import 'package:chat_app_ui/features/Profile/widgets/container_setting_option.dart';
import 'package:chat_app_ui/features/Profile/widgets/user_info_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من استيراد هذه الحزمة

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUserProfile(),
      child: const ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  // دالة إظهار قائمة اختيار مصدر الصورة
  void _showImageSourceBottomSheet(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.photo_library, color: Colors.purple),
                  title: const Text('اختر من المعرض'),
                  onTap: () {
                    Navigator.pop(context);
                    profileCubit.updateProfileImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.purple),
                  title: const Text('التقاط صورة بالكاميرا'),
                  onTap: () {
                    Navigator.pop(context);
                    profileCubit.updateProfileImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.select(
      (ThemeCubit cubit) => cubit.state == ThemeMode.dark,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          String name = 'User';
          String email = '';
          String? imageUrl;

          if (state is ProfileLoaded) {
            name = state.name;
            email = state.email;
            imageUrl = state.imageUrl;
          }

          return Padding(
            padding: EdgeInsets.only(
              top: ScreenSize.height / 50,
              left: ScreenSize.width / 20,
              right: ScreenSize.width / 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: ScreenSize.width / 6,
                            backgroundImage:
                                imageUrl != null && imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : const NetworkImage(
                                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                                      ),
                          ),
                          if (state is ProfileUpdating)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      UserInfoColumnWidget(
                        name: name,
                        email: email,
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.height / 20),
                  ContainerSettingOptionWidget(
                    text: "Change Profile Picture",
                    icon: Icons.camera_alt,
                    onTap: () {
                      _showImageSourceBottomSheet(context);
                    },
                  ),
                  SizedBox(height: ScreenSize.height / 20),
                  ContainerSettingOptionWidget(
                    text: "Change Your Password",
                    icon: Icons.password,
                    onTap: () {},
                  ),
                  SizedBox(height: ScreenSize.height / 20),
                  ContainerSettingOptionWidget(
                    text: "Theme Mode",
                    icon: isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    onTap: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                  SizedBox(height: ScreenSize.height / 20),
                  ContainerSettingOptionWidget(
                    text: "Log Out",
                    icon: Icons.logout_rounded,
                    onTap: () async {
                      // تسجيل الخروج الفعلي ومسح حساب جوجل و الفايربيس
                      await context.read<AuthCubit>().logOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                            context, LoginView.routeName);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
