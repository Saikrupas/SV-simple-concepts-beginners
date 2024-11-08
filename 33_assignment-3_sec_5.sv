// Code your testbench here
// or browse Examples

/*
Assignment 3: Create 20 random Stimulus for the Interface discussed in previous example

We discussed how we can create an Interface in the previous example, Let us use the same interface and try to generate 20 random stimuli for the same inputs.
*/


interface add_intf();
  logic [7:0] a;
  logic [7:0] b;
  logic [8:0] sum;
endinterface
 
 
module tb;
  
  
  add_intf vif();
  
  initial begin
    for(int i=0; i<20; i++) begin
    vif.a = $urandom;
    vif.b = $urandom;
    $display("Value of a :%0d and b : %0d",vif.a, vif.b);
      #1;
    end
  end
  
endmodule