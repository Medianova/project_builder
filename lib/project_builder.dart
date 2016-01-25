// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Project Builder library
///
/// This is a main library used in this project, every other is a child of this
/// one.
library project_builder;

import 'dart:async';

import 'package:args/command_runner.dart';

// Import available commands.
import 'src/commands.dart';

/// ProjectBuilder
class ProjectBuilder {
  /// Arguments passed from main function.
  final List<String> _args;

  /// Command resolver from args package.
  CommandRunner _commandRunner;

  /// ProjectBuilder constructor.
  ProjectBuilder(this._args) {
    _commandRunner =
        new CommandRunner('builder', 'Scaffold Dart projects from templates');

    // Create two main commands
    // Note that [TemplateCommand] has 3 subcommands.
    _commandRunner.addCommand(new BuildCommand());
    _commandRunner.addCommand(new TemplateCommand());
  }

  /// Resolves command and runs it.
  Future run() async {
    // args package will throw an error on unrecognized argument
    // and message of that exception will display usage and available commands.
    _commandRunner.run(this._args).catchError((e) {
      print(e.toString());
    });
  }
}
