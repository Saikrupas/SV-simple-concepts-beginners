/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : updating_data_member_fun
DATE        :  ---------
DESCRIPTION : updating data member with the help of function/method

**********************************************************************************************/

// Code your testbench here
// or browse Examples

class temp;
  bit[7:0] data;
  
  function void read (input bit[7:0] data);
    this.data = data;
  endfunction
  
endclass

module tb;
  
  temp t;
  
  initial begin
    t = new();
    t.read(8'b1011_1010);
    #10;
    $display("value of data member : %0b",t.data);
  end
  
endmodule