/*Assignment 2: Write a Generator and Driver code for the Module
Write a Generator and Driver code for the 4:1 Mux. 
The snapshot of the module is attached in the Instruction Tab. */


class transaction;
  randc bit [15:0] a,b,c,d;
  randc bit [1:0] sel;
  
  
  function void displaydata(string field);
    $display("%s : a = %0b, b = %0b c = %0b d = %0b, sel = %b,",field,a,b,c,d,sel);
  endfunction
  
endclass
 
 
 
 
class generator;
  transaction t;
  mailbox mbx;
  event done;
  integer i;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task main();
  for(i = 0; i < 4; i++)begin
   t = new();
   t.randomize();
   mbx.put(t);
$display("[GEN] :  Send Data to Driver");
    t.displaydata("[GEN]");
#1;
end
->done;
endtask
endclass
 
 
class driver;
mailbox mbx;
transaction t;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task main();
   forever begin
   t = new();
   mbx.get(t);
   $display("[DRV] : Rcvd Data from Generator");
     t.displaydata("[GEN]");
   #1;
end
endtask
 
 
endclass
 
 
 
 
 
module tb();
 
transaction t;
generator gen;
driver drv;
mailbox mbx;
 
initial begin
mbx = new();
gen = new(mbx);
drv = new(mbx);
 
fork
gen.main();
drv.main();
join_any
wait(gen.done.triggered);
end
 
 
endmodule
