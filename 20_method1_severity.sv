// Code your testbench here
// or browse Examples

///////////////////////Method 1//////////////////////////////////////////



class temp;
  
 randc bit [3:0] a;
  
 // constraint a_constraint {a > 11;};
  constraint a_constraint {a > 11; a <11;}; //the randomization will fail
 
endclass
 
module tb;
  temp t;
  integer i;
  
  initial begin
    t = new();
    for(i = 0; i <10; i++) begin
      assert(t.randomize())
      //else $error("[GEN] : Randomization fails");
      else $fatal("[GEN] : Randomization fails");
      
      $display("Value of a :%0d",t.a);
      #10;
      
    end
    
  end
  
  
  
endmodule