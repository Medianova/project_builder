part of project_builder.commands;

class TemplateListCommand extends BaseCommand {
  final name = 'list';
  final description = 'List all templates';

  bool _verbose;

  TemplateListCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Be verbose', negatable: false);
  }

  void run() {
    _verbose = argResults['verbose'];

    listAllTemplates();
  }

  void listAllTemplates() {
    Directory templatesDirectory =
        new Directory(envInfo.rootPath + _templatesPath);

    List<FileSystemEntity> templates =
        templatesDirectory.listSync(recursive: false, followLinks: false);

    if (templates.length == 0) {
      print('No templates found');
    }

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
