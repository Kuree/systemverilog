class mult_generator;

// since we haven't discussed constrained random yet,
// we will use the system default random generator
// we will revisit this once we discuss constrained random

// communication channel to the driver
mailbox gen2driver;
// number of transaction to generate
int num_xact;
// the packet
GeneratorXact xact;

function new(mailbox mb, int num);
    this.gen2driver = mb;
    this.num_xact = num;
endfunction

// entry point of this generator
task main();
    repeat (this.num_xact) begin
        xact = new();
        xact.a = $random();
        xact.b = $random();
        this.gen2driver.put(xact);
    end
endtask

endclass