import 'package:bloc/bloc.dart';

import '../models/post.dart';
import '../services/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  final int _postsPerPage = 10; // Number of posts to fetch per page
  int _currentPage = 1; // Current page of posts

  PostBloc(this._postRepository) : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPosts) {
      yield* _mapFetchPostsToState();
    } else if (event is LoadMorePosts) {
      yield* _mapLoadMorePostsToState();
    }
  }

  Stream<PostState> _mapFetchPostsToState() async* {
    _currentPage = 1; // Reset the current page when fetching posts
    yield PostLoading();
    try {
      final posts = await _postRepository.getPosts(_currentPage, _postsPerPage);
      yield PostLoaded(posts);
    } catch (e) {
      yield PostError();
    }
  }

  Stream<PostState> _mapLoadMorePostsToState() async* {
    if (state is PostLoaded) {
      try {
        _currentPage++;
        final List<Post> currentPosts = (state as PostLoaded).posts;
        final newPosts =
            await _postRepository.getPosts(_currentPage, _postsPerPage);
        final updatedPosts = [...currentPosts, ...newPosts];
        yield PostLoaded(updatedPosts);
      } catch (e) {
        _currentPage--; // Revert back to the previous page on error
      }
    }
  }
}
