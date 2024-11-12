
`timescale 1ns/1ps

//DESIGN CODE

module adder8(
   input [7:0] a,b,
   output [8:0] sum
);

assign sum = a + b;

endmodule

//////////////////////////////////////////////////////

class transaction;
 randc bit [7:0] a;
 randc bit [7:0] b;
 bit [8:0] sum;
endclass

//////////////////////////////////////////////////////
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
 for(i=0; i<20; i++)begin
 t.randomize();
 mbx.put(t);
 $display("[GEN] :data sent to driver");
 @(done);
 #10;
 end
 endtask
 
endclass

///////////////////////////////////////////////////////////
interface adder8_intf();
logic [7:0] a;
logic [7:0] b;
logic [8:0] sum;
endinterface
////////////////////////////////////////////////////////////

class driver;
mailbox mbx;
transaction t;
event done;

virtual adder8_intf vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
vif.a = t.a;
vif.b = t.b; 
$display("[DRV]: TRIGGER INTERFACE");
->done;
#10;
end
endtask
endclass

////////////////////////////////////////////////////////////////////////////

class monitor;
mailbox mbx;
transaction t;

virtual adder8_intf vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
 t = new();
 forever begin
 t.a = vif.a;
 t.b = vif.b;
 t.sum = vif.sum;
 mbx.put(t);
 $display("[MON] :send data to scoreboard");
 #10;
 end
endtask
endclass

////////////////////////////////////////////////////////////////////////////////////

class scoreboard;
mailbox mbx;
transaction t; //data constainer
bit [8:0] temp;//golden refrence

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run;
t = new();
forever begin
mbx.get(t);
temp = t.a + t.b;
if(temp == t.sum)begin
$display("[SCB] : TEST PASSED");
end
else begin
$display("[SCB] : TEST FAILED");
end
#10;
end
endtask
endclass

///////////////////////////////////////////////////////////////////////////////////////////

class environment;
generator gen;
driver drv;
monitor mon;
scoreboard scb;

virtual adder8_intf vif;

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

////////////////////////////////////////////////////////////////////////////////////////

module tb();
environment env;
 
mailbox gdmbx;
mailbox msmbx;
 
adder8_intf vif();
 
adder8 dut (vif.a, vif.b,vif.sum);
 
initial begin
gdmbx = new();
msmbx = new();
env = new(gdmbx, msmbx);
env.vif = vif;
env.run();
#200;
$finish;
end
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
    
  end


endmodule
