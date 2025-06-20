`timescale 1ns / 1ps



module tb_Decoder;
// inputs
reg [31:0] inst; 
// outputs
wire [2:0] opcode;
wire [4:0] reg_addr_0;
wire [4:0] reg_addr_1;
wire [4:0] reg_addr_2;
wire [15:0] addr;


Decoder utt (
  .inst(inst),
  .opcode(opcode),
  .reg_addr_0(reg_addr_0),
  .reg_addr_1(reg_addr_1),
  .reg_addr_2(reg_addr_2),
  .addr(addr)
);

initial begin
    #5;
    inst <= 32'b111_00000_11111_00000_11111111111111;
    
    #5;
    


    if( (opcode != 3'b111) || (reg_addr_0 != 5'b00000) || (reg_addr_1 != 5'b11111) || (addr != 16'b0011111111111111)) begin
       $display("Decoder test failed!");
    end else begin
        $display("Decoder test passed successfully!");
    end
    
    $finish;
    
    end
endmodule