library project_builder;

import 'dart:async';

// import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'src/commands.dart';

class ProjectBuilder {
  final List<String> _args;

  CommandRunner _commandRunner;

  ProjectBuilder(this._args) {
    _commandRunner =
        new CommandRunner('builder', 'Builds Dart projects from templates');

    _commandRunner.addCommand(new BuildCommand());
    _commandRunner.addCommand(new TemplateCommand());
  }

  Future run() async {
    _commandRunner.run(this._args).catchError((e) {
      print(e.toString());
    });
  }
}
