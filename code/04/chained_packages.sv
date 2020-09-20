package def1_pkg;
    typedef enum logic[1:0] {ADD, SUB, MULT, DIV} alu_opcode_t;
endpackage: def1_pkg

package def2_pkg;
    // import alu_opcode_t from def1_pkg
    import def1_pkg::alu_opcode_t;
    // define a new struct that include alu_opcode_t
    typedef struct {
        alu_opcode_t alu_opcode;
        logic[7:0] addr;
    } opcode_t;
endpackage: def2_pkg

module top;
    // alu_opcode_t is NOT accessible from def2_pkg
    // the next line is ILLEGAL
    // import def2_pkg::alu_opcode_t;
    import def2_pkg::*;

    opcode_t opcode;

endmodule: top
