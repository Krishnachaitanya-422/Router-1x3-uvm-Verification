module top;

import router_test_pkg::*;
import uvm_pkg::*;

bit clock;

always 
#10 clock=!clock;

initial
begin
run_test("router_base_test");
end

endmodule  