// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of project_builder.commands;

/// Display template information
class TemplateInfoCommand extends BaseCommand {
  final name = 'info';
  final description = 'Get template info';

  /// Information about this [_template].
  Template _template;

  bool _verbose;

  /// Define available options and flags.
  TemplateInfoCommand() {
    argParser.addOption('name', abbr: 'n');

    argParser.addFlag('verbose',
        abbr: 'v', help: 'Be verbose', negatable: false);
  }

  /// Parse arguments and run this command.
  ///
  /// Load this [_template] and then display info.
  void run() {
    if (argResults['name'] == null) {
      print(pens.error('[ERROR]') + ' you have to specify template\'s name');
      return;
    }

    _template = new Template.fromName(argResults['name']);
    _verbose = argResults['verbose'];

    getTemplateInfo();
  }

  /// Display template info.
  void getTemplateInfo() {
    // first load template
    if (!loadTemplate()) {
      return;
    }

    // then display template name and description
    printTemplateName();
    // list defined placeholders
    printTemplatePlaceHolders();
    // list files and folders that needs to be renamed
    printTemplateRenames();
  }

  /// Try to load this [_template].
  ///
  /// If fails throw [MissingDirectoryException] or [MissingBuilderException]
  /// exception.
  bool loadTemplate() {
    if (_verbose) {
      print('Trying to load template ' +
          pens.template(_template.name) +
          ' from location ' +
          pens.info(_template.path));
    }

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

      return false;
    } on MissingBuilderException catch (e) {
      print(pens.error('[ERROR]') +
          ' can\'t locate builder.json file for ' +
          pens.template(_template.name) +
          ' template');

      if (_verbose) {
        print(e);
      }

      return false;
    } catch (e) {
      print(pens.error('[ERROR]') +
          ' error while opening ' +
          pens.template(_template.name) +
          ' template');

      if (_verbose) {
        print(e);
      }

      return false;
    }

    return true;
  }

  /// Print this [_template] name and description.
  void printTemplateName() {
    print(pens.template(_template.name) +
        ' > ' +
        _template.builderJson.description);
    print(pens.info('Location') + ': ' + _template.path);
  }

  // List defined placeholders.
  void printTemplatePlaceHolders() {
    if (_template.builderJson.placeholders.length == 0) {
      print(pens.info('No placeholders found'));
    } else {
      print(pens.info('Placeholders') + ':');
      _template.builderJson.placeholders.forEach((String p) {
        print(' {!' + pens.template(p) + '!}');
      });
    }
  }

  /// List files and folders that needs to be renamed.
  void printTemplateRenames() {
    if (_template.builderJson.renames.length == 0) {
      print(pens.info('Nothing to rename found'));
    } else {
      print(pens.info('To rename') + ':');
      for (int i = 0; i < _template.builderJson.renames.length; i++) {
        print(' ' +
            _template.builderJson.renames[i]['from'] +
            ' > ' +
            _template.builderJson.renames[i]['to']);
      }
    }
  }
}
