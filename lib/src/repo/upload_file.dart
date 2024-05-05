import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFileClient {
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadFile(File file) async {
    final ref = storageRef.child('uploads/${file.path}');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadFileByPath(String pathOfFile, String path) async {
    final file = File(pathOfFile);
    final ref = storageRef.child('uploads/$path');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Future<String> uploadFileByBytes(List<int> bytes, String path) async {
  //   final ref = storageRef.child('uploads/$path');
  //   await ref.putData(bytes);
  //   return await ref.getDownloadURL();
  // }

  // Future<String> uploadFileByStream(Stream<List<int>> stream, String path) async {
  //   final ref = storageRef.child('uploads/$path');
  //   await ref.putData(stream);
  //   return await ref.getDownloadURL();
  // }

  Future<void> deleteFile(String path) async {
    final ref = storageRef.child('uploads/$path');
    await ref.delete();
  }
}
