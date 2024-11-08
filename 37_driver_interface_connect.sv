//*******DESIGN CODE*******

module or4 (
  input  [3:0] a,b,
  output [3:0] y
);
  
  assign y = a | b;
  
endmodule

//********TESTBENCH CODE********


class driver;
  virtual or4_intf vif;  //to use interface inside a class we use virtual keyword
  
  integer i;
  
  task run(); //to generate stimulus (generator work)
    for(i=0; i<50; i++)begin
      vif.a = $urandom;
      vif.b = $urandom;
      #10;
    end
  endtask
endclass

interface or4_intf ();
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] y;
endinterface


module tb;
  or4_intf vif(); // instance of an interface which is inside the TB.
  driver drv;
  
  or4 dut (vif.a, vif.b, vif.y); // vif connected to dut
  
  // code to conect vif with driver class [TB]
  initial begin
    drv = new();
    drv.vif = vif; //connectong virtual interface of driver to vif inside TB.
    drv.run();
  end
  
  initial begin 
    $dumpvars;
    $dumpfile("dump.vcd");
   end
 
endmodule