//***************DESIGN CODE******************
module top(
  input [3:0] a,
  input [3:0] b,
  output [3:0] y
);
  
assign y = a & b;  
  
  
endmodule

////////////////////////////////////////////////////////////////////
 
interface top_intf();
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] y;
endinterface
 
 //****************TESTBENCH CODE***********************

 class transaction;
  bit [3:0] a;
  bit [3:0] b;
  bit [3:0] y;
 
endclass

class monitor;
  transaction t;
  mailbox mbx;
  
  
  virtual top_intf vif;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
    t.a = vif.a;
    t.b = vif.b;
    t.y = vif.y;
    mbx.put(t);
    $display("[MON] : data send to Scoreboard");
      #10;
    end
  endtask
 
endclass
 
/////////////////////////////////////////////////////////////////////////////
 
class scoreboard;
  transaction t;
  mailbox mbx;
  bit [3:0] temp;
  
  function new(mailbox mbx);
    this.mbx = mbx;
    endfunction
  
  task run();
    t = new();
    forever begin
      mbx.get(t);
      temp = t.a & t.b;
      $display("[SCO] : a : %b and b : %b gives temp : %b and y : %b ",t.a, t.b, temp, t.y);
       #10;
    end
  endtask
  
endclass
 
//////////////////////////////////////////////////////////////////////////// 
 
module tb;
  
  top_intf vif();
  monitor mon;
  scoreboard sco;
  mailbox msmbx;
  int i=0;
  int count=0;
  
  
  top dut (.a(vif.a), .b(vif.b), .y(vif.y));
  
  initial begin
    for(i=0; i<25; i++)begin
    vif.a = $urandom();
    vif.b = $urandom();
      count++;  //////////////////keep track of iteration count to hold simulation
      $display("%0d,count");
      #10;
    end
  end
  
  initial begin
    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx);
    
    mon.vif = vif;
  end
    
  initial begin
    fork 
      mon.run();  
      sco.run();
    join_none
  
     
    wait(count == 25);   //////hold simulation for 25 iteration and then call finish
    $finish();
  
  end
  
  initial begin
   $dumpfile("dump.vcd");
  $dumpvars;
  end
  

  
endmodule
