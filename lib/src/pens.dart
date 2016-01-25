// Copyright (c) 2016, Borut Jegrisnik. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Declare different pens
library project_builder.pens;

import 'package:ansicolor/ansicolor.dart';

class Pens {
  AnsiPen template = new AnsiPen()..green(bold: true);
  AnsiPen error = new AnsiPen()..red(bold: true);
  AnsiPen warnning = new AnsiPen()..cyan(bold: true);
  AnsiPen info = new AnsiPen()..white(bold: true);
}
