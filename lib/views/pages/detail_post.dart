import 'package:flutter/material.dart';
import 'package:lat_uas/models/post.dart';
import 'package:lat_uas/services/api_servie.dart';

class DetailPost extends StatelessWidget {
  const DetailPost({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    final ApiServie _api = ApiServie();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Detail Post")),
        body: Center(
          child: FutureBuilder<Post>(
            future: _api.fetchPostById(postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final post =
                  snapshot.data ?? Post(id: 0, userId: 0, title: "", body: "");
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        post.body,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
