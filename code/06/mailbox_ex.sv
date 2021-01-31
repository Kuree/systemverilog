module mailbox_ex;

mailbox mb;

initial begin
    mb = new(2);

    fork
        begin
            for (int i = 0; i < 4; i++) begin
                #10 mb.put(i);
                $display("[0]: @(%0t) put in value: %0d", $time, i);
            end
        end

        begin
            for (int i = 0; i < 2; i++) begin
                int value;
                mb.get(value);
                $display("[1]: @(%0t) get value: %0d", $time, value);
            end
        end
        begin
            for (int i = 0; i < 2; i++) begin
                int value;
                automatic int attempt = 0;
                while (mb.try_get(value) <= 0) begin
                    #1;
                    attempt++;
                end
                $display("[2]: @(%0t) get value: %0d after %0d attempts", $time, value, attempt);
            end
        end
    join
end
endmodule
