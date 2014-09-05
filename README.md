# ArtnetP5

A Processing sketch that listens to ArtNet DMX Input packets and displays the values of the 6 first channels as a graph bar.

Uses the [Artnet4j-Elios](https://github.com/Eliosoft/artnet4j-elios) library to listen to the ArtNet network, which is a fork supporting DMX Input, based on [ArtNet4j](https://code.google.com/p/artnet4j/) by Karsten Schmidt (toxilibs).

## Sample output

<image src="docs/images/sample-dmx-console-state.jpg" height="250" />
<image src="docs/images/sample-matching-artnetp5-display.png" height="250" />

## See also

* [Artnet4j installation](docs/artnet4j-installation.md) _Describes how to build Artnet4j JAR and configure Enttec's OpenDMX Ethernet_
