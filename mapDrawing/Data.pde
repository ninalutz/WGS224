JSONObject example;
JSONArray features;
JSONObject wholeArea;
//Look at https://processing.org/reference/JSONObject.html for more info
Table withRoe, withoutRoe;
HashMap<String, Integer> ScoreWithRoe;
int minScore, maxScore;
color good = color(17, 193, 61);
color bad = color(250, 20, 20);
color mid = color(255, 255, 0);
String metric;
boolean discrete = true;
String lawCase;
void loadData(){
  //Whole Area
  wholeArea = loadJSONObject("gz_2010_us_040_00_500k.json");
  features = wholeArea.getJSONArray("features");
  withRoe = loadTable("WithRoe.csv", "header");
  withoutRoe = loadTable("WithoutRoe.csv", "header");
  ScoreWithRoe = new HashMap<String, Integer>();

  //With roe vs wade metrics:
   lawCase = "With Roe vs. Wade: ";
   metric = "Unconstitutional Gestational Bans";
 //  metric = "Two Trips Required for Abortion";
  // metric = "Medicaid Coverage Restricted";
  // metric = "Telemedicine Banned for Abortion";
  // metric = "Parental Involvement Required";
  // metric = "Clinic Regulations";
  // metric = "State Constitution Protects Abortion Rights";
 //  metric = "State Law Protects Abortion Rights";
  // metric = "Medicaid Coverage for Abortion";
   //metric = "APC Provision of Abortion";
   //metric = "Health Insurance Plans Must Cover Abortion";
   //metric = "Access to Abortion Clinics Protected";
   //metric = "Overall Score"; discrete = false;
   
   //Without roe vs wade metrics:
   //lawCase = "Without Roe vs. Wade: ";
   //metric = "Constitutional Protection"; 
   //metric = "Statutory Protection";
   //metric = "Pre-Roe Ban on Books";
   //metric = "Unconsitutional Gestational Limits";
   //metric ="Trigger Ban";
   //metric = "Legislative"; discrete = false;
   //metric = "Score"; discrete = false;
   
  if(lawCase.equals("Without Roe vs. Wade: ")){
  for (TableRow row : withoutRoe.rows()) {
    String state = row.getString("State");
    Integer score = row.getInt(metric);
    ScoreWithRoe.put(state, score);
  }
  }
  else{
    for (TableRow row : withRoe.rows()) {
    String state = row.getString("State");
    Integer score = row.getInt(metric);
    ScoreWithRoe.put(state, score);
  }}
  
  minScore = -6;
  maxScore = 6;

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
        assignColor(poly, stateName);
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
        assignColor(poly, stateName);
      }
      catch(Exception e){}
        polygons.add(poly);  
      }
    }
  }
}

void assignColor(Polygon poly, String stateName){
      int score = ScoreWithRoe.get(stateName);
      poly.score = score;
      float val = map(poly.score, minScore, maxScore, 0, 100);
    //  println(val);
      if(!discrete){
      poly.fillColor = getRedGreen(val);
      }
      if(discrete){
        if(score == 0) poly.fillColor = color(100);
        if(score == -1) poly.fillColor = color(bad);
        if(score == 1 || score == 2) poly.fillColor = color(good);
      }
      poly.makeShape();
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

void keyPressed(){
   String fileName;
  if(lawCase.equals("Without Roe vs. Wade: ")){
    fileName = trim("Without" + metric + ".png");
  }
  else{
    fileName = trim("With" + metric + ".png");
  }
 
  if(key == ' ') saveFrame(fileName);
}
