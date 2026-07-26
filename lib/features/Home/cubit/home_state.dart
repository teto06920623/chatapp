part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<PostModel> posts;
  final List<StoryModel> stories;
  HomeLoaded({required this.posts, required this.stories});
}

final class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
