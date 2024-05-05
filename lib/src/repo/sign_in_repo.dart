
import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/admin_model.dart';

class SignInClient {

  DatabaseReference ref = FirebaseDatabase.instance.ref('Admin');

  Future<bool> signIn(AdminModel login) async {
    final admin = await ref.once();
    bool isSignedIn = false;

    if (admin.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(admin.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        if (value['username'] == login.username && value['password'] == login.password) {
          isSignedIn = true;

          return;
        }
      });
    }
    return isSignedIn;
  }
}