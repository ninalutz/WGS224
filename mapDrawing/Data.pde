JSONObject example;
JSONArray features;
JSONObject wholeArea;
//Look at https://processing.org/reference/JSONObject.html for more info
Table withRoe;
HashMap<String, Integer> overallScoreWithRoe;

color good = color(17, 193, 61);
color bad = color(250, 20, 20);
color mid = color(255, 255, 0);

void loadData(){
  //Whole Area
  wholeArea = loadJSONObject("gz_2010_us_040_00_500k.json");
  features = wholeArea.getJSONArray("features");
  withRoe = loadTable("WithRoe.csv", "header");
  overallScoreWithRoe = new HashMap<String, Integer>();
  for (TableRow row : withRoe.rows()) {
    
    String state = row.getString("State");
    Integer score = row.getInt("Overall score");
    overallScoreWithRoe.put(state, score);
  }

}

void parseData(){
  //First do the general object
  JSONObject feature = features.getJSONObject(0);

  //Sort 3 types into our respective classes to draw
  for(int i = 0; i< features.size(); i++){
    //Idenitfy 3 main things; the properties, geometry, and type 
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");

    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    JSONObject properties =  features.getJSONObject(i).getJSONObject("properties");
    String stateName = properties.getString("NAME");
    
    if(type.equals("Polygon")){
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get the coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
      for(int j = 0; j<coordinates.size(); j++){
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //Make a PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //Create the Polygon with the coordinate PVectors
      Polygon poly = new Polygon(coords);
      try{
        poly.score = overallScoreWithRoe.get(stateName);
        float val = map(poly.score, -6, 6, 0, 100);
        println(val);
        poly.fillColor = getRedGreen(val);
        poly.makeShape();
      }
      catch(Exception e){}
      polygons.add(poly);
    }
    
    if(type.equals("MultiPolygon")){
      JSONArray coordinates = geometry.getJSONArray("coordinates");
      for(int j = 0; j<coordinates.size(); j++){
        JSONArray innerCoordinates = coordinates.getJSONArray(j).getJSONArray(0);
        ArrayList<PVector> coords = new ArrayList<PVector>();
        for(int k = 0; k<innerCoordinates.size(); k++){
          float lat = innerCoordinates.getJSONArray(k).getFloat(1);
          float lon = innerCoordinates.getJSONArray(k).getFloat(0);
          //Make a PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
        //Create the Polygon with the coordinate PVectors
        Polygon poly = new Polygon(coords);
      try{
        poly.score = overallScoreWithRoe.get(stateName);
        float val = map(poly.score, -6, 6, 0, 100);
        println(val);
        poly.fillColor = getRedGreen(val);
        poly.makeShape();
      }
      catch(Exception e){}
        polygons.add(poly);  
      }
    }
  }
}

color getRedGreen(float val){
  color c = color(0, 0, 0);
  
  
  if(val > 50){
    c = lerpColor(mid, good, val/100);
  }
  if(val == 50){
    c = mid;
  }
  if(val < 50){
    c = lerpColor(bad, mid, val/100);
  }
  return c;
}
