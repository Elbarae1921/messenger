import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:messenger/models/post.dart';
import 'package:messenger/modules/splash_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:messenger/utils/assets.dart';
import 'package:messenger/utils/services/graphql.dart';
import 'package:messenger/utils/services/shared_preferences.dart';
import 'package:messenger/widgets/text_form_field_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static final route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _limit = 10;

  final _pagingController = PagingController<int?, Post>(firstPageKey: null);
  final _scrollController = ScrollController();

  Future<void> _newPost() async {
    final result = await showModalBottomSheet<Post?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const NewPostBottomSheet();
      },
    );

    if (result != null && mounted) {
      _pagingController.itemList = [
        result,
        ...(_pagingController.itemList ?? [])
      ];
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (mounted)
          _scrollController.animateTo(
            0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
      });
    }
  }

  Future<void> _onRefresh() async {
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int? cursor) async {
    try {
      final getPosts = await Queries.getPosts(
        cursor: cursor,
        limit: _limit,
      );

      if (!mounted) return;

      if (getPosts.hasMore)
        _pagingController.appendPage(
          getPosts.results,
          getPosts.lastId ?? 0,
        );
      else
        _pagingController.appendLastPage(getPosts.results);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();

    // TODO: add scroll listener to toggle scroll up fab

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messenger')),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        final version = data?.version;
                        final appName = data?.appName;

                        if (snapshot.connectionState == ConnectionState.done)
                          return Column(
                            children: [
                              Text(appName!),
                              Text(
                                version!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          );
                        else
                          return Center(
                            child: SizedBox.fromSize(
                              size: const Size.square(24),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return Text('Hello, ${value.user!.fullName}');
                    },
                  ),
                ],
              ),
            ),
            ListTileTheme(
              iconColor: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: [
                  ListTile(
                    // TODO: add profile
                    title: const Text('Profile'),
                    leading: const Icon(Icons.person),
                    enabled: false,
                  ),
                  ListTile(
                    // TODO: add friends
                    title: const Text('Friends'),
                    leading: const Icon(Icons.people),
                    enabled: false,
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await Prefs.setToken(null);

                      Navigator.of(context)
                          .pushReplacementNamed(SplashPage.route);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Theme.of(context).accentColor,
        child: PostsListView(
          pagingController: _pagingController,
          scrollController: _scrollController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New post',
        onPressed: _newPost,
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class PostsListView extends StatefulWidget {
  const PostsListView({
    Key? key,
    required this.scrollController,
    required this.pagingController,
  }) : super(key: key);

  final ScrollController scrollController;
  final PagingController<int?, Post> pagingController;

  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int?, Post>(
      physics: const BouncingScrollPhysics(),
      scrollController: widget.scrollController,
      pagingController: widget.pagingController,
      padding: const EdgeInsets.only(bottom: 72),
      builderDelegate: PagedChildBuilderDelegate<Post>(
        firstPageProgressIndicatorBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return PostWidget(post: item);
        },
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _liked = false;

  void _like() {
    // TODO: finish the like feature

    setState(() {
      _liked = !_liked;
    });
  }

  @override
  void initState() {
    super.initState();

    // TODO: check if the post has been liked or not
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: post.image != null,
            child: Image.network(post.image ?? ''),
          ),
          ListTile(
            title: Text(post.user.firstName),
            contentPadding: const EdgeInsets.only(left: 16),
            leading: CircleAvatar(
              foregroundImage: Assets.get(Asset.defaultUser),
            ),
            trailing: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: Theme.of(context).primaryIconTheme,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${post.likes} likes',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Like',
                    onPressed: _like,
                    visualDensity: VisualDensity.compact,
                    icon: _liked
                        ? const Icon(Icons.thumb_up)
                        : Icon(
                            Icons.thumb_up_outlined,
                            color: Theme.of(context).disabledColor,
                          ),
                  ),
                  IconButton(
                    tooltip: 'More',
                    icon: const Icon(Icons.more_vert),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      // TODO: more actions menu
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              // TODO: go to user's profile
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Text(post.content),
          ),
        ],
      ),
    );
  }
}

class NewPostBottomSheet extends StatefulWidget {
  const NewPostBottomSheet({Key? key}) : super(key: key);

  @override
  _NewPostBottomSheetState createState() => _NewPostBottomSheetState();
}

class _NewPostBottomSheetState extends State<NewPostBottomSheet> {
  bool _isPrivate = false;

  final _contentFocusNode = FocusNode();
  final _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _newPost() async {
    if (_formKey.currentState?.validate() != true) return;

    final result = await Mutations.createPost(
      content: _contentController.text,
      isPrivate: _isPrivate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: const Text('Post created')),
    );

    Navigator.of(context).pop(result);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 16),
                title: const Text('New post'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Private',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Switch(
                      value: _isPrivate,
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = !_isPrivate;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormFieldTheme(
                    child: TextFormField(
                      maxLines: 5,
                      maxLength: 512,
                      focusNode: _contentFocusNode,
                      controller: _contentController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                      ),
                      validator: (value) {
                        if ((value ?? '').length < 1) return 'Invalid content';
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                  right: 12,
                  bottom: 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Create'),
                        onPressed: _newPost,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
