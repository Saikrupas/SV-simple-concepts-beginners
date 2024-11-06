/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : check_rando_method1
DATE        :  ---------
DESCRIPTION : checking if randomization is successful

**********************************************************************************************/

// Code your testbench here
// or browse Examples

//RANDOMIZATION CHECKING METHOD-1


module tb;
  bit [1:0] a =2'b11;
  bit [1:0] b = 2'b11;
  
  initial begin
    assert (a == b) begin
      $display("a and b are having equal values");
    end
    else begin
      $display("a and b are not equal");
    end
  end
  
  
endmodule 



