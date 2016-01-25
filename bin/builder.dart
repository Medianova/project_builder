// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Project executable
///
/// Used to invoke project main script [new ProjectBuilder] and run it from
/// global scope.

import 'dart:io';

// import main package
import 'package:project_builder/project_builder.dart';

/// invoke
main(List<String> args) {
  // create [new ProjectBuilder] instance by passing list of arguments [args]
  ProjectBuilder pb = new ProjectBuilder(args);

  // and then run it
  pb.run();
}
