`timescale 1ns / 1ps

/*
CPU Module

Top Module for CPU.

*/


module CPU(
    input clk
    );
    
     
    reg [15:0]  pc_q = 0;      // Program Counter
    reg [31:0]  instruction_q; // Holds instruction binary 
    reg [1:0]   state_q = 0;   // State of CPU
    
    // InstructionMemory wires and regs
    wire [31:0] r_data;
    
    // Decoder wires regs
    wire [2:0] op_code;
    wire [4:0] ra_0;
    wire [4:0] ra_1;
    wire [4:0] ra_2;
    wire [15:0] address;
    reg [4:0] ra_2_q;
    reg [15:0] address_q;
    reg [2:0] op_code_q;
       
    // wire regs for RF
    wire [31:0] rd0;
    wire [31:0] rd1;
    reg [31:0] rd0_q;
    reg [31:0] rd1_q;
    wire we_r;
    
    assign we_r = (((op_code_q == 3'b000) || (op_code_q == 3'b100) || (op_code_q == 3'b101)||
        (op_code_q == 3'b110) || (op_code_q == 3'b111)) && (state_q == 3));
        
    
    
    // wires and regs for ALU
    wire [31:0] op0;
    reg [31:0] op0_q;
    wire change_pc;
    reg change_pc_q;
    
    // wires and regs for DataMemory
    wire [31:0] readData;
    wire we_DM;
    reg [31:0] readData_q;
    assign we_DM = ((op_code_q == 3'b1)&&(state_q == 3));
    
    wire [31:0] rf_writeData;
    wire [4:0] rf_writeAddress;
    
    assign rf_writeData = ((op_code_q == 0) ? readData :
                            op0_q);
                            
    assign rf_writeAddress = ((op_code_q == 0) ? ra_0 :
                            ra_2_q);
    
    // Instantiate decoder, Instruction Memory,
    // Data Memory, Register File and ALU
    InstructionMemory IM ( //Fetch
        .inst_address(pc_q), // inpu
        .read_data(r_data) // outpu
    );
    
    Decoder D ( // Decode
        .inst(instruction_q),
        .opcode(op_code),
        .reg_addr_0(ra_0),
        .reg_addr_1(ra_1),
        .reg_addr_2(ra_2),
        .addr(address)
    );
    ALU A( // Execute
        .ip_0(rd0_q),
        .ip_1(rd1_q),
        .opcode(op_code_q),
        .op_0(op0),
        .change_pc(change_pc)
    );
    
    DataMemory DM ( // write back
        .clk(clk),
        .data_address(address_q),
        .write_en(we_DM),
        .write_data(rd0_q),
        .read_data(readData)
    );
         
    RegisterFile RF( // write back
        .clk(clk), // ip
        .read_address_0(ra_0), // ip
        .read_address_1(ra_1), //ip
        .write_address_0(rf_writeAddress),
        .write_en(we_r),
        .write_data(rf_writeData),
        .read_data_0(rd0), //outpu
        .read_data_1(rd1) // outpu
    );
    
 
        
    always@(posedge clk)
    begin
        if(state_q == 0) begin // Fetch Stage
            // Read instruction from instruction memory
            instruction_q <= r_data;
            // increment PC
            pc_q <= pc_q + 1;
            // increment state
            state_q <= 1;
        end else if(state_q == 1) begin  // Decode Stage       
            // Instruction Decode and read data from register/memory
            // store all data necessary for next stages in a register
            rd0_q <= rd0;
            rd1_q <= rd1;
            ra_2_q <= ra_2;   
            address_q <= address;       
            op_code_q <= op_code;
 
            state_q <= 2;  //update state
        end else if(state_q == 2) begin  // Execute Stage        
            // Perform ALU operations  
            op0_q <= op0;     
            change_pc_q <= change_pc;
            state_q <= 3; //update state
        end else if(state_q == 3) begin  // Memory Stage
            // Access Memory and register file(for load)
          
            if(change_pc_q) begin
                pc_q <= address_q;
                change_pc_q <= 0;
            end
              state_q <= 0;            

        end    
    end
    
endmodule
