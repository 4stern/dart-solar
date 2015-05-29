part of solar;

class Line implements Drawable, Gravityable {

	Point start;
	Point end;
	String color;

	num mass = 1000;

	Line(this.start, this.end, this.color);

	void draw(CanvasRenderingContext2D context, num renderTime){
		context..lineWidth = 4
		       ..fillStyle = color
		       ..strokeStyle = color;

		context..beginPath()
		       ..moveTo(start.x, start.y)
		       ..lineTo(end.x, end.y)
		       ..stroke()
		       ..closePath();
	}
}

class Ball implements Drawable, Gravityable {

	num radius;
	String color;
	num mass;

	Point position;
	Point moving;
	bool movingDirectionIntoGravity = true;
	Environment env;

	Ball(this.env, this.position, this.radius, this.color){
		mass = radius;
		moving = new Point(0.0, 0.0);
	}

	void flipGravityDirection(){
		movingDirectionIntoGravity = !movingDirectionIntoGravity;
	}

	void calcMoving(num dTime){
		num dx = (dTime/1000) * env.fallPerSec;
		Point dPoint = new Point(
			0.0,
			dx
		);

		if(position.y > (200.0-radius-4)){
			flipGravityDirection();

		} else {
			if(movingDirectionIntoGravity){
				moving = moving+dPoint;
			} else {
				moving = moving-dPoint;
			}
		}
		
		
		moving = new Point(
			moving.x*env.airRubbingLoss,
			moving.y*env.airRubbingLoss
		);

		if(movingDirectionIntoGravity){
			position = position + moving;
		} else {
			position = position - moving;
		}
	}

	void draw(CanvasRenderingContext2D context, num renderTime) {

		// Draw the figure.
		context..lineWidth = 0.5
		       ..fillStyle = color
		       ..strokeStyle = color;

		context..shadowOffsetX = 0
		       ..shadowOffsetY = 0
		       ..shadowBlur = 0;

		context..beginPath()
		       ..arc(position.x, position.y, radius, 0, PI * 2, false)
		       ..fill()
		       ..closePath()
		       ..stroke();
	}
}

class Environment {
	final num airRubbingLoss = 0.99; 
	final num fallPerSec = 9.81;
}

class Fall {

	Environment env;

	String colorRed = "#FF0000";
	String colorWhite = "#FFFFFF";
	String colorPink = "#FF66FF";

	Line ground;
	Ball ball;
	Ball ball2;
	
	num oldRenderTime = 0.0;

	Fall(){

		Environment env = new Environment();

		num groundY = 200.0;
		Point distance = new Point(4.0, 300.0);

		ground = new Line(
			new Point(distance.x, groundY), 
			new Point(distance.y, groundY), 
			colorRed
		);

		ball = new Ball(
			env,
			new Point(100.0, 100.0), 
			10.0, 
			colorPink
		);

		ball2 = new Ball(
			env,
			new Point(200.0, 50.0), 
			20.0, 
			colorWhite
		);
	}

	num distanceBetweenPoints(Point one, Point two){
		return sqrt(
			pow(two.x - one.x, 2) + 
			pow(two.y - one.y, 2)
		);
	}

	void draw(CanvasRenderingContext2D context, num renderTime) {
		if(oldRenderTime>0.0){
			num dTime = renderTime - oldRenderTime;

			num distance = distanceBetweenPoints(
				ball.position,
				new Point(100.0, 200.0)
			);

			ball.calcMoving(dTime);
			ball2.calcMoving(dTime);

			ground.draw(context, renderTime);
			ball.draw(context, renderTime);
			ball2.draw(context, renderTime);
		}
		oldRenderTime = renderTime;
	}

}