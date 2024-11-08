//*******DESIGN CODE ******
//combinational circuit

module mux(
  input [3:0] a, b, c, d,
  input [1:0] sel,
  output reg [3:0] y);
  
  always@(*) begin
    case(sel)
      2'b00: y = a;
      2'b01: y = b;
      2'b10: y = c;
      2'b11: y = d;
      default: y = b;
    endcase
    
  end
  
endmodule

//*********TESTBENCH CODE **********

interface mux_intf();
  logic [3:0] a,b,c,d;
  logic [1:0] sel;
  logic [3:0] y;
endinterface

module tb;
  mux_intf vif(); 
  
  mux dut (.a(vif.a), .b(vif.b), .c(vif.c), .d(vif.d), .sel(vif.sel), .y(vif.y)); //explicit way
  
 // mux dut(a,b,c,d,sel,y); //implicit way
  
  initial begin
    vif.a = 0;
    vif.b = 0;
    vif.c = 0;
    vif.d = 0;
    vif.sel = 0;
  end
  
  always #5 vif.a = ~vif.a; //time period is 10ns----half period 10/2 =5ns
  always #10 vif.b = ~vif.b;
  always #15 vif.c = ~vif.c;
  always #20 vif.d = ~vif.d;
  
  integer i;
  initial begin
    for(i=0; i<25; i++) begin
      vif.sel = $urandom;
      #10;
    end
  end
    
    
  initial begin
   #300;
    $finish;
  end
  
  initial begin 
    $dumpvars;
    $dumpfile("dump.vcd");
  end
  
endmodule
