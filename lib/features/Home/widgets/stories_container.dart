import 'package:chat_app_ui/features/Home/models/story_model.dart';
import 'package:flutter/material.dart';

class StoriesContainer extends StatelessWidget {
  const StoriesContainer({
    super.key,
    required this.stories,
    required this.onAddStory,
    required this.onDeleteStory,
  });

  final List<StoryModel> stories;
  final VoidCallback onAddStory;
  final Function(String storyId) onDeleteStory;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 180,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: onAddStory,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? const Color(0xff2A2A2A) : Colors.grey[100],
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'إضافة ستوري',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final story = stories[index - 1];
          bool isTextStory = story.mediaUrl == null || story.mediaUrl!.isEmpty;

          return GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                builder: (context) => SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text(
                          'حذف الحالة',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          onDeleteStory(story.storyId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isTextStory
                    ? (isDark
                        ? const Color(0xff1E3E62)
                        : const Color(0xff1877F2))
                    : null,
                image: !isTextStory
                    ? DecorationImage(
                        image: NetworkImage(story.mediaUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (isTextStory)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          story.storyText ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            isDark ? Colors.grey[800] : Colors.grey[300],
                        backgroundImage: (story.userImage != null &&
                                story.userImage!.isNotEmpty)
                            ? NetworkImage(story.userImage!)
                            : null,
                        child: (story.userImage == null ||
                                story.userImage!.isEmpty)
                            ? const Icon(Icons.person,
                                size: 18, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                      story.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
