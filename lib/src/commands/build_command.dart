// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of project_builder.commands;

// Build project from template
class BuildCommand extends BaseCommand {
  final name = 'build';
  final description = 'Build new project based on a given template';

  /// Source [_template].
  Template _template;
  /// Project name
  String _projectName;
  /// Path where to create project
  String _destinationPath;
  /// List of placeholders
  List<String> _placeholders;

  bool _verbose;

  /// Define available options and flags.
  BuildCommand() {
    argParser.addOption('name', abbr: 'n', help: 'Project name');
    argParser.addOption('template',
        abbr: 't', help: 'Template name to be used');
    argParser.addOption('destination',
        abbr: 'd', help: 'Destination path where to build new project');
    argParser.addOption('placeholder',
        abbr: 'p', allowMultiple: true, help: 'Define placeholder value');
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Be verbose', negatable: false);
  }

  /// Parse arguments and run this command.
  ///
  /// Load this [_template].
  void run() {
    if (argResults['name'] == null) {
      print(pens.error('[ERROR]') + ' you have to specify project name');
      return;
    }

    if (argResults['template'] == null) {
      print(
          pens.error('[ERROR]') + ' you have to specify source template name');
      return;
    }

    if (argResults['destination'] == null) {
      _destinationPath = envInfo.currentPath;
    } else {
      _destinationPath = argResults['destination'];
    }

    _verbose = argResults['verbose'];
    _projectName = argResults['name'];
    _placeholders = argResults['placeholder'];

    _template = new Template.fromName(argResults['template']);

    build();
  }

  /// Build project from source [_template].
  ///
  /// If this [_template] can't be loaded throw [MissingDirectoryException] or
  /// [MissingBuilderException] exception.
  /// If placeholders are not the same as defined in builder.json file throw
  /// [MismatchPlaceholdersException] exception.
  /// If this [_template] can't be copied throw [NotLoadedException] or
  /// [ExistsException] or [CreateResourceException] exception.
  void build() {
    // load template
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

      return;
    }

    // build project
    try {
      _template.build(_destinationPath, _projectName, _placeholders,
          verbose: _verbose);
    } on NotLoadedException catch (e) {
      print(pens.error('[ERROR]') +
          ' template ' +
          pens.template(_template.name) +
          ' can\'t be loaded');

      if (_verbose) {
        print(e);
      }

      return;
    } on MismatchPlaceholdersException catch (e) {
      print(pens.error('[ERROR]') +
          ' number of placeholders differs: ' +
          pens.template(_template.builderJson.placeholders.toString()));

      if (_verbose) {
        print(e);
      }

      return;
    } on ExistsException catch (e) {
      print(pens.error('[ERROR]') +
          ' location already exists ' +
          pens.template(_destinationPath + _projectName));

      if (_verbose) {
        print(e);
      }

      return;
    } on CreateResourceException catch (e) {
      print(pens.error('[ERROR]') + ' can\'t create resource');

      if (_verbose) {
        print(e);
      }

      return;
    } catch (e) {
      print(pens.error('[ERROR]') + ' can\'t build project');

      if (_verbose) {
        print(e);
      }

      return;
    }

    if (_verbose) {
      print(pens.info('done'));
    }
  }
}
