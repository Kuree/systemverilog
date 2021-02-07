class mult_monitor;

mailbox monitor2score;
ScoreBoardXact xact;
// virtual interface handle
virtual mult_io_interface.monitor monitor;


function new(mailbox mb, virtual mult_io_interface.monitor monitor);
    this.monitor2score = mb;
    this.monitor = monitor;
endfunction


// entry point
task main();
    forever begin
        xact = new();
        @(posedge monitor.clk);
        wait (monitor.valid_in);
        // grab signals from the bus
        xact.a = monitor.a;
        xact.b = monitor.b;
        // wait until valid out is high
        wait (monitor.valid_out);
        // grab the output from the bus
        xact.lo = monitor.lo;
        xact.hi = monitor.hi;
        // put it into the mailbox
        monitor2score.put(xact);
    end
endtask 

endclass