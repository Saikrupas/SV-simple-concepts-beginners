// Code your testbench here
// or browse Examples

//RAM DESIGN

module ram(
 input clk, rst,wr, //control signals
 input [7:0] din, //width = 8 
 input [5:0] addr, //depth of ram = 2^6 = 64 
 output reg [7:0] dout
);

reg [7:0] mem [64]; // memory with 64 elements and each element has 8 bits into it
integer i;
  
always@(posedge clk) 
begin 
if(rst == 1'b1) //synchronous reset
   begin
    for(i=0; i<64; i++)begin
     mem[i] <= 0;
    end
   end
 else begin
    if(wr == 1'b1) //write operation
      mem[addr] <= din;
     else
       dout <= mem[addr];
 end
 end
endmodule
/////////////////////////////////////////////////////
//TESTBENCH IN SV

class transaction;
 rand bit [7:0] din; //we require repetation of values so we have used rand modifier.
 rand bit [5:0] addr;//we require repetation of values so we have used rand modifier. we want values matching
       bit [7:0] dout;
       bit wr; ///to develope a logic in the scoreboard depending on the status of the wr pin
       // so we really require wr pin to be present in trans. class.
 endclass
 
 /////////////////////////////////////////////////////////////////////////////
 
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
    for(i=0; i<50; i++)begin
     t.randomize();
     mbx.put(t);
     $display("[GEN] : sending to driver");
     @(done);
    end
  endtask
endclass

/////////////////////////////////////////////////////////////

interface ram_intf();
 logic clk, rst, wr;
 logic [7:0] din;
 logic [5:0] addr;
 logic [7:0] dout;
endinterface

///////////////////////////////////////////////////////////////

class driver;
 mailbox mbx;
 event done;
 transaction t;
 
 virtual ram_intf vif;
 
 function new(mailbox mbx);
   this.mbx = mbx;
 endfunction
 
 task run();  
   t = new();
   forever begin
    mbx.get(t);
   vif.din = t.din;
   vif.addr = t.addr;
  $display("[DRV] : Interface triggered");
   ->done;
   @(posedge vif.clk);
   end
 endtask
endclass

////////////////////////////////////////////////////////////////

class monitor;
 mailbox mbx;
 transaction t;
 
 virtual ram_intf vif;
 
 function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
   t = new();
   forever begin
   t.wr = vif.wr; //required in scoreboard for logic generation
   t.din = vif.din; 
   t.addr = vif.addr;
   t.dout = vif.dout;
   mbx.put(t);
   $display("[MON] : sending to scoreboard");
   @(posedge vif.clk);
   end
  endtask
endclass

/////////////////////////////////////////////////////////////////////

class scoreboard;
 mailbox mbx;
 transaction tarr[256]; //  we are generating 100 stimuli in generator ---> to keep track of address and data in.
 transaction t;
 
 
  function new(mailbox mbx);
     this.mbx = mbx;
   endfunction
   
   task run();
     t = new();
     forever begin
     mbx.get(t);
     
    if(t.wr == 1'b1)begin 
       if(tarr[t.addr] == null)begin
          tarr[t.addr] = new();
          tarr[t.addr] = t;
     $display("[SCB] :Data rcvd ");
       end
     end
     else begin
        if(tarr[t.addr] == null) begin
          if(t.dout == 0)
           $display("[SCB] : data read test passed ");
           else 
            $display("[SCB] : data read test failed");
            end
         else begin
              if(t.dout == tarr[t.addr].din)
                 $display("[SCB] : data read test passed ");
              else
                 $display("[SCB] : data read test failed ");
              end 
           end
          end
      endtask
endclass

///////////////////////////////////////////////////////////////////////

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  virtual ram_intf vif;
  
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

////////////////////////////////////////////////////////////////

module tb();
 environment env;

 mailbox gdmbx;
   mailbox msmbx;
   
   ram_intf vif();
   
   ram dut (vif.clk, vif.rst, vif.wr, vif.din, vif.addr, vif.dout);
   
   always #5 vif.clk = ~vif.clk;
   
   initial begin
     vif.rst = 1;
     vif.clk = 0;
     vif.wr = 1;
     #30;
     vif.rst = 0;
     #300;
     vif.wr = 0;
     #200;
     vif.rst = 1;
   end
   
   initial begin
    gdmbx = new();
    msmbx = new();
 
    env = new(gdmbx,msmbx);
    env.vif = vif;
    env.run();
    #700;
    $finish;
   end
   
   initial begin
     $dumpvars;
     $dumpfile("dump.vcd");
   end
endmodule