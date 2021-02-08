`ifndef MULT_IO_INTERFACE
`define MULT_IO_INTERFACE

interface mult_io_interface #(
    parameter WIDTH=32
) (
    input logic clk,
    input logic rst_n
);

logic[WIDTH-1:0] a, b, lo, hi;
logic ready_in, ready_out, valid_in, valid_out;

// define driver and monitor modport interface
modport driver (
    output a,
    output b,
    output valid_in,
    output ready_in,

    input clk,
    input rst_n,
    input ready_out,
    input valid_out
);

// monitor just passively sample signals
modport monitor (
    input a,
    input b,
    input lo,
    input hi,

    input clk,
    input rst_n,
    input ready_out,
    input ready_in,
    input valid_out,
    input valid_in
);

endinterface

class GeneratorXact #(
    parameter WIDTH=32
);
    logic[WIDTH-1:0] a;
    logic[WIDTH-1:0] b;
endclass

class ScoreBoardXact #(
    parameter WIDTH=32
);
    logic[WIDTH-1:0] a;
    logic[WIDTH-1:0] b;
    logic[WIDTH-1:0] lo;
    logic[WIDTH-1:0] hi;
endclass

`endif // MULT_IO_INTERFACE