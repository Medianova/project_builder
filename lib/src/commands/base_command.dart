part of project_builder.commands;

class BaseCommand extends Command {
  final _templatesPath = 'templates';

  final EnvInfo envInfo = new EnvInfo();
  final Pens pens = new Pens();
}
