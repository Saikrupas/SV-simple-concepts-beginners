//******************DESIGN CODE***********************

module andt (
  input [7:0] a,b,
  output [7:0] y
);

assign y = a & b;

endmodule

//*****************TESTBENCH CODE**********************

//**********TESTBENCH CODE**********************
class transaction;
 randc  bit [7:0] a;
 randc  bit [7:0] b;
        bit [7:0] y;
endclass

//////////////////////////////////////////////////
class generator;
  transaction t;
  mailbox mbx;
  event done;
  integer i;
  
  function new(mailbox mbx);
  this.mbx = mbx;
  endfunction
  
  task run();
     t = new();
   for(i=0; i<25; i++)begin
      t.randomize();
      mbx.put(t);
      $display("[GEN] : data send to driver");
      @(done);
      #10;
    end
  endtask

endclass

/////////////////////////////////////////////////////
interface andt_intf();
   logic [7:0] a;
   logic [7:0] b;
   logic [7:0] y;
endinterface 

/////////////////////////////////////////////////////
class driver;
 transaction t;
 mailbox mbx;
 event done;
 virtual andt_intf vif;
 
  function new(mailbox mbx);
 this.mbx = mbx;
 endfunction
 
 task run();
  t = new();
  forever begin
  mbx.get(t);
  vif.a = t.a;
  vif.b = t.b;
  $display("[DRV] : trigger interface");
  ->done;
  #10;
  end
 endtask
endclass

////////////////////////////////////////////////////////////
class monitor;
transaction t;
mailbox mbx;
virtual andt_intf vif;

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
   $display("[MON] : data send to scoreboard");
   #10;
 end
endtask
endclass

//////////////////////////////////////////////////////////////////
class scoreboard;
mailbox mbx;
transaction t;
bit [7:0] temp; //for comparision

  function new(mailbox mbx);
 this.mbx = mbx;
 endfunction

task run();
  t = new();
  forever begin
    mbx.get(t);
    temp = t.a & t.b;
    if(t.y == temp)begin
      $display("[SCB] :TEST PASSED");
    end
    else begin
      $display("[SCB] :TEST FAILED");
    end
    #10;
  end

endtask
endclass
//////////////////////////////////////////////////////////////////
class environment;
 generator gen;
 driver drv;
 monitor mon;
 scoreboard scb;
 
 mailbox gdmbx;
 mailbox msmbx;
 
 event gddone;
 
 virtual andt_intf vif;
 
 function new(mailbox gdmbx,mailbox msmbx);
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

//////////////////////////////////////////////////////////////////

module tb();
environment env; //instance of environment class

mailbox gdmbx;
mailbox msmbx;

andt_intf vif();

  andt dut(.a(vif.a), .b(vif.b), .y(vif.y)); //donnecting dut to interface
//andt dut(vif.a, vif.b, vif.y);


initial begin
gdmbx = new();
msmbx = new();
  env = new(gdmbx,msmbx);
env.vif = vif; //connecting environment with interface

env.run();
#200;
$finish;
end
         
initial begin 
  $dumpvars;
  $dumpfile("dump.vcd");
end
endmodule