part of 'watch_cubit.dart';

@immutable
sealed class WatchState {}

final class WatchInitial extends WatchState {}

final class WatchLoading extends WatchState {}

final class WatchLoaded extends WatchState {
  final List<ReelModel> reels;
  WatchLoaded({required this.reels});
}

final class WatchUploading extends WatchState {
  final double progress; // لمتابعة حالة الرفع إذا لزم الأمر
  WatchUploading({this.progress = 0});
}

final class WatchError extends WatchState {
  final String message;
  WatchError({required this.message});
}