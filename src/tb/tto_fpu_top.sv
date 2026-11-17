module tto_fpu_top;
    import uvm_pkg::*;
    import tto_fpu_package::*;

    bit clk;

    tto_fpu_if intrf(.clk(clk));

    //DUT
    initial begin
        uvm_config_db#(virtual tto_fpu_if)::set(null,"*","Virtual Interface",intrf);
        run_test();
    end

    initial begin
        clk=1'b0;
        forever #20 clk=~clk;
    end

endmodule
 
