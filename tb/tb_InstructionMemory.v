`timescale 1ns / 1ps

module tb_InstructionMemory;

  // Inputs
  reg [15:0] inst_address;

  // Outputs
  wire [31:0] read_data;

  // DUT instantiation
  InstructionMemory uut (
    .inst_address(inst_address),
    .read_data(read_data)
  );

  // Test signals
  reg [31:0] expected_data;

  always begin
    #10 inst_address = 16'b0; // Read instruction at address 0
    expected_data = { 3'b000, 5'b00111, 8'b0, 16'b0000_0000_1111_1111 }; // Expected LW instruction
    #10;

    #10 inst_address = 16'b1; // Read instruction at address 1
    expected_data = { 3'b000, 5'b00110, 8'b0, 16'b0000_0000_0000_1000 }; // Expected LW instruction
    #10;

    #10 inst_address = 16'b111; // Read instruction at address 7
    expected_data = { 3'b101, 5'b01000, 5'b00001, 5'b01000, 14'b0 }; // Expected SUB instruction
    #10;
    
    #10 inst_address = 16'b1011; // Read instruction at address 7
    expected_data = { 3'b100, 5'b00010, 5'b00001, 5'b00010, 14'b0 }; // Expected ADD instruction
    #10;

    // Add more test cases for different instruction types and memory locations

    #80; // Finish simulation
    $stop;
  end

  // Monitor to compare expected and actual data
  always @(read_data) begin
    if (read_data != expected_data) begin
      $display("Error: Mismatch at instruction address %h: expected %h, got %h", inst_address, expected_data, read_data);
    end else begin
      $display("Success: Matched data at instruction address %h: %h", inst_address, read_data);
    end
  end

endmodule
