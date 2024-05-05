// "login": "mojombo",
//     "id": 1,
//     "node_id": "MDQ6VXNlcjE=",
//     "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
//     "gravatar_id": "",
//     "url": "https://api.github.com/users/mojombo",
//     "html_url": "https://github.com/mojombo",
//     "followers_url": "https://api.github.com/users/mojombo/followers",
//     "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
//     "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
//     "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
//     "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
//     "organizations_url": "https://api.github.com/users/mojombo/orgs",
//     "repos_url": "https://api.github.com/users/mojombo/repos",
//     "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
//     "received_events_url": "https://api.github.com/users/mojombo/received_events",
//     "type": "User",
//     "site_admin": false

class UserModel {
  UserModel({
    this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  String? id;
  String login;
  String avatarUrl;
  String htmlUrl;

  set setId(String id) {
    this.id = id;
  }

  toJson() {
    return {
      'login': login,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
    };
  }

  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      login: data['login'],
      avatarUrl: data['avatar_url'],
      htmlUrl: data['html_url'],
    );
  }
}