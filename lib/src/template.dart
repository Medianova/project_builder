// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Template library.
library project_builder.template;

import 'dart:io';

import 'builder_json.dart';
import 'exceptions.dart';
import 'env_info.dart';
import 'utils.dart';

/// Template class to describe template and to give basic functionality like
/// copying template to specified folder.
class Template {
  /// Define relative path to templates.
  final String _templatesLocation = 'templates';

  /// Template name.
  String _name;
  /// Template path.
  String _path;
  /// Access information in builder.json file with [BuilderJson] class.
  BuilderJson builderJson;
  /// Dirrectory of this [Template]
  Directory _directory;
  /// Flag to indicate if this [Template] is loaded or not
  bool _loaded = false;
  /// Gives access to routes with [EnvInfo] class.
  final EnvInfo envInfo = new EnvInfo();

  /// Returns name of this [Template]
  String get name => _name;
  /// Returns path of this [Template]
  String get path => _path;

  /// Basic [Template] constructor
  Template();

  /// Create [Template] from a given [_name].
  Template.fromName(this._name) {
    // construct path from name
    _path = envInfo.rootPath + _templatesLocation + envInfo.ds + _name;
    // normalize path and name
    _normalize();
  }

  /// Create [Template] from a given [_path].
  Template.fromPath(this._path) {
    // construct name from path
    _name = _path.substring(_path.lastIndexOf(envInfo.ds));
    // normalize path and name
    _normalize();
  }

  /// Normalize [_path] and [_name].
  ///
  /// [_path] has to end with directory separator.
  /// [_name] should not have directory separator.
  void _normalize() {
    if (!_path.endsWith(envInfo.ds)) {
      _path += envInfo.ds;
    }
    if (_name.startsWith(envInfo.ds)) {
      _name = _name.substring(1);
    }
  }

  /// Load this [Template],
  ///
  /// Creates this [_directory] and checks if template exists. If it doesn't
  /// exists it will throw [MissingDirectoryException] exception.
  ///
  /// Loads builder.json file with this [BuilderJson]. If it doesn't exist it
  /// will throw [MissingBuilderException] exception.
  ///
  /// Sets flag this [_loaded] to true.
  void load() {
    // name and path needs to be defined
    if (_name == null || _path == null) {
      throw new MissingDirectoryException(_path);
    }

    // normalize path and name
    _normalize();

    // try to open template's directory
    _directory = new Directory(_path);
    if (!_directory.existsSync()) {
      throw new MissingDirectoryException(_path);
    }

    // try to load builder.json file
    builderJson = new BuilderJson();
    if (!builderJson.load(_path)) {
      throw new MissingBuilderException(_path);
    }

    // indicate that template is loaded
    _loaded = true;
  }

  /// Copy template to specified [toPath] location.
  ///
  /// If this [Template] is not [_loaded] throws [NotLoadedException] exception.
  /// If [toPath] already exists, throw [ExistsException] exception.
  /// On copy error [CreateResourceException] will be thrown.
  ///
  /// Disiplay additional information if [verbose] flag set to true.
  void copy(String toPath, {bool verbose: false}) {
    _createNew(toPath, false, null, null, verbose);
  }

  /// Builds project on specified [toPath] location with [projectName] name
  /// and with list of [placeholders].
  ///
  /// If this [Template] is not [_loaded] throws [NotLoadedException] exception.
  /// If [toPath] already exists, throw [ExistsException] exception.
  /// If number of [placeholders] is not the same as number defined in
  /// builder.json throws [MismatchPlaceholdersException] exception.
  /// On copy error [CreateResourceException] will be thrown.
  ///
  /// Disiplay additional information if [verbose] flag set to true.
  void build(String toPath, String projectName, List<String> placeholders,
      {bool verbose: false}) {
    _createNew(toPath, true, projectName, placeholders, verbose);
  }

  /// Creates new template or builds new project in [toPath] location.
  ///
  /// If [build] is true then it will create new project, otherwise it will
  /// create new template.
  /// When creating new project, name of the project will be defined by
  /// [projectName] and placeholders will be replaced with values defined with
  /// [placeholders] list.
  ///
  /// Disiplay additional information if [verbose] flag set to true.
  void _createNew(String toPath, bool build, String projectName,
      List<String> placeholders, bool verbose) {
    // Passed placeholders are passed as variable=value list of strings so we
    // need to map them to list of maps where variable name will be the key and
    // value will be what will replace the placeholder in template.
    // mappedPlaceholders holds this list of key-value placeholders
    List<Map<String, String>> mappedPlaceholders = null;

    // we can only proceed if template is loaded
    if (!_loaded) {
      throw new NotLoadedException(this.toString());
    }

    // normalize toPath value, it has to end with directory separator
    if (!toPath.endsWith(envInfo.ds)) {
      toPath += envInfo.ds;
    }

    // If buildiong new project then add name of the project to path
    // map placeholders and check if we have all the placeholders defined by
    // this template.
    if (build) {
      toPath += projectName + envInfo.ds;
      mappedPlaceholders = _mapPlaceholders(placeholders, projectName);
      if (!builderJson.validatePlaceholders(mappedPlaceholders)) {
        throw new MismatchPlaceholdersException(
            'number of placeholders are diffetent then those defined by template');
      }
    }

    // create new directory where files will be copied
    Directory dstDir = new Directory(toPath);

    if (dstDir.existsSync()) {
      throw new ExistsException(toPath + ' already exists');
    }

    try {
      dstDir.createSync();
    } catch (e) {
      throw new CreateResourceException(e.toString());
    }

    // now copy files and folders from this template
    // and if building new project apply files and folders if needed
    // and apply placeholders
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

  /// Map list of [placeholders] defined as string variable=value to list of
  /// map key: value.
  /// Also add project name to list of placeholders.
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

  /// Return this [Template] as string
  String toString() {
    return _name + ' > ' + builderJson.description;
  }
}
