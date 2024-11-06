/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : rand_randc
DATE        :  ---------
DESCRIPTION : difference between rand and randc modifiers

**********************************************************************************************/




// Code your testbench here
// or browse Examples

// Code your testbench here
// or browse Examples

class temp;
  
  rand  bit [3:0] d1; 
randc  bit [3:0] d2;

  
endclass
 
 
module tb;
  
  temp t;
  integer i;
  
  initial begin
    t = new();
    //for( i = 0; i<15; i++)begin
    for( i = 0; i<20; i++)begin
    t.randomize();
      $display("Value d1 : %0d and d2: %0d ",t.d1,t.d2);  
    #10;
    end
  end
endmodule

/* 
NOTE:-

--> so to have a clear understanding between rand and randc.
rand--> the values generated for each iteration can be unique values, 
the pseudo random generator tries best to generate random values 
which have a unique probability,but Rand keyword we do get a frequent repetation of values.


randc--->randc keyword don't have any repeation of values until we used
 all the values that the data member can generate.

--->in case of RAM we should get a repetation of address using random generator facility, 
then only we can verify the data that we have written on to a memory whether it is matching 
to the data that we have read from the same address of the memory.
*/