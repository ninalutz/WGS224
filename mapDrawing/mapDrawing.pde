MercatorMap map;
//(-124.848974, 24.396308) - (-66.885444, 49.384358)
void setup(){
    size(1000, 650);
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
  //Draw all polygons 
  for(int i = 0; i<polygons.size(); i++){
    polygons.get(i).draw();
  }
}
