library clock.main;

import 'dart:html';

import 'package:solar/solar.dart';

void main() {
  CanvasElement canvas = querySelector("#area");
  new Engine(canvas).start();
}