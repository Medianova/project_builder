// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of project_builder.commands;

/// Base class for all the commands
abstract class BaseCommand extends Command {
  /// Defines path to templates folder
  final String _templatesPath = 'templates';

  /// Gives access to routes with [EnvInfo] class.
  final EnvInfo envInfo = new EnvInfo();
  /// Gives access to pens with [Pens] class.
  final Pens pens = new Pens();
}
