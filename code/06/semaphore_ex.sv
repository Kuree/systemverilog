module semaphore_ex;

semaphore s;

initial begin
    s = new(10);
    fork
        begin
            s.get(5);
            #10 s.put(5);
            $display("Thread 1 finished @ %0t", $time);
        end
        begin
            s.get(5);
            #20 s.put(5);
            $display("Thread 2 finished @ %0t", $time);
        end
        begin
            #1;
            s.get(10);
            $display("Thread 3 finished @ %0t", $time);
        end
    join
end

endmodule
