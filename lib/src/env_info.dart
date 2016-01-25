// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Get informations about routes
library project_builder.env_info;

import 'dart:io';
import 'dart:async';

/// Environment Information
///
/// Set routes information based on current operating system and location of
/// this project
class EnvInfo {
  static final EnvInfo _instanceObj = new EnvInfo._internal();

  /// Name of executable file
  final String _appName = 'builder.dart';
  // Directory separator
  final String _ds = Platform.pathSeparator;
  // Root path to this application
  String _rootPath;
  // Path from where this project has been called
  String _currentPath;

  String get ds => _ds;
  String get rootPath => _rootPath;
  String get currentPath => _currentPath;

  factory EnvInfo() {
    return _instanceObj;
  }

  EnvInfo._internal() {
    String scriptPath =
        Platform.script.path.toString().replaceAll(_appName, '');

    _rootPath = Platform.isWindows
        ? scriptPath.replaceFirst('/', '').replaceAll('/', _ds)
        : scriptPath;

    _rootPath = _rootPath.substring(0, _rootPath.length - 4);

    _currentPath = Directory.current.absolute.path;
  }
}
