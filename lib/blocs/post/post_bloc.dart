import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';

class PostState {
  final List<Map<String, dynamic>> posts;
  PostState({required this.posts});
}

class PostEvent {}

class AddPostEvent extends PostEvent {
  final String message, username;
  AddPostEvent(this.message, this.username);
}

class FetchPostsEvent extends PostEvent {}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc(this.postRepository) : super(PostState(posts: [])) {
    on<AddPostEvent>((event, _) async {
      await postRepository.addPost(event.message, event.username);
    });

    on<FetchPostsEvent>((_, emit) async {
      postRepository.getPosts().listen((posts) {
        emit(PostState(posts: posts));
      });
    });
  }
}
