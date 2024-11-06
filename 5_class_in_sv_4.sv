/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_in_sv_4
DATE        :  ---------
DESCRIPTION :  writing data to the data member of the class.

****************************************************************************************************/

// Code your testbench here
// or browse Examples

class temp;
  bit[1:0] x = 2'b01;
endclass

module tb;
  temp t;
  
  initial begin
    t = new();
    //$display("the initial value of x is : %0b",t.x);
    $display("the initial value of x is : %b",t.x);
    t.x = 2'b11;
    //$display("the final value of x is : %0b",t.x);
    $display("the final value of x is : %b",t.x);
  end
endmodule