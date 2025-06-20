`timescale 1ns / 1ps
/*
Instruction Module

A 2-d register array with one read port
*/


module  InstructionMemory(
    input [15:0] inst_address,
    output [31:0] read_data
    );
    

   
    localparam [2:0]
        lw = 3'b000,
        sw = 3'b001,
        beq = 3'b010,
        blt = 3'b011,
        add = 3'b100,
        sub = 3'b101,
        andd = 3'b110,
        ord = 3'b111;
    localparam [7:0] padding_memoryType = 8'b0;
    localparam [3:0] padding_controlType  = 4'b0;
    localparam [13:0] padding_arithmeticType = 14'b0;
        
        
genvar i;

generate
  for (i = 0; i < 64; i = i + 1) begin : REGISTER
    localparam [4:0] address = i;
  end
endgenerate

generate
  for (i = 0; i <= 16'b1111_1111_1111_1110; i = i + 1'b1) begin : DataMemory
    localparam [15:0] address = i;
  end
endgenerate
        

    
    reg [31:0] ram [255:0];
    
        // Initialize Instructions in the memory for testing
    initial begin

        ram[0][31:0] <= { lw, REGISTER[7].address, padding_memoryType, DataMemory[255].address };
        ram[1][31:0] <= { lw, REGISTER[6].address, padding_memoryType, DataMemory[8].address };
        ram[2][31:0] <= { lw, REGISTER[1].address, padding_memoryType, DataMemory[1].address };
        ram[3][31:0] <= { lw, REGISTER[2].address, padding_memoryType, DataMemory[0].address };
        ram[4][31:0] <= { lw, REGISTER[8].address, padding_memoryType, DataMemory[8].address };
        ram[5][31:0] <= { lw, REGISTER[9].address, padding_memoryType, DataMemory[8].address };
        ram[6][31:0] <= { lw, REGISTER[4].address, padding_memoryType, DataMemory[4].address };
        ram[7][31:0] <= { sub, REGISTER[8].address, REGISTER[1].address, REGISTER[8].address, padding_arithmeticType };
        ram[8][31:0] <= { andd, REGISTER[9].address, REGISTER[7].address, REGISTER[9].address, padding_arithmeticType };
        ram[9][31:0] <= { beq, REGISTER[9].address, REGISTER[4].address, padding_controlType, 15'b1101 };
        ram[10][31:0] <= { ord, REGISTER[8].address, REGISTER[0].address, REGISTER[8].address, padding_arithmeticType };
        ram[11][31:0] <= { add, REGISTER[2].address, REGISTER[1].address, REGISTER[2].address, padding_arithmeticType };
        ram[12][31:0] <= {blt, REGISTER[2].address, REGISTER[9].address, padding_controlType, 15'b0111 };
        ram[13][31:0] <= { sw, REGISTER[2].address, padding_memoryType, DataMemory[3].address};   
    end
    

    
    // Assign statement to read ram based on inst_address
    assign read_data = ram[inst_address];
    
endmodule