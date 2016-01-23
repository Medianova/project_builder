library project_builder.builder_json;

import 'dart:io';
import 'dart:convert';

class BuilderJson {
  final String builderFileName = 'builder.json';

  String _description = '';
  List<String> _placeholders = new List<String>();
  List<Map<String, String>> _renames = new List<Map<String, String>>();

  String get description => _description;
  List<String> get placeholders => _placeholders;
  List<Map<String, String>> get renames => _renames;

  BuilderJson();

  bool load(String directoryPath) {
    // read build.json
    File builderJsonFile = new File(directoryPath + builderFileName);
    if (!builderJsonFile.existsSync()) {
      return false;
    }

    String buildJsonString = builderJsonFile.readAsStringSync();
    Map<String, dynamic> buildJson = JSON.decode(buildJsonString);

    if (buildJson['description'] != null) {
      _description = buildJson['description'].toString();
    }

    _placeholders.add('name');
    if (buildJson['placeholders'] != null &&
        buildJson['placeholders'].length > 0) {
      _placeholders.addAll(buildJson['placeholders']);
    }

    if (buildJson['rename'] != null && buildJson['rename'].length > 0) {
      _renames = buildJson['rename'];
    }

    return true;
  }

  bool validatePlaceholders(List<Map<String, String>> pHolder) {
    int matches = 0;

    if (pHolder.length != _placeholders.length) {
      return false;
    }

    for (int i = 0; i < _placeholders.length; i++) {
      for (int j = 0; j < pHolder.length; j++) {
        if (pHolder[j][_placeholders[i]] != null) {
          matches++;
          break;
        }
      }
    }

    return matches == pHolder.length;
  }

  String rename(String name, List<Map<String, String>> pHolders) {
    for (int i = 0; i < _renames.length; i++) {
      if (_renames[i]['from'] == name) {
        return replace(_renames[i]['to'], pHolders);
      }
    }

    return name;
  }

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
