interface tto_fpu_if (input logic clk);

    logic rst_n;
    logic [7:0] ui_in, uio_in;
    logic [7:0] uio_oe, uio_out, uo_out;

    clocking drv_cb @(posedge clk);
        default output #5;
        output ui_in, uio_in;
    endclocking

    clocking rst_drv_cb @(negedge clk);
    endclocking
    
    clocking in_mon_cb @(posedge clk);
        default input #1;
        input ui_in, uio_in, uo_out;
    endclocking

    clocking out_mon_cb @(posedge clk);
        default input #1;
        input uio_oe, uio_out, uo_out;
    endclocking

    modport DRV (clocking drv_cb, input rst_n);
    modport RST_DRV (clocking rst_drv_cb, output rst_n);
    modport IN_MON (clocking in_mon_cb, input rst_n);
    modport OUT_MON (clocking out_mon_cb);
        
endinterface

 
