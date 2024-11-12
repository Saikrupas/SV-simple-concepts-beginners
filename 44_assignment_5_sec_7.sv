/*

Assignment-5: Design SV Testbench for 16-bit Multiplier

Design 16-bit Multiplier in Verilog and try to write SV testbench to verify its Functional behavior.

*/

//////////////////////////////////////////////////////////////////////////////

module mul(
input [15:0] a,b,
output [31:0] m
);
assign m = a * b;
endmodule


/////////////////////////////////////////////////
class transaction;
  randc bit [15:0] a;
  randc bit [15:0] b;
        bit [31:0] m;
  
  
  function void display(string field);
    $display("%s : a = %0h, b = %0h, mul = %0h,",field,a,b,m);
  endfunction
  
endclass

//////////////////////////////////////////////////////////////////////////////

class generator;
  mailbox mbx;
  transaction t;
  event done;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task main();
    t = new();
    for(int i=0; i<20; i++)begin
      t.randomize();
      mbx.put(t);
      t.display("[GEN] : send to driver");
      @(done);
      #10;
    end
  endtask
  
endclass

//////////////////////////////////////////////////////////////////////////////

interface mul_intf();
  logic [15:0] a,b;
  logic [31:0] m;
endinterface

/////////////////////////////////////////////////////////////////////////////

class driver;
  mailbox mbx;
  transaction t;
  event done;
  
  virtual mul_intf vif;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task main();
    t = new();
    forever begin
      mbx.get(t);
      vif.a = t.a;
      vif.b = t.b;
      t.display("[DRV] : Triggering The interface");
      ->done;
      #10;
    end
  endtask
endclass
//////////////////////////////////////////////////////////////////////////////

class monitor;
  mailbox mbx;
  transaction t;
  
  virtual mul_intf vif;
  
   function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task main();
    t = new();
    forever begin
      t.a = vif.a;
      t.b = vif.b;
      t.m = vif.m;
      mbx.put(t);
      t.display("[MON] : send data to scoreboard");
      #10;
    end
  endtask
endclass

//////////////////////////////////////////////////////////////////////////////

class scoreboard;
  mailbox mbx;
  transaction t;
  bit [31:0] temp;
 
  
 function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task main();
    t = new();
    forever begin
      mbx.get(t);
      temp = t.a * t.b;
      if(temp == t.m)begin
      t.display("[SCB] : TEST PASSED");
      end
      else begin
        t.display("[SCB] : TEST FAILED");
        //$error("[SCB] : TEST FAILED");
      end
      #10;
    end
  endtask
  
endclass
//////////////////////////////////////////////////////////////////////////////

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  virtual mul_intf vif;
  
  mailbox gdmbx;
  mailbox msmbx;
  event gddone;
  
  function new(mailbox gdmbx, mailbox msmbx);
    this.gdmbx = gdmbx;
    this.msmbx = msmbx;
    
    gen = new(gdmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    scb = new(msmbx);
  endfunction
  
  task main();
    gen.done = gddone;
    drv.done = gddone;
    
    drv.vif = vif;
    mon.vif = vif;
    
    fork
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
endclass

//////////////////////////////////////////////////////////////////////////////

module tb();
  environment env;
  
  mailbox gdmbx;
  mailbox msmbx;
  
  mul_intf vif();
  
  mul dut (vif.a, vif.b, vif.m);
  
  initial begin
    gdmbx = new();
    msmbx = new();
    env = new(gdmbx,msmbx);
    env.vif = vif;
    env.main();
    #500;
    $finish;
  end
  
  initial begin 
    $dumpvars;
    $dumpfile("dump.vcd");
  end
endmodule