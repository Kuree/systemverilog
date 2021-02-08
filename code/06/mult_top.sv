`include "mult_env.sv"

module mult_top;

// env
mult_env env;
// interface
logic clk, rst_n;
// num of xacts
localparam num_xact = 42;

mult_io_interface io(.*);
// dut
mult_ex dut (.clk(io.clk),
             .rst_n(io.rst_n),
             .a(io.a),
             .b(io.b),
             .hi(io.hi),
             .lo(io.lo),
             .valid_in(io.valid_in),
             .valid_out(io.valid_out),
             .ready_in(io.ready_in),
             .ready_out(io.ready_out)
);

// clocking
initial clk = 0;
always clk = #5 ~clk;

// reset sequence
initial begin
    rst_n = 1;
    #1;
    rst_n = 0;
    #1;
    rst_n = 1;
end

// start the test
initial begin
    env = new(num_xact, io);
    env.run();
end

// in case of bug, terminate after certain times
initial #(num_xact * 10 * 5) $finish;

endmodule