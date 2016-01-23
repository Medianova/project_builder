part of project_builder.commands;

class TemplateCopyCommand extends BaseCommand {
  final name = 'copy';
  final description = 'Copy template';

  Template _template;

  String _dstPath;
  bool _verbose;

  TemplateCopyCommand() {
    argParser.addOption('source', abbr: 's', help: 'Source template name');
    argParser.addOption('target', abbr: 't', help: 'Target template name');

    argParser.addFlag('verbose',
        abbr: 'v', help: 'Be verbose', negatable: false);
  }

  void run() {
    if (argResults['source'] == null) {
      print(
          pens.error('[ERROR]') + ' you have to specify source template name');
      return;
    }

    if (argResults['target'] == null) {
      print(
          pens.error('[ERROR]') + ' you have to specify target template name');
      return;
    }

    if (argResults['source'] == argResults['target']) {
      print(pens.error('[ERROR]') +
          ' target template name has to be different from source template name');
      return;
    }

    _verbose = argResults['verbose'];
    _dstPath =
        envInfo.rootPath + _templatesPath + envInfo.ds + argResults['target'];

    _template = new Template.fromName(argResults['source']);

    copyTemplate();
  }

  void copyTemplate() {
    if (_verbose) {
      print('copying ' +
          pens.template(_template.name) +
          ' to ' +
          pens.info(_dstPath));
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
      _template.copy(_dstPath, verbose: _verbose);
    } on NotLoadedException catch (e) {
      print(pens.error('[ERROR]') +
          ' template ' +
          pens.template(_template.name) +
          ' can\'t be loaded');

      if (_verbose) {
        print(e);
      }

      return;
    } on ExistsException catch (e) {
      print(pens.error('[ERROR]') +
          ' location already exists ' +
          pens.template(_dstPath));

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
