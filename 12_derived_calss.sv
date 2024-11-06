/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : derived_class
DATE        :  ---------
DESCRIPTION : derived class try to access data member of parent calss

**********************************************************************************************/

// Code your testbench here
// or browse Examples

class parent;
  local int x = 22;
endclass

class derived extends parent;
  int y = 78;
endclass

module tb();
 //derived d1;
  
  initial begin
    derived d1;
    d1 = new();
    
    $display("the vaue of x = %0d",d1.x);
             /*
             Error-[SV-ICVA-L] Illegal class variable access
testbench.sv, 18
  Local member 'x' of class 'parent' is not visible to scope 'tb'.
  Please make sure that the above member is accessed only from its own class 
  methods as it is declared as local.
             */
    
    $display("the vaue of y = %0d",d1.y);
  end
endmodule
