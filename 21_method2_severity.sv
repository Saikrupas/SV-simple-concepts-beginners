// Code your testbench here
// or browse Examples


///////////////////////Method 2/////////////////////////////////



class temp;
  
 randc bit [3:0] a;
  
  //constraint a_constraint {a > 11;};
    constraint a_constraint {a > 11; a <11;}; //Internal constraint
    
 
endclass
 
module tb;
  temp t;
  integer i;
  
  initial begin
    t = new();
    for(i = 0; i <10; i++) begin
      if(!t.randomize() ) begin //if randomization fails  enter begin end block
      $fatal("[GEN] : Randomization fails");
      end
      $display("Value of a :%0d",t.a); 
      #10;
      
    end
    
  end
  
  
  
endmodule
