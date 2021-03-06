import 'package:flutter_riverpod/all.dart';
import 'package:pro_flutter/http/api_client.dart';
import 'package:pro_flutter/http/base_dio.dart';
import 'package:pro_flutter/http/base_error.dart';
import 'package:pro_flutter/models/base_model.dart';
import 'package:pro_flutter/models/post_model.dart';
import 'package:pro_flutter/models/single_post_model.dart';
import 'package:pro_flutter/widgets/page_state.dart';
import 'package:sp_util/sp_util.dart';

class PostState {
  final List<Post> posts;
  final int pageIndex;
  final PageState pageState;
  final BaseError error;

  PostState({this.posts, this.pageIndex, this.pageState, this.error});

  PostState.initial()
      : posts = [],
        pageIndex = 1,
        pageState = PageState.initializedState,
        error = null;

  PostState copyWith({
    List<Post> posts,
    int pageIndex,
    bool liked,
    PageState pageState,
    BaseError error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      pageIndex: pageIndex ?? this.pageIndex,
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
    );
  }
}

class PostsViewModel extends StateNotifier<PostState> {
  PostsViewModel([PostState state]) : super(state ?? PostState.initial()) {
    getPosts();
  }

  Future<void> clickLike(int postId, int index) async {
    try {
      BaseModel data = await ApiClient().like(postId);
      if (data.message == 'success') {
        SinglePostModel postModel = await ApiClient().getPostsById(postId, notView: true);
        state.posts.setRange(index, index + 1, [postModel.data]);
        state = state.copyWith(posts: [...state.posts]);
      }
    } catch (e) {
      state = state.copyWith(
          pageState: PageState.errorState,
          error: BaseDio.getInstance().getDioError(e));
    }
  }

  Future<void> getPosts({bool isRefresh = false}) async {
    await SpUtil.getInstance();
    if (state.pageState == PageState.initializedState) {
      state = state.copyWith(pageState: PageState.busyState);
    }
    try {
      if (isRefresh) {
        PostModel postModel = await ApiClient().getPosts('1', '10');
        state = state.copyWith(
          posts: [...postModel.data.posts],
          pageState: PageState.refreshState,
          pageIndex: 1,
        );
      } else {
        PostModel postModel =
            await ApiClient().getPosts(state.pageIndex.toString(), '10');
        state = state.copyWith(
            posts: [...state.posts, ...postModel.data.posts],
            pageIndex: state.pageIndex + 1,
            pageState: PageState.dataFetchState);
        if (postModel.data.posts.isEmpty || postModel.data.posts.length < 10) {
          state = state.copyWith(pageState: PageState.noMoreDataState);
        }
      }
    } catch (e) {
      state = state.copyWith(
          pageState: PageState.errorState,
          error: BaseDio.getInstance().getDioError(e));
    }
  }
}
