library project_builder.pens;

import 'package:ansicolor/ansicolor.dart';

class Pens {
  AnsiPen template = new AnsiPen()..green(bold: true);
  AnsiPen error = new AnsiPen()..red(bold: true);
  AnsiPen warnning = new AnsiPen()..cyan(bold: true);
  AnsiPen info = new AnsiPen()..white(bold: true);
}
