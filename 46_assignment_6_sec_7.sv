/*
Assignment-6: Design SV testbench for the 16-bit Counter
Use the couter RTL mentioned in the Instructions tab and 
design SV Testbench to verify the functionality of the RTL.
Use Psuedo number generator facility of SV for generating Stimulus 
for LOADIN, WR, DIN and UP.
(refer snippet ASSIGNMENT-6-SECTION-7)
*/


//Counter RTL:

module counter_16 (
input clk, rst, up, load,
  input [15:0] loadin,
  output reg [15:0] y
);
 
always@(posedge clk)
begin
if(rst == 1'b1)
y <= 16'b00000000;
else if (load == 1'b1)
y <= loadin;
else begin
if(up == 1'b1)
 y <= y + 1;
 else
 y <= y - 1;
 end
end
endmodule

/////////////////////////////////////////////////////////////

class transaction;
  randc bit [15:0] loadin;
  bit [15:0] y;
endclass
////////////////////////////////////////////////////

class generator;
  mailbox mbx;
  transaction t;
  event done;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    t.randomize();
    mbx.put(t);
    $display("[GEN] : sending to driver");
    @(done);
  endtask
endclass

///////////////////////////////////////////////////

interface counter_16_intf();
  logic clk, rst, up, load;
  logic [15:0] loadin;
  logic [15:0] y;
endinterface
///////////////////////////////////////////////////

class driver;
  mailbox mbx;
  transaction t;
  event done;
  
  virtual counter_16_intf vif;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      mbx.get(t);
      vif.loadin = t.loadin;
      $display("[DRV] : triggering interface");
      ->done;
      @(posedge vif.clk);
    end
  endtask
endclass

////////////////////////////////////////////////////////////

class monitor;
  mailbox mbx;
  transaction t;
  
  virtual counter_16_intf vif;
  
   function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t =new();
    forever begin
      t.loadin = vif.loadin;
      t.y = vif.y;
      mbx.put(t);
      vif.loadin = t.loadin;
      $display("[MON] : sending data to scoreboard");
      @(posedge vif.clk); //to achieve synchronization and also wherever we have interface jst wait for a posedge of a clk
    end
  endtask
endclass

//////////////////////////////////////////////////////////////

class scoreboard;
  mailbox mbx;
  transaction t;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      mbx.get(t);
      $display("[SCO] : data rcvd");
    end
  endtask
endclass

////////////////////////////////////////////////////////////////

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  virtual counter_16_intf vif;
  
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
  
  task run();
    gen.done = gddone;
    drv.done = gddone;
    
    drv.vif = vif;
    mon.vif = vif;
    
     //schedule task
    
    fork 
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_any
  endtask
endclass

/////////////////////////////////////////////////////////

module tb;
  environment env;
  
  mailbox gdmbx;
  mailbox msmbx;
  
  counter_16_intf vif();
  
  counter_16 dut (vif.clk, vif.rst, vif.up, vif.load, vif.loadin, vif.y);
  
  always #5 vif.clk = ~vif.clk;
  
  initial begin
    vif.clk = 0;
    vif.rst = 0;
    vif.up = 0;
    vif.load = 0;
   end
  
   initial begin
     vif.rst = 1;
     #100;
     vif.rst = 0;
     #100;
     vif.rst = 1;
     #100;
     vif.rst = 0;
   end
   
  initial begin
    vif.up = $urandom;
    vif.load = $urandom;
    #200;
    vif.up = 0;
  end

  initial begin
   gdmbx = new();
   msmbx = new();

   env = new(gdmbx,msmbx);
   env.vif = vif;
   env.run();
   #1000;
   $finish;
  end
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end
  
endmodule