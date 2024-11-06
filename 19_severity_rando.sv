// Code your testbench here
// or browse Examples

//SEVERITY LEVEL SYSTEM CALLS


module tb;
  bit [1:0] a =2'b11;
  bit [1:0] b = 2'b00;
  
  initial begin
    assert (a == b) 
    else begin
      //$display("a and b are not equal");
      //$info("a and b are not equal");
      //$warning("a and b are not equal");
      //$error("a and b are not equal"); //---->still simulation will continue
      $fatal("a and b are not equal"); //----> will call $finish and terminate the simulation
        $display("value of a : %0d", a);
        $display("value of b : %0d", b);
    end
  end
  
  
endmodule 




