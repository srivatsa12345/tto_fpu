`include "uvm_macros.svh"
module tto_fpu_top;
    import uvm_pkg::*;
    import tto_fpu_package::*;

    bit clk;

    tt_um_project_fpu #(.EXP_W(`EXP_W), .MAN_W(`MAN_W)) m1 (.clk(clk), .rst_n(intrf.rst_n), .ui_in(intrf.ui_in), .uio_in(intrf.uio_in), .uio_out(intrf.uio_out), .uio_oe(intrf.uio_oe), .ena(1), .uo_out(intrf.uo_out));
    tto_fpu_if intrf(.clk(clk));
    
    initial begin
        uvm_config_db#(virtual tto_fpu_if)::set(null,"*","Virtual Interface",intrf);
        run_test();
    end

    initial begin
        clk=1'b0;
        forever #20 clk=~clk;
    end

endmodule
 
