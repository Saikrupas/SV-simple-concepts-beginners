lass monitor;
  mailbox mbx;
  integer data = 18;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.put(data);
    $display("[MON] : data sent to scoreboard : %0d", data);
    #10;
  endtask
  
endclass

//////////////////////////////////////////////////////////////////////////////

class scoreboard;
   mailbox mbx;
  integer c; //data container to store the data sent by monitor.
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.get(c);
    $display("[SCB] : value rcvd from monitor : %0d", c);
    #10;
  endtask
endclass

//////////////////////////////////////////////////////////////////////////////

module tb;
  monitor mon;
  scoreboard scb;
  mailbox msmbx;
  
  initial begin
    msmbx = new();
    mon = new(msmbx);
    scb = new(msmbx);
  
    fork
      mon.run();
      scb.run();
    join
    //join_any
  end
endmodule