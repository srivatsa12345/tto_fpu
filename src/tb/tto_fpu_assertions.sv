module tto_fpu_assertions(input logic clk, input logic rst_n, input logic [7:0]ui_in, input logic [7:0]uio_in, input logic [7:0]uio_oe, input logic [7:0]uio_out, input logic [7:0]uo_out);
    property check_reset;
		@(posedge clk) !rst_n |-> (uo_out==8'h00 && uio_out==8'h00 && uio_oe==8'h00);
	endproperty
	assert property(check_reset)
	else $error("Check reset failed");

	property check_busy_high;
	    @(posedge clk) disable iff(!rst_n)
	    (ui_in[2] && uo_out[3]) |=> uo_out[0];
	endproperty
	assert property(check_busy_high)
	else $error("Check busy high failed");

	property check_busy_low;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[1] |-> !uo_out[0];
	endproperty
	assert property(check_busy_low)
	else $error("Check busy low");
	
	property check_error_latch;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[1] && uo_out[2] && !ui_in[2] && uo_out[3] && !uo_out[0] |=> uo_out[1] && uo_out[2] ;
	endproperty
	assert property(check_error_latch)
	else $error("Check error latch failed");
	
	property check_error_done_simul;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[2] |-> uo_out[1];
	endproperty
	assert property(check_error_done_simul)
	else $error("Check error done simul");

	property check_start_clears_done_error;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[1] && uo_out[2] && ui_in[2] && uo_out[3] && !uo_out[0] |=> !uo_out[1] && !uo_out[2] ;
	endproperty
	assert property(check_start_clears_done_error)
	else $error("Check start clears done failed");

	property check_done_assertion_in_4_5_clk_cycles;
	    @(posedge clk) disable iff(!rst_n) 
		ui_in[2] && uo_out[3] |-> ##[4:5] uo_out[1];
	endproperty
		assert property(check_done_assertion_in_4_5_clk_cycles)
			else $error("Check done assertion in 4 5 clk cycles");

	property check_wr_ptr_increment;
	    @(posedge clk) disable iff(!rst_n)
	    $rose(ui_in[0]) && !uo_out[0] && !uo_out[3] |=> uo_out[7:4]==$past(uo_out[7:4]) +1;
	endproperty
	assert property(check_wr_ptr_increment)
	else $error("Check wr_ptr increment failed");
	
	property check_wr_ptr_hold;
	    @(posedge clk) disable iff(!rst_n)
	    $rose(ui_in[0]) && uo_out[0] |=> uo_out[7:4] ==$past(uo_out[7:4]);
	endproperty
	assert property(check_wr_ptr_hold)
	else $error("Check wr_ptr hold failed");

	property check_ready_assertion;
	    @(posedge clk) disable iff(!rst_n)
	    !uo_out[3] && uo_out[7:4]==4'd2 && $rose(ui_in[0]) |=> uo_out[3];
	endproperty
	assert property(check_ready_assertion)
	else $error("Check ready assertion failed");

	property check_ready_deassertion;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[3] && $rose(ui_in[0]) && !uo_out[0] |=> !uo_out[3];
	endproperty
	assert property(check_ready_deassertion)
	else $error("Check ready deassertion failed");

	property check_uio_oe;
	    @(posedge clk) disable iff(!rst_n)
	    ui_in[1] && !ui_in[0] && !uo_out[0] |-> uio_oe==8'hFF;
	endproperty
	assert property(check_uio_oe)
	else $error("Check uio_oe failed");

	property check_uio_oe_0;
	    @(posedge clk) disable iff(!rst_n)
	    !ui_in[1] |-> uio_oe==8'h00 ;
	endproperty
	assert property(check_uio_oe_0)
	else $error("Check uio_oe 0 failed");

	property check_uio_oe_when_error_done;
	    @(posedge clk) disable iff(!rst_n)
	    uo_out[2] && uo_out[1] && !ui_in[0] && ui_in[1] |=> uio_out==8'h00;
	endproperty
	assert property(check_uio_oe_when_error_done)
	else $error("Check uio_oe_when_error_done failed");
      
endmodule

	

	
	
		
	
		






	
