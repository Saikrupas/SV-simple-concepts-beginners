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
   
    fork   //  the procsess with least delay will be executed then 
    //the rest of the process will be executed (non-blocking).
      p1.run(); //--->2nd
      p2.run(); //--->3rd
    join_none
 
    #1;  //--->1st
    $display("All process completed at %0t",$time); 
    
  end

endmodule