// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of project_builder.commands;

/// List available templates.
class TemplateListCommand extends BaseCommand {
  final name = 'list';
  final description = 'List all templates';

  bool _verbose;

  /// Define available options and flags.
  TemplateListCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Be verbose', negatable: false);
  }

  /// Parse arguments and run this command.
  void run() {
    _verbose = argResults['verbose'];

    listAllTemplates();
  }

  /// List all templates.
  ///
  /// If template can't be loaded it throws [MissingDirectoryException] or
  /// [MissingBuilderException] exception.
  void listAllTemplates() {
    // get access to templates directory
    Directory templatesDirectory =
        new Directory(envInfo.rootPath + _templatesPath);

    // get list of folders
    List<FileSystemEntity> templates =
        templatesDirectory.listSync(recursive: false, followLinks: false);

    if (templates.length == 0) {
      print('No templates found');
      return;
    }

    // go through all templates and display information about it
    templates.forEach((entity) async {
      Template _template = new Template.fromPath(entity.path);

      try {
        _template.load();
      } on MissingDirectoryException catch (e) {
        print(pens.error('[ERROR]') +
            ' template ' +
            pens.template(_template.name) +
            ' doesn\'t exists');

        if (_verbose) {
          print(e);
        }
        return;
      } on MissingBuilderException catch (e) {
        print(pens.error('[ERROR]') +
            ' can\'t locate builder.json file for ' +
            pens.template(_template.name) +
            ' template');

        if (_verbose) {
          print(e);
        }
        return;
      } catch (e) {
        print(pens.error('[ERROR]') +
            ' error while opening ' +
            pens.template(_template.name) +
            ' template');

        if (_verbose) {
          print(e);
        }
      }

      print(pens.template(_template.name) +
          ' > ' +
          _template.builderJson.description);
    });
  }
}
