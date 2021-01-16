module fork_join_ex;
    initial begin
        fork
            #10 $display("Thread 1 finished at %t", $time);
            begin
                // thread 2
                #5 $display("Thread 2 finished at %t", $time);
            end
            #20 $display("Thread 3 finished at %t", $time);
        join
    end
endmodule
