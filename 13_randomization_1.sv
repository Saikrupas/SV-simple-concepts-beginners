/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : randomization_1
DATE        :  ---------
DESCRIPTION : randomization of the variable

**********************************************************************************************/


// Code your testbench here
// or browse Examples

class temp;
  rand  bit [3:0] d1;  //rand is a modifier to generate random number.
  rand bit [3:0] d2; 
  rand  bit [31:0] d3; 
  
  //for the data members were you want to achieve a generation of a random numbers, you need to add a modifier, there are two modifiers available rand or randc.
endclass


module tb;
  temp t; //handle creation
  //want to see 20 random nos. for the data members that are present in the calss temp
  integer i; 
  
  initial begin
    t = new(); //constructor to the handler, creating object.
    
    for(i=0; i<20; i++)begin
    t.randomize();  //adding randomization method
      $display("##### value of d1 : %0d ",t.d1);
      $display("##### value of d2 : %0d ",t.d2);
      $display("##### value of d3 : %0d ",t.d3);
     #10;
    end
  end
  
endmodule