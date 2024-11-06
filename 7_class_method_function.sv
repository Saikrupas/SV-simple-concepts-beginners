/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_method_function
DATE        :  ---------
DESCRIPTION :  how to use method in class (function)

****************************************************************************************************/
//how to use method in class  (function) 

// Code your testbench here
// or browse Examples

class temp;
  bit [7:0] data = 8'b1011_1111;
  
 function void run(); //if function is not returning anything to the user (void function)
    //If the function returns a value then specify the datatype  and the size of data.
    $display("value of data member : %0d", data);
   endfunction 
  
  /*task run();
    $display("value of data member : %0d",data);
  endtask*/
endclass

module tb;
  temp t;
  
  initial begin
    t = new();
    t.run();
  end
endmodule