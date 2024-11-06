/**********************************************************************************************

NAME        :  Saikrupas
FILENAME    : check_rando_method2
DATE        :  ---------
DESCRIPTION : checking if randomization is successful

**********************************************************************************************/


//RANDOMIZATION CHECKING METHOD-2

module tb;
  bit [1:0] a =2'b11;
  bit [1:0] b = 2'b11;
  
  initial begin
    if (a == b) begin
      $display("a and b are having equal values");
    end
    else begin
      $display("a and b are not equal");
    end
  end
  
  
endmodule 
