/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : data_hiding_class
DATE        :  ---------
DESCRIPTION : data hiding in class

**********************************************************************************************/

// Code your testbench here
// or browse Examples
class first;
  // int x;
 //local int x; //this indicates that the scope of x is visible only to this class, x will not be visible outside this process or this class.
  local int x = 27; //initializing the value of x
  /*
  
  if the data member is important to a class and don't want other process to overwrite this data, we can control the access by using the local or protected keyword.
  
  so this is how you can control the scope of a data member inside a class.
  */
  
  function int give();
    return x;
  endfunction
endclass

module tb;
  
 first f1;
  int value;
  
  initial begin 
    f1 = new();
    value = f1.give();
    //f1.x = 33; // we will be getting an error.
    //error:- Local member 'x' of class 'first' is not visible to scope 'tb'.
    
    //$display("the value written is  %0d",f1.x);
    $display("the value written is  %0d",value);
  end
endmodule

/*

NOTE:-
suppose you want to access the value of that data (local or protected) data member(that data is important for us).
we know that function can have access for this data member if that is inside the class.

so by utilizing a function we can actually can get access to this data.

*/