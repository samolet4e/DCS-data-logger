// https://stackoverflow.com/questions/27755344/unfolding-simplemapapp-image-files-missing

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

// import de.fhpotsdam.unfolding.providers.EsriProvider;
import de.fhpotsdam.unfolding.providers.Microsoft;
// import de.fhpotsdam.unfolding.providers.Google;

UnfoldingMap map;

import de.fhpotsdam.unfolding.marker.SimplePointMarker;
SimplePointMarker myMarker;

import processing.net.*;

Server s;
Client c;
String input;
float[] data;
Location current;
int zoom = 16;
JSONArray route;
ArrayList<float[]> longLat;

void setup() {

  size(640, 480, FX2D);
  surface.setAlwaysOnTop(true);

  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
//  map = new UnfoldingMap(this, new Google.GoogleSimplifiedProvider());
//  map = new UnfoldingMap(this, new EsriProvider.WorldTopoMap());
//  map.setTweening(true);

  map.zoomAndPanTo(zoom, new Location(41.609444, 41.603333));//(43.5f, 40.f));
  MapUtils.createDefaultEventDispatcher(this, map);

  current = new Location(43.5f, 40.f);
  myMarker = new SimplePointMarker(current);

  s = new Server(this, 31090); // Start a simple server on a port

  longLat = new ArrayList<float[]>(0);

  route = loadJSONArray("in.json");

  for (int i = 0; i < route.size(); i++) {

      JSONObject point = route.getJSONObject(i); 
      int id = point.getInt("id");
      float longitude = point.getFloat("long");
      float latitude = point.getFloat("lat");

      float[] t = new float[2];
      t[0] = longitude;
      t[1] = latitude;
      longLat.add(t);

  } // for_i

} // setup

float heading, x1, y1;

void draw() {

  c = s.available();
  if (c != null) {
    input = c.readString();
    data = float(split(input, ','));
    current.x = data[1];// - 0.0035;
    current.y = data[2];// - 0.0023;
    map.zoomAndPanTo(zoom, current); // new Location(data[1], data[2]));
    heading = data[4];
    x1 = 75. * cos(heading + 0.5 * PI);
    y1 = 75. * sin(heading + 0.5 * PI);
//    println(heading * 180. / PI);
  } // if

  background(0);
  map.draw();

  strokeWeight(2);
  stroke(255, 0, 0);
//  pushMatrix();
    line(width/2, height/2, width/2-x1, height/2-y1);
//  popMatrix();

  ScreenPosition posDCS = myMarker.getScreenPosition(map);
  strokeWeight(8);
  stroke(67, 211, 227, 100);
  noFill();
//  float s = map.getZoom();
  ellipse(posDCS.x, posDCS.y, 18, 18);

  Location location = map.getLocation(mouseX, mouseY);
  fill(255, 255, 255);
  text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);

  for (int i = 0; i < longLat.size(); i++) {
      ScreenPosition pos0 = map.getScreenPosition(new Location(longLat.get(i)[0], longLat.get(i)[1]));
      int i1;
      if (i == longLat.size()-1) i1 = 0;
      else i1 = i + 1;
      ScreenPosition pos1 = map.getScreenPosition(new Location(longLat.get(i1)[0], longLat.get(i1)[1]));
      ellipse(pos0.x, pos0.y, 18, 18);
      line(pos0.x, pos0.y, pos1.x, pos1.y);
  } // for_i

} // draw
