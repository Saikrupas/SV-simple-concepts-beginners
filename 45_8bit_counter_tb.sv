// Code your testbench here
// or browse Examples

//DESIGN OF 8-BIT COUNTER

module counter(
  input clk, rst, up, load,   //load - user will specify the data from which its starts counting 
  input [7:0] loadin,
  output reg [7:0] dout  
);

always@(posedge clk) //synchronous rst
begin
if(rst == 1'b1)
dout <=8'b0000_0000;
else if(load == 1'b1)
dout <= loadin;
else 
  begin
  if(up == 1'b1)
    dout <= dout + 1;
  else
    dout <= dout - 1;

   end
end
endmodule

//////////////////////////////////////////////////////////////

class transaction;
 randc bit [7:0] loadin; //control pins - will be triggering in a tb.
       bit [7:0] dout;
endclass

//////////////////////////////////////////////////////////////

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
   $display("[GEN] : sending data to driver");
   @(done);
endtask
endclass

//////////////////////////////////////////////////////////////////////

interface counter_intf();
   logic clk;
   logic rst;
   logic up;
   logic load;
   logic [7:0] loadin;
   logic [7:0] dout;
   endinterface

/////////////////////////////////////////////////////////////////////////

class driver;
mailbox mbx;
transaction t;
event done;

virtual counter_intf vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
vif.loadin = t.loadin;
$display("[DRV] : Triggering interface");
->done;
@(posedge vif.clk);
end
endtask
endclass

/////////////////////////////////////////////////////////////////////////////////

class monitor;
mailbox mbx;
transaction t;

virtual counter_intf vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
t.loadin = vif.loadin;
t.dout = vif.dout;
mbx.put(t);
$display("[MON] : sending data to scoreboard");
@(posedge vif.clk);
end
endtask
endclass

/////////////////////////////////////////////////////////////////////////////

class scoreboard;
mailbox mbx;
transaction t;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
forever begin
mbx.get(t);
$display("[SCO] : data rcvd");
end
endtask
endclass

/////////////////////////////////////////////////////////////////////////////

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  virtual counter_intf vif;
  
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
    
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_any
  endtask
  
endclass

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module tb;
environment env;
mailbox gdmbx, msmbx;

counter_intf vif();

counter dut (vif.clk,vif.rst,vif.up,vif.load,vif.loadin,vif.dout);

always #5 vif.clk = ~vif.clk; //generate a clk 

initial begin //all control inputs are initialized to 0
vif.clk = 0;
vif.rst = 0;
vif.up = 0;
vif.load = 0;
#30;
vif.rst = 1;
#100;
vif.rst = 0;
vif.up = 1;
#100;
vif.load = 1;
vif.up = 0;
#100;
vif.load = 0;
#100;
end
 
initial begin
gdmbx = new();
msmbx = new();

env = new(gdmbx,msmbx);
env.vif = vif;
env.run();
#500;
$finish;
end
  
initial begin  
$dumpvars;
$dumpfile("dump.vcd");  
end
endmodule