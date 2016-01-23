library project_builder.utils;

import 'dart:io';

import 'env_info.dart';
import 'exceptions.dart';

class Utils {
  static final EnvInfo envInfo = new EnvInfo();

  static void copyFileEntity(FileSystemEntity entity, String srcProjectRootPath,
      String dstProjectRootPath, bool verbose) {
    String entityName = entity.path.replaceFirst(srcProjectRootPath, '');

    if (verbose) {
      print('> ' + dstProjectRootPath + entityName);
    }

    if (entity is Directory) {
      try {
        new Directory(dstProjectRootPath + entityName).createSync();
      } catch (e) {
        throw new CreateResourceException(dstProjectRootPath +
            entityName +
            ((verbose) ? ': ' + e.toString() : ''));
      }
    } else if (entity is File) {
      try {
        new File(entity.path).copySync(dstProjectRootPath + entityName);
      } catch (e) {
        throw new CreateResourceException(dstProjectRootPath +
            entityName +
            ((verbose) ? ': ' + e.toString() : ''));
      }
    }
  }

  static void createDirectory(String path, bool verbose) {
    try {
      new Directory(path).createSync();
    } catch (e) {
      throw new CreateResourceException(
          path + ((verbose) ? ': ' + e.toString() : ''));
    }
  }

  static void createFile(String path, String content, bool verbose) {
    try {
      new File(path).writeAsStringSync(content);
    } catch (e) {
      throw new CreateResourceException(
          path + ((verbose) ? ': ' + e.toString() : ''));
    }
  }
}
