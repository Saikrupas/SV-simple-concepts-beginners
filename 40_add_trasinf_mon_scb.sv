//***********DESIGN CODE*****************

module top(
  input  [3:0] a,b,
  output [3:0] y
);
  
  assign y = a & b;
  
endmodule

//***************TESTBENCH CODE***********

class transaction;
  bit [3:0] a;
  bit [3:0] b;
  bit [3:0] y;
endclass

       
//////////////////////////////////////////////////////////////////////////       
interface top_intf();
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] y;
endinterface

//////////////////////////////////////////////////////////////////////////////
       
       
class monitor;
  transaction t; //data container
  mailbox mbx;
  virtual top_intf vif;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    t.a = vif.a;
    t.b = vif.b;
    t.y = vif.y;
    
    mbx.put(t);
    $display("[MON] : data sent to scoreboard");
    #10;
  endtask
endclass
       
       
//////////////////////////////////////////////////////////////////////////////
       
       
class scoreboard;
  mailbox mbx;
  transaction t; //data container
  bit [3:0] temp; // for comparison
  
   function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      mbx.get(t);
      temp = t.a & t.b;
      if(t.y == temp)begin
        $display("[SCB] : TEST PASSED");
        $display("[SCB] : a : %b, b : %b gives temp : %b and y : %b", t.a,t.b,temp,t.y);
      end
      else begin
        $display("[SCB] : TEST FAILED");
      end
      #10;
    end
  endtask
endclass
    
 ////////////////////////////////////////////////////////////////////////////
    
    module tb;
      top_intf vif();
      monitor mon;
      scoreboard scb;
      mailbox msmbx;
     
      
      top dut(.a(vif.a), .b(vif.b), .y(vif.y));
      
      initial begin 
        vif.a = $random;
        vif.b = $random;
      end
      
      initial begin
        msmbx = new();
        mon = new(msmbx);
        scb = new(msmbx);
        mon.vif = vif;
        
        fork
          mon.run();
          scb.run();
        join
      end
    endmodule