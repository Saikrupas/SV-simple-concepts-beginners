// Code your testbench here
// or browse Examples

module tb;
  
  event a; //create a event
  
  
  initial begin
    fork 
      begin //process 1
       #20;
        -> a; // trigger an event
      
      end
      
      begin //process 2
   
       // @(a); // @(event) opertor blocks the current process until is triggered. (blocking)
        wait(a.triggered); //wait() construct for the event to be triggered (unblocking)
        $display("event triggered at time : %0t",$time);
      end
    join
    
  end
  
endmodule

/*
EVENTS- communication mechanism through which different process 
convey some information between differnt process.
*/

