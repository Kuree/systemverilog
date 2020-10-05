`ifndef COUNT_ONE_FSM_PKG
`define COUNT_ONE_FSM_PKG

package count_one_fsm_pkg;

typedef enum logic[1:0] {
    moore_state0,
    moore_state1,
    moore_state2
} moore_state_t;

typedef enum logic {
    mealy_state0,
    mealy_state1
} mealy_state_t;

endpackage
`endif // COUNT_ONE_FSM_PKG