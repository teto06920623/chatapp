import 'package:chat_app_ui/core/cubit/theme_cubit.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/Auth/views/login_view.dart';
import 'package:chat_app_ui/features/Profile/widgets/container_setting_option.dart';
import 'package:chat_app_ui/features/Profile/widgets/user_info_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    bool isDark = context.select(
      (ThemeCubit cubit) => cubit.state == ThemeMode.dark,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenSize.height / 50,
          left: ScreenSize.width / 20,
          right: ScreenSize.width / 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: ScreenSize.width / 6,
                  backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  ),
                ),
                UserInfoColumnWidget(
                  name: "Mahmoud Mohamed Talal",
                  email: "almasryhouda1234@gmail.com",
                ),
              ],
            ),
            SizedBox(height: ScreenSize.height / 20),
            ContainerSettingOptionWidget(
              text: "Edit Your Profile",
              icon: Icons.edit_road,
              onTap: () {},
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
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginView.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
