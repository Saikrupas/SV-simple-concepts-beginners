/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_in_sv_3
DATE        :  ---------
DESCRIPTION :  what happens if new() method is not invoved.

****************************************************************************************************/



// Code your testbench here
// or browse Examples
​
class first;
  bit [2:0] x = 3'b101;
endclass
  
module tb;
   first f1;
  
  initial begin
     f1 = new(); 
    //f1 = new(); //if not invoked --error (null pointer access)
    $display("value of x : %b",f1.x);
  end
endmodule
​
/* ERROR:-
The object at dereference depth 0 is being used before it was 
  constructed/allocated.
  Please make sure that the object is allocated before using it. 
*/ 