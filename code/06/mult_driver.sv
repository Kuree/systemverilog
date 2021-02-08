`ifndef MULT_DRIVER
`define MULT_DRIVER

class mult_driver;

mailbox gen2driver;
// virtual interface handle
virtual mult_io_interface.driver driver;

GeneratorXact xact;

function new(mailbox gen2driver, virtual mult_io_interface.driver driver);
    this.gen2driver = gen2driver;
    this.driver = driver;
endfunction

task reset();
    // reset the driver interface
    wait (!driver.rst_n);
    driver.a = 0;
    driver.b = 0;
    driver.valid_in = 0;
    driver.ready_in = 0;
    wait(driver.rst_n);
endtask

// entry point
task main();
    // loop forever
    // we are always ready to receive data
    driver.ready_in = 1'b1;
    forever begin
        this.gen2driver.get(xact);
        // drive the bus. need to make sure that the dut is ready
        // block until we have successfully put one transaction in
        while (1) begin
            @(posedge driver.clk);
            if (driver.ready_out) begin
                // dut is ready
                driver.a = xact.a;
                driver.b = xact.b;
                driver.valid_in = 1'b1;
                break;
            end
            else begin
                driver.valid_in = 1'b0;
            end
        end
    end
endtask

endclass

`endif // MULT_DRIVER