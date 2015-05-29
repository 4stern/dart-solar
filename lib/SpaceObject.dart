part of solar;

class SpaceObject {
	
	num bodySize;
	num orbitRadius;
	num orbitPeriod;
	num orbitSpeed;

	List<SpaceObject> orbiters = new List<SpaceObject>();

	String color = "#fff";

	SpaceObject(this.bodySize, this.orbitRadius, this.orbitPeriod){
		orbitSpeed = calculateSpeed(orbitPeriod);
	}

  	num calculateSpeed(num period) =>
      period == 0.0 ? 0.0 : 1 / (60.0 * 24.0 * 2 * period);

	Point calculatePos(num renderTime, Point p) {
		if (orbitSpeed == 0.0) return p;
		num angle = renderTime * orbitSpeed;

		return new Point(
			orbitRadius * cos(angle) + p.x, 
			orbitRadius * sin(angle) + p.y
		);
	}

	void draw(CanvasRenderingContext2D context, Point p, num renderTime) {
		Point pos = calculatePos(renderTime,p);
		drawSelf(context, pos);
		drawOrbiters(context, pos, renderTime);
	}

	void drawSelf(CanvasRenderingContext2D context, Point p) {
		// Check for clipping.
		if (p.x + bodySize < 0 || p.x - bodySize >= context.canvas.width) return;
		if (p.y + bodySize < 0 || p.y - bodySize >= context.canvas.height) return;

		// Draw the figure.
		context..lineWidth = 0.5
		       ..fillStyle = color
		       ..strokeStyle = color;

		if (bodySize >= 2.0) {
		  context..shadowOffsetX = 2
		         ..shadowOffsetY = 2
		         ..shadowBlur = 2
		         ..shadowColor = "#ddd";
		}

		context..beginPath()
		       ..arc(p.x, p.y, bodySize, 0, PI * 2, false)
		       ..fill()
		       ..closePath();

		context..shadowOffsetX = 0
		       ..shadowOffsetY = 0
		       ..shadowBlur = 0;

		context..beginPath()
		       ..arc(p.x, p.y, bodySize, 0, PI * 2, false)
		       ..fill()
		       ..closePath()
		       ..stroke();
	}

	void drawOrbiters(CanvasRenderingContext2D context, Point p, num renderTime){
		for (var iter = orbiters.iterator; iter.moveNext();) {
			var spaceobject = iter.current;
			spaceobject.draw(context, p, renderTime);
		}
	}
}