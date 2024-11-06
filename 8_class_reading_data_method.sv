/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_reading_data_method
DATE        :  ---------
DESCRIPTION :  reading data from a method (function) 

****************************************************************************************************/

//reading data from a method (function)
// Code your testbench here
// or browse Examples

class temp;
  
  function bit [8:0] add (input bit [7:0] a,input bit [7:0] b); //return type of this method is 9 bits .
  return a + b;
  endfunction
  
  
endclass
 
module tb;
  
  temp t;
  bit [8:0] result;
  
  initial begin
    t = new();
    result = t.add(8'h12 , 8'h23);
    #10;
    $display("Result : %0d",result);
  end
 endmodule