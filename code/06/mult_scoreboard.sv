`ifndef MULT_SCOREBOARD
`define MULT_SCOREBOARD

class mult_scoreboard;

mailbox monitor2score;
int num_xact;
ScoreBoardXact xact;

logic[31:0] lo, hi;

function new(mailbox mb);
    this.monitor2score = mb;
    this.num_xact = 0;
endfunction


task main();
    forever begin
        monitor2score.get(xact);
        // assertion part
        // simplified
        this.num_xact++;
        {hi, lo} = xact.a * xact.b;
        assert (hi == xact.hi);
        assert (lo == xact.lo);
    end
endtask 

endclass

`endif // MULT_SCOREBOARD