part of project_builder.commands;

class BuildCommand extends BaseCommand {
  final name = 'build';
  final description = 'Build new project based on a given template';

  Template _template;
  String _projectName;
  String _destinationPath;
  List<String> _placeholders;

  bool _verbose;

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

  void build() {
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
