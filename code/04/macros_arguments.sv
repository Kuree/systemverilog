`define REGISTER(NAME, WIDTH, VALUE, CLK) \
    logic [WIDTH-1:0] NAME;               \
    always_ff @(posedge CLK) begin        \
        NAME <= VALUE;                    \
    end

module top;

logic        clk;
logic [15:0] in;

// declare 3 registers that are pipelined to signal in, in sequence
`REGISTER(reg1, 16, in,   clk)
`REGISTER(reg2, 16, reg1, clk)
`REGISTER(reg3, 16, reg2, clk)

// set the clock to 0 at time = 0, then tick the clock every 2 unit of time
initial clk = 0;
always clk = #2 ~clk;

initial begin
    for (int i = 0; i < 3; i++) begin
        in = i;
        // wait for a cycle
        #4;
        // print out the register value
        $display("reg1: %d reg2: %d reg3: %d", reg1, reg2, reg3);
    end
    $finish;
end

endmodule
