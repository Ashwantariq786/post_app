import 'package:equatable/equatable.dart';

import '../models/post.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {}
