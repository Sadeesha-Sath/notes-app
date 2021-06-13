import 'dart:io';

extension FileType on FileSystemEntity {
  String get fileType => this.path.split("/").last.split(".").last;
}
