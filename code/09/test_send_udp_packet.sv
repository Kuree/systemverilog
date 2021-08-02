// test_send_udp_packet.sv
import "DPI-C" function int send_udp_packet(input string ip_address, input shortint unsigned port, input byte data[]);

module test_send_udp_packet;

initial begin
    byte array[];
    int res;

    array = new[4];
    for (int i = 0; i < array.size(); i++) begin
        array[i] = 42 + i;
    end

    res = send_udp_packet("127.0.0.1", 8888, array);    

end

endmodule
