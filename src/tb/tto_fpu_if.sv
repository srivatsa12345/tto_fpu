interface tto_fpu_if (input logic clk);

    logic rst_n;
    logic [7:0] ui_in, uio_in;
    logic [7:0] uio_oe, uio_out, uo_out;

    clocking drv_cb @(posedge clk);
        default input #2 output #2;
        output ui_in, uio_in;
        input rst_n;
    endclocking

    clocking rst_drv_cb @(posedge clk);
        default output #1;
        output rst_n, ui_in, uio_in;
    endclocking
    
    clocking in_mon_cb @(posedge clk);
        default input #1;
        input rst_n, ui_in, uio_in;
    endclocking

    clocking out_mon_cb @(posedge clk);
        default input #1;
        input uio_oe, uio_out, uo_out;
    endclocking

    modport DRV (clocking drv_cb);
    modport RST_DRV (clocking rst_drv_cb);
    modport IN_MON (clocking in_mon_cb);
    modport OUT_MON (clocking out_mon_cb);
        
endinterface
 
