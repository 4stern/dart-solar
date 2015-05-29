part of solar;

class SolarSystem {

	SpaceObject sun;
	SpaceObject earth;
	SpaceObject moon;
	

	List<SpaceObject> drawables = new List<SpaceObject>();

	SolarSystem(){
		sun = new SpaceObject(30.0, 0.0, 0.0);
		sun.color="#FFFF00";
		
		earth = new SpaceObject(10.0, 200.0, 2.0);
		earth.color="#0000CC";
		moon = new SpaceObject(2.0, 20.0, 0.05);
		moon.color="#C0C0C0";

		earth.orbiters.add(moon);
		sun.orbiters.add(earth);

		sun.orbiters.add(
			new SpaceObject(10.0, 100.0, 0.3)
		);
		
		Random random = new Random();
		for(int i=0; i<500; i++){
			var radius = 280 + random.nextDouble() * (390 - 280);
			var period = 4.5 + random.nextDouble() * (8.0 - 4.5);
			var size = 0.8 + random.nextDouble() * (2.2 - 0.8);
			sun.orbiters.add(
				new SpaceObject(1.0, radius, period)
			);
		}

		drawables.add(sun);
	}

	void draw(CanvasRenderingContext2D context, Point p, num renderTime) {
		for (var iter = drawables.iterator; iter.moveNext();) {
			var spaceobject = iter.current;
			spaceobject.draw(context, p, renderTime);
		}
	}
}
