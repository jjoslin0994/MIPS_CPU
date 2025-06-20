`timescale 1ns / 1ps

module tb_ALU;

// Inputs
reg [31:0] ip_0;
reg [31:0] ip_1;
reg [2:0] opcode;

// Outputs
wire [31:0] op_0;
wire change_pc;

ALU utt(
  .ip_0(ip_0),
  .ip_1(ip_1),
  .opcode(opcode),
  .op_0(op_0),
  .change_pc(change_pc)
);

initial begin
  // Test case 1: Addition
  ip_0 <= 5;
  ip_1 <= 5;
  opcode <= 3'b100;  // Add

  #5;  // Optional delay for settling

  if (op_0 == (ip_0 + ip_1)) begin
    $display("Addition test passed!");
  end else begin
    $fatal(0, "Addition error: expected %d, received %d", ip_0 + ip_1, op_0);
  end
  
  #5
   
   
  $display("Subtration Test");
  ip_0 <= 5;
  ip_1 <= 2;
  opcode <= 3'b101;  // Sub
  
  #5;
    if (op_0 == (ip_0 - ip_1)) begin
        $display("Subtraction test passed!");
    end else begin
        $fatal(0, "Subtratcion error: expected %d, received %d", ip_0 - ip_1, op_0);
  end
  
  $display("op_0: %d", op_0);
  
  #5;
  ip_0 <= 8'hFFFFFFFF;
  ip_1 <= 8'hF0f0f0f0;
  opcode <= 3'b110;
  #5;
  if (op_0 == 8'hF0f0f0f0) begin
    $display("AND test passed!");
  end else begin
    $display("AND test failed!");
  end
  
  
  #5;
  
  opcode <= 3'b111; // OR
  #5;
  if (op_0 == 8'hffffffff) begin
    $display("OR test passed!");
  end else begin
    $display("OR test failed!");
  end
  
  
  #5;
  
  ip_0 <= 7;
  ip_1 <= 7;
  opcode <= 2;
  #5
  if(change_pc) begin
    $display("BEQ test passed!");
  end else begin
    $display("BEQ test failed");
  end
  
  
  
    #5;
  
  ip_0 <= 2;
  ip_1 <= 7;
  opcode <= 3;
  #5
  if(change_pc) begin
    $display("BLT test passed!");
  end else begin
    $display("BLT test failed");
  end
  #5;

    $finish;
    end
endmodule
