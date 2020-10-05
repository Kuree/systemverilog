module three_block_fsm_moore (
    input logic clk,
    input logic rst_n,
    input logic in,
    output logic out
);

import count_one_fsm_pkg::*;

moore_state_t state, next_state;

// block 1: state <- next_state
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= moore_state0;
    end
    else begin
        state <= next_state;
    end
end

// block 2: determine next_state
always_comb begin
    case (next_state)
        moore_state0: begin
            if (in) next_state = moore_state1;
            else next_state = moore_state0;
        end
        moore_state1: begin
            if (in) next_state = moore_state2;
            else next_state = moore_state0;
        end
        moore_state2: begin
            if (in) next_state = moore_state2;
            else next_state = moore_state0;
        end
        default: begin
            next_state = moore_state0;
        end
    endcase    
end

// block 3: determine output based on state
always_comb begin
    case (state)
        moore_state0: out = 0;
        moore_state1: out = 0;
        moore_state2: out = 1;
        default: out = 0; 
    endcase
end

endmodule: three_block_fsm_moore
