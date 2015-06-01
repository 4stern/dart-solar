import 'dart:math';

class Object {
	num mass;
	num radius;
	Point position;
	Object({this.mass, this.radius, this.position});
}



class Calc {
	num CONST_G = 6.67384 * pow(10,-11);

	num getDistance(Object m1, Object m2){
		return sqrt( 
			pow(m2.position.x - m1.position.x ,2) +
			pow(m2.position.y - m1.position.y ,2)
		);
	}

	num getF(Object m1, Object m2){
		num distance = getDistance(m1,m2);

		return CONST_G*( (m1.mass*m2.mass) / pow(distance,2) );
	}

	num getF1(Object m1, Object m2){
		num distance = getDistance(m1,m2);
		num n = pow((
					sqrt(pow(m2.position.x,2)+pow(m2.position.y,2))-
					sqrt(pow(m1.position.x,2)+pow(m1.position.y,2))
				),3);
		num factor = CONST_G*m1.mass*m2.mass;
		return new Point(
			factor * ((m2.position.x-m1.position.x)/n),
			factor * ((m2.position.y-m1.position.y)/n)
		);
	}
}




void main() {
	Object erde = new Object(
		mass: 5.9722 * pow(10, 24),
		radius: 6378388,
		position: new Point(100, 100)
	);
	Object mars = new Object(
		mass: 6.419  * pow(10, 23),
		radius: 3390000,
		position: new Point(63783880, 63783880)
	);
	Object mond = new Object(
		mass: 7.349  * pow(10, 22),
		radius: 1738,
		position: new Point(6478388, 6478388)
	);


	Calc calc = new Calc();

	print(calc.getDistance(erde,mars));
	print(calc.getF(erde,mars));
	print(calc.getF1(erde,mars));
	print(calc.getF1(mars,erde));

	print(calc.getDistance(erde,mond));
	print(calc.getF(erde,mond));
	print(calc.getF1(erde,mond));
	print(calc.getF1(mond,erde));
}