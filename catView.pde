import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

import processing.net.*;

Server s;
Client c;
String input;
float[] data;
Location current;

void setup() {

    size(640, 480);

    map = new UnfoldingMap(this, new Microsoft.AerialProvider());
    map.setTweening(true);

    current = new Location(41.6f, 41.6f);

    MapUtils.createDefaultEventDispatcher(this, map);

    s = new Server(this, 31090); // Start a simple server on a port

} // setup

void draw() {

  background(0);

  c = s.available();
  if (c != null) {
    input = c.readString();
    data = float(split(input, ','));
    current.x = data[1];
    current.y = data[2];
    map.zoomAndPanTo(14, current);//new Location(data[1], data[2]));
    print(input);
  } // if

  map.draw();

} // draw
