// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Utility library to host helper classes.
library project_builder.utils;

import 'dart:io';

import 'env_info.dart';
import 'exceptions.dart';

/// Helper utility class.
class Utils {
  /// Gives access to routes.
  static final EnvInfo envInfo = new EnvInfo();

  /// Copies [entity] file or folder to destination path [dstProjectRootPath]
  /// and writes what is being copies if [verbose] is set to true.
  static void copyFileEntity(FileSystemEntity entity, String srcProjectRootPath,
      String dstProjectRootPath, bool verbose) {
    // resolve entity name with relative path
    String entityName = entity.path.replaceFirst(srcProjectRootPath, '');

    // output what is being copied
    if (verbose) {
      print('> ' + dstProjectRootPath + entityName);
    }

    // copy and throw [CreateResourceException] if error occurres
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

  /// Create directory defined with [path] and show info if [verbose] is true.
  static void createDirectory(String path, bool verbose) {
    try {
      new Directory(path).createSync();
    } catch (e) {
      throw new CreateResourceException(
          path + ((verbose) ? ': ' + e.toString() : ''));
    }
  }

  /// Create file defined with [path] and write [content] to it.
  /// If [verbose] is true display what is being created.
  static void createFile(String path, String content, bool verbose) {
    try {
      new File(path).writeAsStringSync(content);
    } catch (e) {
      throw new CreateResourceException(
          path + ((verbose) ? ': ' + e.toString() : ''));
    }
  }
}
