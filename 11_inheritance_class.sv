/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : inheritance_class
DATE        :  ---------
DESCRIPTION : inheritance in class

**********************************************************************************************/

// Code your testbench here
// or browse Examples

class parent;
  int x = 27;
endclass


class derived extends parent;
  //extends keyword is used to specify it is a derived class.
  int y = 88;
endclass

module tb;
 derived d1;
  
  initial begin
    d1 = new();
    $display("the value of x and y in the derived class are %0d and %0d respectively",d1.x,d1.y);
  end
  
  
endmodule
