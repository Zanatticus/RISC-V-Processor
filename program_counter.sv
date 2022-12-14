`timescale 1ns / 1ps


module program_counter(
    output logic[8:0] pc,
    input logic clk, rst, take_branch,
    input logic[8:0] offset
    );
    always @ (posedge clk, posedge rst)
    begin
        if (rst) pc = 0;
        else 
            if (take_branch) pc = pc + offset;
            else pc = pc + 1;
    end
endmodule
