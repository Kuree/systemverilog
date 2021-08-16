module top;

import dog::*;

Dog dog;

initial begin
    dog = new();
    dog.run(2);
    dog.run(40);
    $display("distance: %d", dog.distance());
end

final begin
    Dog::final_();
end

endmodule
