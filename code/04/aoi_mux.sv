module aoi_mux
  #(parameter int WIDTH=1,
    parameter int NUM_INPUT=2) (
    input  logic[NUM_INPUT-1:0][WIDTH-1:0] I,
    input  logic[$clog2(NUM_INPUT)-1:0] S,
    output logic[WIDTH-1:0] O
);

// calculate the ceiling of num_input / 2
localparam NUM_OPS = (NUM_INPUT + 1) >> 1;
localparam MAX_RANGE = NUM_INPUT >> 1;

logic [NUM_INPUT-1:0] sel_one_hot;
// simplified one-hot precoder.
assign sel_one_hot = (S < NUM_INPUT)?
                      1 << S:
                      0;

// intermediate results
logic [NUM_OPS-1:0][WIDTH-1:0] inter_O;

// AOI logic part
always_comb begin
    // working on each bit
    for (int w = 0; w < WIDTH; w++) begin
        // half the tree
        for (int i = 0; i < MAX_RANGE; i++) begin
            inter_O[i][w] = (sel_one_hot[i * 2] & I[i * 2][w]) |
                            (sel_one_hot[i * 2 + 1] & I[i * 2 + 1][w]);
        end
        // need to take care of odd number of inputs
        if (NUM_INPUT % 2) begin
            inter_O[MAX_RANGE][w] = sel_one_hot[MAX_RANGE * 2] & I[MAX_RANGE * 2][w];
        end
    end
end

// compute the final result, i.e. OR the intermediate result together
// notice that |inter_O doesn't work here since it will reduce to 1-bit signal
always_comb begin
    O = 0;
    for (int i = 0; i < NUM_OPS; i++) begin
        O = O | inter_O[i];
    end
end

endmodule
