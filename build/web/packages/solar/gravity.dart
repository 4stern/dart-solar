part of solar;

class GravityEnvironment {
	double airFriction; 
	double velocityOfFall;
	double gravity;

	GravityEnvironment(){
		airFriction = 0.01; 
		velocityOfFall = 9.81;
		gravity = 6.673 * pow(10, -11);
	}
}

class RenderableObject {
	GravityEnvironment enviroment = new GravityEnvironment();

	RenderableObject();

	void prepareDraw(){}
	void draw(CanvasRenderingContext2D context, num renderTime){}
}

class GravityObject extends RenderableObject {

	num mass;
	Point movingVector;	
	Point position;

	GravityObject({this.position, this.mass}) : super() {
		movingVector = new Point(0.0, 0.0);
	}

	num distanceToPoint(Point to){
		return sqrt(
			pow(to.x - position.x, 2) + 
			pow(to.y - position.y, 2)
		);
	}

	num getAttractionTo(GravityObject object){
		num attraction = 0.0;
		num disantance = distanceToPoint(object.position);

		attraction = enviroment.gravity * ((mass * object.mass) / pow(disantance, 2));

		return attraction;
	}
}

class GLine extends GravityObject {

	Point from;
	Point to;

	String color;

	GLine({
		this.from, 
		this.to
	}) : super(){
		color = "#fff";
	}

	/* @override */
	void draw(CanvasRenderingContext2D context, num renderTime){
		context..lineWidth = 1.0
		       ..fillStyle = color
		       ..strokeStyle = color;

		context..beginPath()
		       ..moveTo(from.x, from.y)
		       ..lineTo(to.x, to.y)
		       ..fill()
		       ..closePath()
		       ..stroke();
	}
}

class GBall extends GravityObject {

	num radius;

	String color;

	GBall({
		this.radius,
		Point position,
		num mass
	}) : super(position:position, mass: mass){
		color = "#fff";
	}

	/* @override */
	void prepareDraw(){
		position = position + movingVector;
		//movingVector = new Point(0.0, 0.0);
	}

	/* @override */
	void draw(CanvasRenderingContext2D context, num renderTime){
		context..lineWidth = 0.5
		       ..fillStyle = color
		       ..strokeStyle = color;

		context..beginPath()
		       ..arc(position.x, position.y, radius, 0, PI * 2, false)
		       ..fill()
		       ..closePath()
		       ..stroke();
	}
}

class Gravity {

	GBall ball;

	List<GravityObject> gravitons = new List<GravityObject>();

	Gravity(){

		GBall ball1 = new GBall(
			radius: 10.0,
			position: new Point(250.0, 500.0),
			mass: 300.0
		);
		ball1.color="green";

		GBall ball2 = new GBall(
			radius: 10.0,
			position: new Point(350.0, 500.0),
			mass: 500000.0
		);
		ball2.color="red";
		ball2.movingVector = new Point(-0.5, -0.5);

		gravitons.add(ball1);
		gravitons.add(ball2);
	}

	void calculateGravity(){
		GBall ball1 = gravitons[0];
		GBall ball2 = gravitons[1];

		var distancsB1ToB2 = ball1.distanceToPoint(ball2.position);
		num attractionB12B2 = ball1.getAttractionTo(ball2);
		num attractionB22B1 = ball2.getAttractionTo(ball1);
		
		
		ball2.movingVector = new Point(
			(ball2.position.x - ball1.position.x) * attractionB22B1,
			(ball2.position.y - ball1.position.y) * attractionB22B1
		);
		ball1.movingVector = new Point(
			ball1.movingVector.x - ((ball1.position.x - ball2.position.y) * attractionB12B2),
			ball1.movingVector.y - ((ball1.position.y - ball2.position.y) * attractionB12B2)
		);

		//print(distancsB1ToB2.toString() + ' | ' + attractionB12B2.toString() + ' | ' + attractionB22B1.toString());
		print(ball2.movingVector);
	}

	void draw(CanvasRenderingContext2D context, num renderTime){

		calculateGravity();

		gravitons.forEach((GravityObject object){
			object.prepareDraw();
			object.draw(context, renderTime);
		});
	}
}