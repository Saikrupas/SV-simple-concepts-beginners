// Code your testbench here
// or browse Examples

interface add_intf();
  logic [7:0] a;
  logic [7:0] b;
  logic [8:0] sum;
endinterface
 

module tb;
  add_intf vif(); //instace of an interface for making it usable inside class.
  
  initial begin
    vif.a = $urandom;
    vif.b = $urandom;
    $display("##### value of a : %0d, value of b : %0d #####",vif.a,vif.b);
  end
  
  
endmodule