import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:messenger/constants/extended_colors.dart';
import 'package:messenger/models/post.dart';
import 'package:messenger/modules/splash_page.dart';
import 'package:messenger/providers/user_provider.dart';
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
  Future<void> _newPost() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const NewPostBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
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
      body: const PostsListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: _newPost,
      ),
    );
  }
}

class PostsListView extends StatefulWidget {
  const PostsListView({Key? key}) : super(key: key);

  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  static const _limit = 10;

  final _pagingController = PagingController<int?, Post>(firstPageKey: null);

  Future<void> _fetchPage(int? cursor) async {
    try {
      final getPosts = await Queries.getPosts(
        cursor: cursor,
        limit: _limit,
      );

      if (getPosts.hasMore)
        _pagingController.appendPage(
          getPosts.results,
          int.parse(getPosts.results.last.id),
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
    return PagedListView<int?, Post>(
      pagingController: _pagingController,
      physics: const BouncingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, item, index) {
          return Text(item.content);
        },
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

  final _formKey = GlobalKey<FormState>();

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
                      decoration: const InputDecoration(
                        labelText: 'Content',
                      ),
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
                        onPressed: () {
                          // TODO: create post
                        },
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
