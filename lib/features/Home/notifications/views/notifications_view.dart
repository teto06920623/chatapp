// ignore_for_file: deprecated_member_use

import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => NotificationsCubit()..fetchNotifications(),
      child: Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.grey[100],
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text('لا توجد إشعارات حالياً'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notif = state.notifications[index];

                  return Container(
                    color: notif.isRead
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.08),
                    child: ListTile(
                      onTap: () {
                        context.read<NotificationsCubit>().markAsRead(notif.id);

                        // التوجيه للشات لو الإشعار رسالة
                        if (notif.type == 'chat') {
                          Navigator.pushNamed(
                            context,
                            ChatBubbleView.routeName,
                            arguments: UserModel(
                              uid: notif.senderId,
                              name: notif.senderName,
                              email: '',
                              password: '',
                              urlImage: notif.senderImage,
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: (notif.senderImage != null &&
                                notif.senderImage!.isNotEmpty)
                            ? NetworkImage(notif.senderImage!)
                            : null,
                        child: (notif.senderImage == null ||
                                notif.senderImage!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      title: Text(
                        notif.senderName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notif.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatTime(notif.createdAt),
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is NotificationsError) {
              return Center(child: Text('خطأ: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
