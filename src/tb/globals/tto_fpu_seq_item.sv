`include "defines.svh"
class qspi_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(qspi_seq_item)
  
  function new(string name="qspi_seq_item");
    super.new(name);
  endfunction
  
  bit PRESETn;
  bit PSEL;
  bit PENABLE;
  rand bit PWRITE;
  rand bit [`AW-1:0]PADDR;
  rand bit [`DW-1:0]PWDATA;
  logic PREADY;
  logic[`DW-1:0]PRDATA;
  logic PSLVERR;
  logic spi_sclk;
  logic cs_n;
  rand logic[3:0]io;
  
endclass
