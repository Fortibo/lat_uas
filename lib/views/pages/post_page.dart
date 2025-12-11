import 'package:flutter/material.dart';
import 'package:lat_uas/models/post.dart';
import 'package:lat_uas/services/api_servie.dart';
import 'package:lat_uas/views/pages/detail_post.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key});
  final ApiServie _api = ApiServie();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Post")),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  FutureBuilder<List<Post>>(
                    future: _api.fetchPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final posts = snapshot.data ?? [];

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            title: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailPost(postId: post.id);
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Divider(height: 2),
                        itemCount: posts.length,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
