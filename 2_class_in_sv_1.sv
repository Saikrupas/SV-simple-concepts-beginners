/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_in_sv_1
DATE        :  ---------
DESCRIPTION :  TB in verilog using module instantiation 

****************************************************************************************************/
// Code your design here

module and2 (
  input  [1:0] a,b,
  output [1:0] y
);
  
  assign y = a & b;
  
endmodule

// Code your testbench here
// or browse Examples

module tb;
  reg  [1:0] a,b;
  wire [1:0] y;
  
  and2 DUT(a,b,y);
  //we are trying to use module inside the testbench using port mapping.
  //this is basically a structural modelling style. (this is how we are creating an instance of a module if we want to resue it.)
  
  
  initial begin
     a = 1;
     b = 1;
    #10;
    $display("value of a :%b, b :%b and y :%b", a,b,y); 
    //%0b --> 0 value is removed , %b --> 0 value is appended. 
  end
  
endmodule