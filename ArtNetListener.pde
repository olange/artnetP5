import java.net.SocketException;
import artnet4j.ArtNetException;
import artnet4j.ArtNetServer;
import artnet4j.events.ArtNetServerListener;
import artnet4j.packets.ArtDmxPacket;
import artnet4j.packets.ArtNetPacket;

class ArtNetListener {
  public static final int DMX_CHANNELS_COUNT = 512;

  private static final int SUBNET_COUNT = 16;
  private static final int UNIVERSE_COUNT = 16;

  private int inPort = ArtNetServer.DEFAULT_PORT;
  private int outPort = ArtNetServer.DEFAULT_PORT;
  private String broadcastAddress = ArtNetServer.DEFAULT_BROADCAST_IP;
  private int currentSubnet = 1;
  private int currentUniverse = 0;
  private int sequenceId = 0;

  private byte[][][] inputDmxArrays = new byte[ SUBNET_COUNT][ UNIVERSE_COUNT][ DMX_CHANNELS_COUNT];

  private ArtNetServer artNetServer = null;

  ArtNetListener() {
    try {
      startArtNet();
    } catch( SocketException e) {
      println( e);
    } catch( ArtNetException e) {
      println( e);
    }
  }

  public void startArtNet()
    throws SocketException, ArtNetException {
    if( this.artNetServer != null) {
      stopArtNet();
    }

    this.artNetServer = new ArtNetServer( this.inPort, this.outPort);
    this.artNetServer.setBroadcastAddress( this.broadcastAddress);
    this.artNetServer.start();
    initArtNetReceiver();

    println( "ArtNet Started (broadcast: " + this.broadcastAddress
           + ", in: " + this.inPort + ", out: " + this.outPort + ")");
  }

  public void stopArtNet() {
    if( this.artNetServer != null) {
        this.artNetServer.stop();
        this.artNetServer = null;
        println( "ArtNet Stopped");
    }
  }

  private void initArtNetReceiver() {
    this.artNetServer.addListener(
      new ArtNetServerListener() {
        @Override
        public void artNetPacketReceived( final ArtNetPacket artNetPacket) {
          switch( artNetPacket.getType()) {
            case ART_OUTPUT:
              ArtDmxPacket artDmxPacket = (ArtDmxPacket) artNetPacket;
              int subnet = artDmxPacket.getSubnetID();
              int universe = artDmxPacket.getUniverseID();
              System.arraycopy(
                artDmxPacket.getDmxData(), 0,
                inputDmxArrays[ subnet][ universe], 0,
                artDmxPacket.getNumChannels());
              println( "Received packet in universe " + universe
                + " / subnet " + subnet + " containing "
                + artDmxPacket.getNumChannels() + " channel values:");
              printArray( artDmxPacket.getDmxData());
              break;

            default:
              break;
          }
        }

        @Override
        public void artNetServerStopped( final ArtNetServer artNetServer) {
        }

        @Override
        public void artNetServerStarted( final ArtNetServer artNetServer) {
        }

        @Override
        public void artNetPacketUnicasted( final ArtNetPacket artNetPacket) {
        }

        @Override
        public void artNetPacketBroadcasted( final ArtNetPacket artNetPacket) {
        }
    });
  }

  public byte[] getInputDmxArray( final int subnet, final int universe) {
    return inputDmxArrays[ subnet][ universe];
  }

  public byte[] getCurrentInputDmxArray() {
    return getInputDmxArray( this.currentSubnet, this.currentUniverse);
  }
 
  public Integer toInt( Byte dmxChannelValue) {
    int intValue = dmxChannelValue.intValue();
    return intValue < 0 ? intValue + 256 : intValue;
  } 
  
  public Integer getValueAt( final int index) {
    return toInt((Byte) getCurrentInputDmxArray()[ index]);
  }
}
