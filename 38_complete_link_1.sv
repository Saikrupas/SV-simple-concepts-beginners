//********DESIGN CODE******

// Code your design here

module xor4(
  input  [3:0] a,b,
  output [3:0] y
);

  assign y = a ^ b;
  
endmodule

//*****TESTBENCH CODE****

class transaction;  // we will never add global signals (clk and rst)
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [3:0] y;
  
  //add constraints internal constraints or external constraints
endclass

//////////////////////////////////////////////////////////////////////////////

class generator;
  transaction t;
  mailbox mbx;
  event done;
  integer i;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run;
    t = new();
    for(i=0;i<25;i++)begin
      t.randomize();
      mbx.put(t);
      $display("[GEN] : data sent to driver");
      #10;
    end
    ->done;
  endtask
endclass

//////////////////////////////////////////////////////////////////////////////

interface xor4_intf();
  logic [3:0] a,b;
  logic [3:0] y;
endinterface

/////////////////////////////////////////////////////////////////////////////

class driver;
  virtual xor4_intf vif;
  transaction t;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run;
    t = new();
    forever begin
      mbx.get(t);
      vif.a = t.a;
      vif.b = t.b;
      $display("[DRV] : Trigger Interface");
      #10;
    end
  endtask
  
endclass

//////////////////////////////////////////////////////////////////////////////

module tb;
  generator gen;
  driver drv;
  transaction t;
  mailbox gdmbx;
  
  xor4_intf vif();
  
  xor4 dut(vif.a, vif.b, vif.y); //dut connected to interface
  
  initial begin
    gdmbx = new();
    gen = new(gdmbx);
    drv = new(gdmbx);
  
    drv.vif = vif; //connecting driver virtual interface with interface of TB
    
    fork
      gen.run();
      drv.run();
    join_any
   
    wait(gen.done.triggered);
    
  end
  
  initial begin
    $dumpvars;
    $dumpfiles("dump.vcd");
  end
  
  
endmodule