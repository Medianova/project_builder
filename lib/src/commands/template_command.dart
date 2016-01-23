part of project_builder.commands;

class TemplateCommand extends Command {
  final name = 'template';
  final description = 'Template informations and management';

  TemplateCommand() {
    addSubcommand(new TemplateListCommand());
    addSubcommand(new TemplateInfoCommand());
    addSubcommand(new TemplateCopyCommand());
  }
}
