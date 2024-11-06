/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : external_const
DATE        :  ---------
DESCRIPTION : external constraint

**********************************************************************************************/


// Code your testbench here
// or browse Examples
//////////////////////////////External Constraint Example/////////////////////



class temp;
  randc bit [3:0] d;
  
  extern constraint d_constraint;
  
endclass
 
 
constraint temp::d_constraint {d > 10; d < 15;};  //:: --> scope operator , it signifies to the compiler
//that the constraints are defined outside the class.
 
module tb;
  
  temp t;
  integer i;
  
  initial begin
    t = new();
    for(i =0; i<5;i++) begin
      t.randomize();
      $display("value of d:%0d",t.d);
       #10;
    end
  end
  
   
endmodule
