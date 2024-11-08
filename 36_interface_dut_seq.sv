//*******DESIGN CODE*****

module counter(
  input clk,rst,mode_sel,
  output reg [3:0] dout
);
  
  always@(posedge clk) 
    begin
      if(rst == 1'b1)//synchronous rst
        dout <= 4'b0000;
      else begin
        if(mode_sel == 1'b1) //up 
          dout <= dout + 1;
        else 
          dout <= dout - 1;
          end
    end
  
  
endmodule

//*********TESTBENCH CODE**********


interface counter_intf();
  logic clk, rst, mode_sel;
  logic [3:0] dout;
endinterface

module tb;
  counter_intf vif();
  
  counter DUT(vif.clk, vif.rst, vif.mode_sel, vif.dout);
  
  initial begin 
    vif.clk = 0;
    vif.rst = 0;
    vif.mode_sel = 0;
  end
  
  always #5 vif.clk = ~vif.clk;
  
  initial begin
    vif.rst = 1;
    #30;
    vif.rst = 0;
    #200;
    vif.rst = 1;
    #100;
    vif.rst = 0;
  end
  
  integer i;
  initial begin
    for(i=0;i<50;i++)begin
      vif.mode_sel = $urandom;
      @(posedge vif.clk);
    end
  end
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end
  
  initial begin
    #500;
    $finish;
  end
endmodule