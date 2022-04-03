import 'dart:io';


import 'package:path_provider/path_provider.dart';

class Cache {
  Cache(this.fileName);
  String fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }
  Future<File> write(String data) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(data);
  }
  // returns null if no file found
  Future<String?> read() async {
    try {
      final file = await _localFile;

      final exists = await file.exists();
      if (!exists) return null;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
  Future<bool> delete() async {
    try {
      final file = await _localFile;

      await file.delete();
      return true;

    } catch (e) {
      return false;
    }
  }
}