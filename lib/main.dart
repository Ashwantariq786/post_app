import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:post_app/services/post_repository.dart';

import 'bloc/post_bloc.dart';
import 'bloc/post_event.dart';
import 'bloc/post_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => PostBloc(PostRepository()),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(FetchPosts());

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter BLoC API Demo')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return RefreshIndicator(
              onRefresh: () async => postBloc.add(FetchPosts()),
              child: ListView.builder(
                itemCount: state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.posts.length) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  } else if (state.posts.length % 10 == 0) {
                    postBloc.add(LoadMorePosts());
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          } else if (state is PostError) {
            return const Center(child: Text('Failed to load posts.'));
          } else {
            return const Center(child: Text('No data.'));
          }
        },
      ),
    );
  }
}
