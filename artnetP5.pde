final static int NUM_CHANNELS_DISPLAYED = 6;

ArtNetListener artNetListener;
byte[] inputDmxArray;

void setup() {
  size( 800, 250);
  if( frame != null) { frame.setResizable( true); }
  textSize( 16);

  println( "Starting ...");
  artNetListener = new ArtNetListener();
}

void exit() {
  println( "Exiting ...");
  artNetListener.stopArtNet();
  super.exit();
}

void draw() {
  background( 0);
  inputDmxArray = artNetListener.getCurrentInputDmxArray(); 
  displayDMXInput();
  displayStatus();
}

void displayDMXInput() {
  float barH, barW;

  stroke( 32, 192);
  fill( 128, 192);

  barW = float( width - 41) / NUM_CHANNELS_DISPLAYED;
  for( int i = 0; i < NUM_CHANNELS_DISPLAYED; i++) {
    barH = floor( map( artNetListener.toInt( inputDmxArray[ i]),
                  0, 255, 0, height - 40));
    rect( 19 + barW * i, height - 20 - barH, barW, barH);
  }
}

void displayStatus() {
  fill( 255);
  text( inputDmxArray.length + " DMX channels, " + NUM_CHANNELS_DISPLAYED + " displayed\n"
        + width + " x " + height + "px (" + str( int( frameRate)) + " fps)"
        , 50, 50);
}

