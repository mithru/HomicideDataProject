void sendUDPMessage(String message) {
    
    String ip       = "172.22.6.61";  // the remote IP address
    int port        = 6100;    // the destination port
    
    // formats the message for Pd
    message = message+";\n";
    // send the message
    udp.send( message, ip, port );    
}