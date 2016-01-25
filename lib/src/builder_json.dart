// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library project_builder.builder_json;

import 'dart:io';
import 'dart:convert';

/// Gives access to information stored in builder.json file
class BuilderJson {
  /// Name of builder file
  final String builderFileName = 'builder.json';

  /// Description
  String _description = '';
  /// List of placeholders
  List<String> _placeholders = new List<String>();
  // List of files and directories that need to be renamed
  List<Map<String, String>> _renames = new List<Map<String, String>>();

  String get description => _description;
  List<String> get placeholders => _placeholders;
  List<Map<String, String>> get renames => _renames;

  BuilderJson();

  /// Load builder.json file from given path defined by [directoryPath].
  ///
  /// While loading the json file it maps data from it to local variables for
  /// easier usage.
  ///
  /// Returns true if file is loaded or false if not.
  bool load(String directoryPath) {
    // check if build.json exists
    File builderJsonFile = new File(directoryPath + builderFileName);
    if (!builderJsonFile.existsSync()) {
      return false;
    }

    // load file and map content
    String buildJsonString = builderJsonFile.readAsStringSync();
    Map<String, dynamic> buildJson = JSON.decode(buildJsonString);

    // get description
    if (buildJson['description'] != null) {
      _description = buildJson['description'].toString();
    }

    // build placeholders list and add name by default
    _placeholders.add('name');
    if (buildJson['placeholders'] != null &&
        buildJson['placeholders'].length > 0) {
      _placeholders.addAll(buildJson['placeholders']);
    }

    // set list of files and folders that need to be renamed
    if (buildJson['rename'] != null && buildJson['rename'].length > 0) {
      _renames = buildJson['rename'];
    }

    // finally return true
    return true;
  }

  /// Check if list of placeholders [pHolder] contains all the placeholders
  /// defined by builder.json file.
  ///
  /// Return true on match, false otherwise.
  bool validatePlaceholders(List<Map<String, String>> pHolder) {
    int matches = 0;

    // early check if we have the same number
    if (pHolder.length != _placeholders.length) {
      return false;
    }

    // now check each key
    for (int i = 0; i < _placeholders.length; i++) {
      for (int j = 0; j < pHolder.length; j++) {
        if (pHolder[j][_placeholders[i]] != null) {
          matches++;
          break;
        }
      }
    }

    // matches found has to be the same as number of placeholders
    return matches == pHolder.length;
  }

  /// Rename file or folder defined by [name] with value from list of
  /// placeholders [pHolders].
  String rename(String name, List<Map<String, String>> pHolders) {
    for (int i = 0; i < _renames.length; i++) {
      if (_renames[i]['from'] == name) {
        return replace(_renames[i]['to'], pHolders);
      }
    }

    return name;
  }

  /// Replace [content] wiht values from list of placeholders [pHolders].
  String replace(String content, List<Map<String, String>> pHolders) {
    for (int i = 0; i < _placeholders.length; i++) {
      for (int j = 0; j < pHolders.length; j++) {
        if (pHolders[j][_placeholders[i]] != null) {
          content = content.replaceAll(
              r'{!' + _placeholders[i] + '!}', pHolders[j][_placeholders[i]]);
          break;
        }
      }
    }

    return content;
  }
}
