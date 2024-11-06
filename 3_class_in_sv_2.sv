/***************************************************************************************************

NAME        :  Saikrupas
FILENAME    : class_in_sv_2
DATE        :  ---------
DESCRIPTION :  how to reuse a class inside a module 

****************************************************************************************************/


// how to reuse any class 

// Code your testbench here
// or browse Examples

class temp; //class is the fundamentsl entity in SV.
  //data members or properties 
  bit [3:0] a = 4'b1101;
  //methods or task and functions
endclass

module tb;
 temp t ; //create instance of class or handler for the class
  
  initial begin
    
    t = new(); // adding new() method or constructor to class (creating an object) --> this is were we get a valid pointer so it can be utilized.
    
    $display("value of a :: %b",t.a);  //%0b --> 0 value is removed, %b--> can see entire value
    
  end
  
  
endmodule

/*
NOTE:-
class temp; can be used until and unless two steps are followed :-

1) creating a handler for the class (temp t).(variable of class data_type or class handle)
2)  adding new() method or constructor to the class (this is were a valid pointer is assigned to the handle) (memory is allotted for a variable or object.)
(object is created). 
*/
