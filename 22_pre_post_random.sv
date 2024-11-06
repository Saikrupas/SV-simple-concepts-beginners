// Code your testbench here
// or browse Examples


class temp;
  randc bit [3:0] a;
  randc bit [7:0] b; 
             
   constraint a_constraint {a > 9;};
  constraint b_constraint {b > 10; b < 100;};
    
  function void pre_randomize(); 
    //b.rand_mode(0); // randomization switch 
    //a.rand_mode(0); //the randomization will fail for a particular variable
     
    a_constraint.constraint_mode(0); //if it it is enabled the constraint for the prarticular variable will not work. 
    endfunction
          
             
    function void post_randomize();
      $display("value of a after randomization a : %0d", a);
      $display("value of a after randomization b : %0d", b);
    endfunction
             
endclass
             
module tb;
  temp t;
  integer i;
  
  initial begin
    t = new();
    for(i = 0; i < 10; i++)begin
      assert (t.randomize())
        else
          $fatal("[GEN] : randomization failed");
    #10;
  end
  end
  
endmodule
      
      
