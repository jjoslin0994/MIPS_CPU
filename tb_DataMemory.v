`timescale 1ns / 1ps

module tb_DataMemory;
// inputs
reg clk;
reg [15:0] data_address;
wire write_en;
reg [31:0] write_data;
 // outputs
wire [31:0] read_data;
 
 assign write_en = ( case_q == 1 ) ? 1 : 0;
 
 DataMemory utt (
    .clk(clk),
    .data_address(data_address),
    .write_en(write_en),
    .write_data(write_data),
    .read_data(read_data)
 );
 
 reg [4:0] case_q;
 
 initial begin 
    clk <= 0;

    case_q <= 0;
    data_address <= 0;
    forever begin
        #5;
        clk = ~clk;
    end
    
    #10;
 end
 
 always @ (posedge clk) begin
  case (case_q)
    0 : begin
            data_address <= 5'b00011; // try to write to address 3
            write_data <= 1023;
            #1;
            case_q <= 1;
        end
    1 : begin 
        #1;
            case_q <= 2; // write_en enable
        end
        
    2 : begin
            data_address <= 5'b01111; // try to write to address 3
            write_data <= 2047;
            case_q <= 3;
        end
    3 : begin
            case_q <= 4; // write_en disabled
        end
        
    4 : begin   
            data_address <= 5'b00011;
            if(data_address == 5'b00011) begin
                if( read_data == 1023 ) begin
                    $display("Write and read successfull 1");
                end else begin
                    $display("Error storing and reading datamemory should be 1023 but got %d", read_data);
                end
                case_q <= 5;
            end
        end
        
    5 : begin 
            data_address <= 5'b01111;
            if ( data_address == 5'b01111 ) begin
                #5;
                if ( read_data != 15 ) begin
                    $display("Error storing and reading datamemory should be 3 but is %d", read_data);
                end else begin
                    $display("Write and read successfull 2");
                end
                case_q <= 6;
            end
        end
    6 : $finish; 
           
       

  endcase
 end


 
 
endmodule
