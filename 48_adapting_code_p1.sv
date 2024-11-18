module ram(
input clk, rst, wr,
input [7:0] din, addr,
output reg [7:0] dout
);
reg [7:0] mem [256];
integer i;
 
always@(posedge clk)
begin
if(rst == 1'b1) begin
for( i = 0; i < 256; i++)
begin
mem[i] <= 0;
end
end
else if(wr == 1'b1)
mem[addr] <= din;
else
dout <= mem[addr];
end   
endmodule
 
////////////////////////////////////////////////////////////////////////////

interface counter_intf();
logic clk,rst, wr;
logic [7:0] din, addr;
logic [7:0] dout;
endinterface

///////////////////////////////////////////////////////////////////////////

///////////////////////Transaction/////////////////////// 
class transaction;
rand bit [7:0] din;
randc bit [7:0] addr;
bit wr;
bit [7:0] dout;
  
  constraint  addr_c {addr > 10; addr < 18;};
endclass

//////////////////////////Generator/////////////////////
class generator;
mailbox mbx;
transaction t;
event done;
integer i;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
for(i = 0; i < 100; i++)begin
t.randomize();
mbx.put(t);
$display("[GEN] : Data send to driver");
@(done);
end
endtask
endclass
 
////////////////////// Driver //////////////////////
class driver;
mailbox mbx;
event done;
transaction t;
virtual counter_intf vif;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
forever begin
mbx.get(t);
vif.din = t.din;
vif.addr = t.addr;
$display("[DRV] : Interface Trigger");
->done;
@(posedge vif.clk);
end
endtask
endclass  
 
/////////////////////// monitor //////////////////////
class monitor;
mailbox mbx;
virtual counter_intf vif;
transaction t;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
forever begin
t.din = vif.din;
t.addr = vif.addr;
t.dout = vif.dout;
t.wr = vif.wr;
mbx.put(t);
$display("[MON] : data send to Scoreboard");
@(posedge vif.clk);
end
endtask
endclass
 /////////////////////// Scoreboard ////////////////////////
class scoreboard;
mailbox mbx;
transaction tarr[256];
transaction t;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
forever begin
mbx.get(t);
 
if(t.wr == 1'b1) begin
  if(tarr[t.addr] == null) begin
     tarr[t.addr] = new();
     tarr[t.addr] = t;
     $display("[SCO] : Data stored");
     end
    end
 else begin
   if(tarr[t.addr] == null) begin
     if(t.dout == 0) 
       $display("[SCO] : Data read Test Passed");
     else
       $display("[SCO] : Data read Test Failed"); 
    end
    else begin
      if(t.dout == tarr[t.addr].din)
       $display("[SCO] : Data read Test Passed");
       else
       $display("[SCO] : Data read Test Failed"); 
    end
    end
end
endtask
endclass

////////////////////// Environment //////////////////////
class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sco;
 
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
sco = new(msmbx);
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
sco.run();
join_any
 
endtask
 
endclass
 
//////////////////////// testbench top ////////////////////
module tb;
 
environment env;
counter_intf vif();
mailbox gdmbx, msmbx;
 
ram dut (vif.clk, vif.rst, vif.wr, vif.din, vif.addr, vif.dout);
 
always #5 vif.clk = ~vif.clk;
 
 
initial begin
vif.clk = 0;
vif.rst = 1;
#50;
vif.wr = 1;
vif.rst = 0;
#250;
vif.wr = 0;
#250;
end
 
initial begin
gdmbx = new();
msmbx = new();
 
env = new(gdmbx,msmbx);
env.vif = vif;
#50;  
env.run();
#600;
$finish;
end
 
initial begin
  $dumpvars;
  $dumplfile("dump.vcd");
 
end 
 
endmodule