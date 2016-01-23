library project_builder.template;

import 'dart:io';

import 'builder_json.dart';
import 'exceptions.dart';
import 'env_info.dart';
import 'utils.dart';

class Template {
  final String _templatesLocation = 'templates';

  String _name;
  String _path;
  BuilderJson builderJson;
  Directory _directory;
  bool _loaded = false;

  final EnvInfo envInfo = new EnvInfo();

  String get name => _name;
  String get path => _path;

  Template();

  Template.fromName(this._name) {
    _path = envInfo.rootPath + _templatesLocation + envInfo.ds + _name;
    _normalize();
  }

  Template.fromPath(this._path) {
    _name = _path.substring(_path.lastIndexOf(envInfo.ds));
    _normalize();
  }

  void _normalize() {
    if (!_path.endsWith(envInfo.ds)) {
      _path += envInfo.ds;
    }
    if (_name.startsWith(envInfo.ds)) {
      _name = _name.substring(1);
    }
  }

  void load() {
    if (_name == null || _path == null) {
      throw new MissingDirectoryException(_path);
    }

    _normalize();

    _directory = new Directory(_path);
    if (!_directory.existsSync()) {
      throw new MissingDirectoryException(_path);
    }

    builderJson = new BuilderJson();
    if (!builderJson.load(_path)) {
      throw new MissingBuilderException(_path);
    }

    _loaded = true;
  }

  void copy(String toPath, {bool verbose: false}) {
    _createNew(toPath, false, null, null, verbose);
  }

  void build(String toPath, String projectName, List<String> placeholders,
      {bool verbose: false}) {
    _createNew(toPath, true, projectName, placeholders, verbose);
  }

  void _createNew(String toPath, bool build, String projectName,
      List<String> placeholders, bool verbose) {
    List<Map<String, String>> mappedPlaceholders = null;

    if (!_loaded) {
      throw new NotLoadedException(this.toString());
    }

    if (!toPath.endsWith(envInfo.ds)) {
      toPath += envInfo.ds;
    }

    if (build) {
      toPath += projectName + envInfo.ds;
      mappedPlaceholders = _mapPlaceholders(placeholders, projectName);
      if (!builderJson.validatePlaceholders(mappedPlaceholders)) {
        throw new MismatchPlaceholdersException(
            'number of placeholders are diffetent then those defined by template');
      }
    }

    Directory dstDir = new Directory(toPath);

    if (dstDir.existsSync()) {
      throw new ExistsException(toPath + ' already exists');
    }

    try {
      dstDir.createSync();
    } catch (e) {
      throw new CreateResourceException(e.toString());
    }

    _directory.listSync(recursive: true).forEach((FileSystemEntity entity) {
      if (build == false) {
        Utils.copyFileEntity(entity, _path, toPath, verbose);
      } else {
        String entityName = entity.path.replaceFirst(_path, '');
        String renamed = builderJson.rename(
            entityName.replaceAll('\\', '/'), mappedPlaceholders);
        renamed = renamed.replaceAll('/', envInfo.ds);
        String newPath = toPath + renamed;

        if (entity is Directory) {
          Utils.createDirectory(newPath, verbose);
        } else if (entity is File) {
          String fileContent = new File(entity.path).readAsStringSync();
          fileContent = builderJson.replace(fileContent, mappedPlaceholders);
          Utils.createFile(newPath, fileContent, verbose);
        }
      }
    });
  }

  List<Map<String, String>> _mapPlaceholders(
      List<String> placeholders, String projectName) {
    List<Map<String, String>> ph = new List<Map<String, String>>();

    ph.add({'name': projectName});

    for (int i = 0; i < placeholders.length; i++) {
      List<String> keyValue = placeholders[i].split('=');
      ph.add({keyValue[0]: keyValue[1]});
    }

    return ph;
  }

  String toString() {
    return _name + ' > ' + builderJson.description;
  }
}
