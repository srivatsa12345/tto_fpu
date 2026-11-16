module qspi_top;
    import uvm_pkg::*;
    import tto_fpu_package::*;

    bit clk;
    bit rst_n;

    tto_fpu_if intrf(.clk(clk),.rst_n(rst_n));

    //DUT
    initial begin
        uvm_config_db#(virtual tto_fpu_if)::set(null,"*","Virtual Interface",intrf);
        run_test();
    end

    initial begin
        clk=1'b0;
        forever #5 clk=~clk;
    end

    initial begin
        rst_n=1'b0;
        repeat(4) @(posedge clk);
        #1 rst_n=1'b1;
    end
endmodule
 
