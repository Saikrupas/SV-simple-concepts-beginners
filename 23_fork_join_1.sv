// Code your testbench here
// or browse Examples


class process1;
  
  task run();
    #3;
    $display("Process 1 complete at %0t",$time);
  endtask
  
 
endclass
 
 
class process2;
  
  task run();
    #5; 
    $display("Process 2 complete at %0t",$time);
  endtask
  
 
endclass
 
 
module tb;
  
  process1 p1;
  process2 p2;
  
  initial begin
    p1 = new();
    p2 = new();

    fork   // all process starts execution at time 0 but completion of each process depends on the delay. 
      p1.run();
      p2.run();
    join
 
    #2;
    $display("All process completed at %0t",$time); // wait till all the process inside fork_join gets completed.
    
  end

endmodule