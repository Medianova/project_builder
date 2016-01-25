// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of project_builder.commands;

/// Main Template command which is created with 3 subcommands.
class TemplateCommand extends Command {
  final name = 'template';
  final description = 'Template informations and management';

  /// Create 3 subcommands.
  TemplateCommand() {
    addSubcommand(new TemplateListCommand());
    addSubcommand(new TemplateInfoCommand());
    addSubcommand(new TemplateCopyCommand());
  }
}
