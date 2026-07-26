import 'package:chat_app_ui/features/Home/watch/cubit/watch_cubit.dart';
import 'package:chat_app_ui/features/Home/watch/models/reel_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class ReelPlayerItem extends StatefulWidget {
  final ReelModel reel;
  const ReelPlayerItem({super.key, required this.reel});

  @override
  State<ReelPlayerItem> createState() => _ReelPlayerItemState();
}

class _ReelPlayerItemState extends State<ReelPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
          ..initialize().then((_) {
            setState(() {
              _isInitialized = true;
            });
            _controller.setLooping(true);
            _controller.play();
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final bool isLiked = widget.reel.likes.contains(currentUserId);

    return Stack(
      fit: StackFit.expand,
      children: [
        // مشغل الفيديو
        _isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

        // تدرج لوني خلف النصوص والأزرار للوضوح
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // الأزرار الجانبية (إعجاب، حذف، مشاركة)
        Positioned(
          right: 16,
          bottom: 40,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  context.read<WatchCubit>().toggleLike(
                        widget.reel.reelId,
                        widget.reel.likes,
                      );
                },
              ),
              Text(
                '${widget.reel.likes.length}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (widget.reel.userId == currentUserId)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white, size: 28),
                  onPressed: () {
                    context.read<WatchCubit>().deleteReel(widget.reel.reelId);
                  },
                ),
            ],
          ),
        ),

        // تفاصيل المقطع (اسم المستخدم، الصورة، الوصف)
        Positioned(
          left: 16,
          bottom: 30,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: (widget.reel.userImage != null &&
                            widget.reel.userImage!.isNotEmpty)
                        ? NetworkImage(widget.reel.userImage!)
                        : null,
                    child: (widget.reel.userImage == null ||
                            widget.reel.userImage!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.reel.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.reel.caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
