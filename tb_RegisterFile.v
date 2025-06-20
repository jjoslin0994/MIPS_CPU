`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module tb_RegisterFile;
    reg [4:0] read_address_0;
    reg [4:0] read_address_1;
    reg [4:0] write_address_0;
    reg write_en;
    reg [31:0] write_data;
    reg clk;
    wire [31:0] read_data_0;
    wire [31:0] read_data_1;
    
    RegisterFile utt (
        .read_address_0(read_address_0),
        .read_address_1(read_address_1),
        .write_address_0(write_address_0),
        .write_en(write_en),
        .write_data(write_data),
        .clk(clk),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );
    
    reg [4:0] case_q;
    
    initial begin
     clk <= 0;
     write_en <= 0;
     case_q <= 0;
     read_address_0 <= 5'b0;
     read_address_1 <= 5'b0;
         forever begin 
            #5;
            clk <= !clk;
        end
        
      #20; 
    end
    
    // case 0: test writing values to address with write enable 
    
    always @ (posedge clk) begin
     // case 0: test writing values to address with write enable 
        case(case_q)
            0 : begin
                    write_en <= 1;
                    if(write_en)begin
                        write_address_0 <= 5'b00101; // write to address 5
                        write_data <= 35;              
                        case_q <= 1;
                    end;
                end
            1 : begin
                write_en <= 0;
                    if(!write_en)begin
                        write_address_0 <= 5'b00011; // try to write to address 3
                        write_data <= 35;
                        case_q <= 2;
                    end
                end
            2 : begin
                    read_address_0 <= 5'b00011;
                    read_address_1 <= 5'b00101;
                    if((read_address_0 != 0) && (read_address_1 != 0)) begin
                        if((read_data_0 != 0) || (read_data_1 != 35)) begin
                            $display("RegisterMemeory Error: ");
                            $display("Address %d expected value of zero but returned %d ", read_address_0, read_data_0);
                            $display("Address %d expected value of zero but returned %d ", read_address_1, read_data_1);
                            $finish;
                        end else begin
                            $display("RegisterMemeory successfull!");
                            case_q <= 3;
                        end
                    end
                
                end
            3: $finish;
        
        endcase
        
        #5;
        
    
    
    end
    
    initial begin
        #500;
        $finish;
    
    end

    

    
    
endmodule
