MercatorMap map;
//(-124.848974, 24.396308) - (-66.885444, 49.384358)

void setup(){
    size(1200, 800);
   // map = new MercatorMap(width, height, -117.339757, 25.91619, -124.96466, -71.3577635769, 0);
   // map = new MercatorMap(width, height, 42.3636, 42.3557, -71.1034, -71.0869, 0);
   //this(mapScreenWidth, mapScreenHeight, DEFAULT_TOP_LATITUDE, DEFAULT_BOTTOM_LATITUDE, DEFAULT_LEFT_LONGITUDE, DEFAULT_RIGHT_LONGITUDE, DEFAULT_ROTATION);
     map = new MercatorMap(width, height, 52, 20, -130, -61, 0);
    polygons = new ArrayList<Polygon>();
    loadData();
    parseData();
}

void draw(){
  background(255);
  smooth();
  fill(0);
  textSize(30);
  text(lawCase + metric, 20, 45);
  //Draw all polygons 
  for(int i = 0; i<polygons.size(); i++){
    polygons.get(i).draw();
  }
    if(!discrete){
    textSize(20);
    text("Restricted to Accessible: ", 40, height-100);
    drawColorLegend();
    }
}

void drawColorLegend(){
  setGradient(40, height - 90, 150, 45, bad, mid);
  setGradient(190, height - 90, 150, 45, mid, good);
}

void setGradient(int x, int y, float w, float h, color c1, color c2 ) {
    noFill();
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
}
