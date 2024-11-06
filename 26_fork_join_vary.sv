// Code your testbench here
// or browse Examples


class process1;
  
  task run();
    #6;
    $display("Process 1 complete at %0t",$time);
  endtask
  
 
endclass
 
 
class process2;
  
  task run();
    #3; 
    $display("Process 2 complete at %0t",$time);
  endtask
  
 
endclass
 
 
module tb;
  
  process1 p1;
  process2 p2;
  
  initial begin
    p1 = new();
    p2 = new();
    
    fork //non-blocking
      p1.run();
      p2.run();
    join_none
    
     /*fork // non-blocking 
      p1.run();
      p2.run();
    join_any */
   
    /*fork //blocking type
      p1.run();
      p2.run();
    join
 */
    #6;
    //#8;
    
    $display("All processes completed at %0t",$time);
    
  end
  
  
  
  
  
  
endmodule