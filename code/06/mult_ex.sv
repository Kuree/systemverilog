module mult_ex #(
    parameter WIDTH = 32
) (
    input  logic            clk,
    input  logic            rst_n,
    input  logic[WIDTH-1:0] a,
    input  logic[WIDTH-1:0] b,
    output logic[WIDTH-1:0] lo,
    output logic[WIDTH-1:0] hi,

    // ready-valid interface
    // input channel
    input  logic           valid_in,
    output logic           ready_out,
    // output channel
    output logic           valid_out,
    input  logic           ready_in
);


logic[WIDTH-1:0] data_lo;
logic[WIDTH-1:0] data_hi;

// we will implement it in a simple FSM
typedef enum logic[1:0] {
    IDLE,
    WORKING1,
    WORKING2,
    FINISH
} state_e;
state_e state;


// set FSM state and values
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        data_lo <= 'd0;
        data_hi <= 'd0;
        state <= IDLE;
    end 
    else begin
        unique case (state)
            IDLE: begin
                // if the input is valid
                if (valid_in) begin
                    // we do some work here since it's simple enough
                    {data_hi, data_lo} <= a * b;
                    // switch to the next state
                    state <= WORKING1;
                end
            end
            WORKING1: begin
                state <= WORKING2;
            end
            WORKING2: begin
                state <= FINISH;
            end
            FINISH: begin
                // only if the ready in is hi, otherwise we hold the output
                // values
                if (ready_in)
                    state <= IDLE;
            end
            default:
                state <= IDLE;
        endcase
    end
end

// set outputs based on internal state
always_comb begin
    ready_out = 1'b0;
    valid_out = 1'b0;
    lo = 0;
    hi = 0;
    unique case (state)
        IDLE: begin
            // we are ready
            ready_out = 1'b1;
        end
        FINISH: begin
            // the output is valid
            valid_out = 1'b1;
            lo = data_lo;
            hi = data_hi;
        end
        default: begin
            // nothing
        end
    endcase
end

endmodule
