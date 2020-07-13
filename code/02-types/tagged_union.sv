// run with vcs:
// vcs -sverilog tagged_union.sv -lca
// tested with vcs 2019.06
module TaggedUnionExample;

typedef logic[6:0] opcode_t;
typedef logic[4:0] reg_t;
typedef logic[2:0] funct3_t;

typedef struct packed {
    logic [6:0] func7;
    reg_t       rs2;
    reg_t       rs1;
    funct3_t    funct3;
    reg_t       rd;
    opcode_t    opcode;
} r_inst_t;

typedef struct packed {
    logic [11:0] imm;
    reg_t        rs1;
    funct3_t     func3;
    reg_t        rs2;
    opcode_t     opcode;
} i_inst_t;

typedef struct packed {
    logic [6:0] imm1;
    reg_t       rs2;
    reg_t       rs1;
    funct3_t    funct3;
    logic [5:0] imm2;
    opcode_t    opcode;
} s_inst_t;

typedef struct packed {
    logic [19:0] imm;
    reg_t        rd;
    opcode_t     opcode;
} u_inst_t;

typedef union tagged packed {
    r_inst_t r_inst;
    i_inst_t i_inst;
    s_inst_t s_inst;
    u_inst_t u_inst;
} risc_v_inst_t;

initial begin
    risc_v_inst_t i1;

    i1 = tagged i_inst '{1, 2, 3, 4, 5};
    assert (i1.i_inst.opcode == 5);

    // the following code result an error (runtime error in VCS)
    // i1.s_inst.opcode = 5;

    // siwtch tag
    i1 = tagged u_inst '{1, 2, 3};
    assert (i1.u_inst.opcode == 3);
end

endmodule
