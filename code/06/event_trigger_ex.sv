module event_trigger_ex;
event e;

initial begin
    fork
        begin
            #10;
            -> e;
        end
        begin
            wait(e.triggered);
            $display("@(%0t) e is triggered", $time);
        end
    join
end
endmodule
