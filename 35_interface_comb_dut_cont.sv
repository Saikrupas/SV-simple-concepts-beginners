//*********DESIGN CODE*********

module mul (
  input [7:0] a, b,
  output [15:0] y
);
  
  assign y = a * b;
  
endmodule

//*******TESTBENCH CODE********

interface mul_intf();
  logic [7:0] a,b;
  logic [15:0] y;
endinterface

module tb;
  mul_intf vif();
  
  mul dut(vif.a, vif.b, vif.y); //implicit way 
  
  integer i;
  initial begin
    for(i = 0; i < 20; i++)begin
      vif.a = $urandom;
      vif.b = $urandom;
      #10;
    end
  end
  
  initial begin
    $dumpvars();
    $dumpfile("dump.vcd");
  end
  
  initial begin
    #300;
    $finish;
  end
  
endmodule