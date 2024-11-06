// Code your testbench here
// or browse Examples

class transaction;
  randc bit [3:0] a; //input ports only
  randc bit [3:0] b;
endclass

class generator;
  transaction t;
  mailbox gen2drv; 
  /* mailbox is used to transmit the stimulus to the driver */
  event done; 
  /*event is used to convey information whether stimulus is generated 
  successfully or not  to the driver*/
  integer i;
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    for(i=0; i<10; i++) begin //generate 10 transactions 
      t = new();
      t.randomize();
      gen2drv.put(t);
      $display("[GEN] : data sent to driver");
      #1;
    end
    -> done;
  endtask
  
endclass
  

class driver;
  mailbox gen2drv;
  transaction t;
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    forever begin
    t = new();
    gen2drv.get(t);
    $display("[DRV] : received data from generator");
     #1;
    end
  endtask
endclass

module test();
  transaction t;
  generator gen;
  driver drv;
  mailbox gen2drv;
  
  initial begin 
    t       = new();
    gen2drv = new();
    gen     = new(gen2drv);
    drv     = new(gen2drv);
   
  
  
  fork 
    drv.main();
    gen.main();
  join_any
  
    wait(gen.done.triggered);
  end
  endmodule
