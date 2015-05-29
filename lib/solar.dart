library solar;

import 'dart:html';
import 'dart:math';

part 'Interfaces.dart';
part 'SpaceObject.dart';
part 'SolarSystem.dart';
part 'fall.dart';
part 'gravity.dart';

Element _notes = querySelector("#fps");
num _fpsAverage;

/// Display the animation's FPS in a div.
void showFps(num fps) {
	if (_fpsAverage == null) _fpsAverage = fps;
	_fpsAverage = fps * 0.05 + _fpsAverage * 0.95;
	_notes.text = "${_fpsAverage.round()} fps";
}

class Engine {
	CanvasElement canvas;
	num renderTime;
	num width;
  	num height;

	SolarSystem solarSystem;
	Fall fall;
	Gravity gravity;

	Engine(this.canvas);

	void start() {
		Rectangle rect = canvas.parent.client;
    	width = rect.width;
    	height = rect.height;
    	canvas.width = width;
    	canvas.height = height;

    	solarSystem = new SolarSystem();
    	fall = new Fall();
    	gravity = new Gravity();

		requestRedraw();
	}

	void requestRedraw() {
    	window.requestAnimationFrame(draw);
  	}

	void draw([_]) {
		num time = new DateTime.now().millisecondsSinceEpoch;
		if (renderTime != null) {
			showFps(1000 / (time - renderTime));
		}
		renderTime = time;

		var context = canvas.context2D;
		drawBackground(context);

		solarSystem.draw(
			context, 
			new Point(width / 2, height / 2), 
			renderTime
		);

		fall.draw(context, renderTime);
		gravity.draw(context, renderTime);

		requestRedraw();
	}

	void drawBackground(CanvasRenderingContext2D context) {
		context.clearRect(0, 0, width, height);
	}
}