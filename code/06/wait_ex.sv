module wait_ex;
logic a;

initial begin
    fork
        begin
            #10;
            a = 1;
        end
        begin
            wait(a);
            $display("@(%0t) a = %d", $time, a);
        end
    join
end
endmodule
