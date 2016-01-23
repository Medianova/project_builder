library project_builder.env_info;

import 'dart:io';

class EnvInfo {
  final String _appName = 'builder';
  final String _ds = Platform.isWindows ? '\\' : '/';
  String _rootPath;
  String _currentPath;

  String get ds => _ds;
  String get rootPath => _rootPath;
  String get currentPath => _currentPath;

  EnvInfo() {
    String scriptPath =
        Platform.script.path.toString().replaceAll(_appName, '');

    _rootPath = Platform.isWindows
        ? scriptPath.replaceFirst('/', '').replaceAll('/', _ds)
        : scriptPath;

    _currentPath = Directory.current.absolute.path;
  }
}
