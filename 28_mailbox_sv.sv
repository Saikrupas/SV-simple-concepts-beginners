// Code your testbench here
// or browse Examples


module tb;
  mailbox mbx;
  integer i;
  integer data;
  
  initial begin
    mbx = new();
    fork
      
      begin
        
        for(i=0;i<20;i++) begin
          mbx.put(i);
          $display("data sent : %0d", i);
          #10;
        end
      
      end
      
      begin
        
      forever begin
        mbx.get(data);
        $display("data received : %0d",data);
         //#10;
      end
        
      end
    join
    //join_any
    //join_none
  end

endmodule