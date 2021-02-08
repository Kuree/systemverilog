`include "mult_io_interface.sv"
`include "mult_generator.sv"
`include "mult_driver.sv"
`include "mult_monitor.sv"
`include "mult_scoreboard.sv"

class mult_env;

// instances
mult_generator gen;
mult_driver driver;
mult_monitor monitor;
mult_scoreboard scoreboard;

// mailboxes
mailbox gen2driver;
mailbox monitor2score;


function new(int num_xact, virtual mult_io_interface io);
    // initial mail box first
    this.gen2driver = new();
    this.monitor2score = new();
    this.gen = new(gen2driver, num_xact);
    this.driver = new(gen2driver, io.driver);
    this.monitor = new(monitor2score, io.monitor);
    this.scoreboard = new(monitor2score);
endfunction

task reset();
    this.driver.reset();
endtask

task test();
    fork
        gen.main();
        driver.main();
        monitor.main();
        scoreboard.main();
    join_any
endtask

task finish();
    wait(gen.num_xact == scoreboard.num_xact);
endtask

task run();
    reset();
    test();
    finish();
    $finish();
endtask

endclass