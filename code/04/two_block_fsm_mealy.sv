module two_block_fsm_mealy (
    input logic clk,
    input logic rst_n,
    input logic in,
    output logic out
);

import count_one_fsm_pkg::*;

mealy_state_t state, next_state;

// block 1: state <- next_state
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= mealy_state0;
    end
    else begin
        state <= next_state;
    end
end

// block 2: determine next_state and output
always_comb begin
    case (state)
        mealy_state0: begin
            if (in) begin
                next_state = mealy_state1;
                out = 0;
            end
            else begin
                next_state = mealy_state0;
                out = 0;
            end
        end
        mealy_state1: begin
            if (in) begin
                next_state = mealy_state1;
                out = 1;
            end
            else begin
                next_state = mealy_state0;
                out = 0;
            end
        end
    endcase
end

endmodule: two_block_fsm_mealy