module one_block_fsm_mealy (
    input logic clk,
    input logic rst_n,
    input logic in,
    output logic out
);

import count_one_fsm_pkg::*;

mealy_state_t state;

// one block: state update, next state, and output are in the same always_ff block
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= mealy_state0;
    end
    else begin
        case (state)
            mealy_state0: begin
                if (in) begin
                    state <= mealy_state1;
                    out <= 0;
                end
                else begin
                    state <= mealy_state0;
                    out <= 0;
                end
            end
            mealy_state1: begin
                if (in) begin
                    state <= mealy_state1;
                    out <= 1;
                end
                else begin
                    state <= mealy_state0;
                    out <= 0;
                end
            end
            default: begin
                state <= mealy_state0;
                out <= 0;
            end
        endcase
    end
end

endmodule: one_block_fsm_mealy