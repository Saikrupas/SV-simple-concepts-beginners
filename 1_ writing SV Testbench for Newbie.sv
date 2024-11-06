//1st code of - Writing SV Testbench for Newbie  

class first;
bit x = 1'b1;  
endclass
 
 
module tb();
 
  first f1; // Name of the Instance
 
  initial begin
    f1 = new(); //creating object of the class 
    $display("-------------------------------");  
  $display("The value of the x is %0b",f1.x);  
    $display("-------------------------------");
  end
  
endmodule