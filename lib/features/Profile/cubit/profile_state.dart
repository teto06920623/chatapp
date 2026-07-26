part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String? imageUrl;

  ProfileLoaded({required this.name, required this.email, this.imageUrl});
}

final class ProfileUpdating extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
