`timescale 1ns / 1ps


module regfile(
        output logic [15:0] rd0_data, rd1_data,
        input logic rst, clk, wr_en, 
        input logic [2:0] rd0_addr, rd1_addr, wr_addr,
        input logic [15:0] wr_data
    );
    reg [15:0] register_array [0:7];
    
    assign rd0_data = register_array[rd0_addr];
    assign rd1_data = register_array[rd1_addr];
    
    always @ (posedge clk, posedge rst) 
    begin
        if (rst)
            for (int i = 0; i < 8; i++) register_array[i] <= 16'b0;
        else
            if (wr_en) register_array[wr_addr] <= wr_data;
    end   
endmodule


module TwoToOneMux (
    input logic sel_mux,
    input logic [15:0] a, b,
    output logic [15:0] out
    );
    assign out = sel_mux? b : a;
endmodule


module alu(
    input logic signed[15:0]a,
    input logic signed[15:0]b,
    input logic [3:0]s,
    output logic signed[15:0]f,
    output logic take_branch,
    output logic ovf
    );
    
    always @ (a, b, s) 
    
    begin
    case(s)
        4'b0000 : // Addition 
            begin
                f = a + b;
                ovf = !a[15] & !b[15] & f[15] | a[15] & b[15] & !f[15];
                take_branch = 0;
            end
        4'b0001 : // Inversion
            begin
                f = ~b;
                ovf = 0;
                take_branch = 0;
            end
        4'b0010 : // Bitwise AND
            begin
                f = a & b;
                ovf = 0;
                take_branch = 0;
            end
        4'b0011 : // Bitwise OR 
            begin
                f = a | b;
                ovf = 0;
                take_branch = 0;
            end
        4'b0100 : // Arithmetic Right Shift
            begin
                f = a >>> b;
                ovf = 0;
                take_branch = 0;
            end
        4'b0101 : // Logical Left Shift
            begin
                f = a << b;
                ovf = 0;
                take_branch = 0;
            end
        4'b0110 : // BEQZ
            begin
                take_branch = a? 0:1;
                f = 0;
                ovf = 0;
            end
        4'b0111 : // BNEZ
            begin
                take_branch = a? 1:0;
                f = 0;
                ovf = 0;
            end
        4'b1000 : // XOR
            begin
                f = a ^ b;
                ovf = 0;
                take_branch = 0;
            end  
        default : // Default
            begin
                f = 0;
                ovf = 0;
                take_branch = 0;     
            end
    endcase
    end
endmodule
