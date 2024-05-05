import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sixcomputer/src/widget/bai_tap/bai_7_user_model.dart';

class Bai7 extends StatefulWidget {
  const Bai7({super.key});

  static const String routeName = '/bai-7';

  @override
  State<Bai7> createState() => _Bai7State();
}

class _Bai7State extends State<Bai7> {

  final Dio dio = Dio();
  final List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    fetchApi();
  }


  fetchApi() {
    // https://api.github.com/users
    const url = 'https://api.github.com/users';
    dio.get(url).then((value) {
      final data = value.data as List<dynamic>;
      final users = data.map((e) => UserModel.fromMap(e as Map<String, dynamic>)).toList();

      setState(() {
        this.users.clear();
        this.users.addAll(users);
      });
    }).catchError((error) {
      print("Error: $error");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 7'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.login),
                Text(user.htmlUrl),
              ],
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          );
        },
      ),
    );
  }
}