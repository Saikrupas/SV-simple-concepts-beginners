/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : internal_const
DATE        :  ---------
DESCRIPTION : internal constraint

**********************************************************************************************/



// Code your testbench here
// or browse Examples
///////////////////////////Internal Constraint Example //////////////////////////////



class temp;
randc bit [3:0] d;
  
constraint d_constraint {d > 10; d < 15;}; 
  
endclass
 
 
 
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
