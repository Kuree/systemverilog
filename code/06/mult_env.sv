class environment;

// instances
mult_generator gen;
mult_driver driver;
mult_monitor monitor;
mult_scoreboard scoreboard;

// mailboxes
mailbox gen2driver;
mailbox monitor2score;


function new(int num_xact, virtual mult_io_interface io);
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