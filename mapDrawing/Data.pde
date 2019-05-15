JSONObject example;
JSONArray features;
JSONObject wholeArea;
//Look at https://processing.org/reference/JSONObject.html for more info

void loadData(){
  //Load and resize background image

  //Whole Area
  wholeArea = loadJSONObject("gz_2010_us_040_00_500k.json");
  features = wholeArea.getJSONArray("features");
  
  println("There are : ", features.size(), " features."); 
}

void parseData(){
  //First do the general object
  JSONObject feature = features.getJSONObject(0);

  //Sort 3 types into our respective classes to draw
  for(int i = 0; i< 4; i++){
    //Idenitfy 3 main things; the properties, geometry, and type 
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    JSONObject properties =  features.getJSONObject(i).getJSONObject("properties");
    println("Type", type);
    println("Geo", geometry);
   

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
      polygons.add(poly);
    }
  }
}
