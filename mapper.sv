`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2022 03:52:50 AM
// Design Name: 
// Module Name: mapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mapper(input [15:0] instruction,
              output logic [2:0] rs1,rs2,rd,
              output logic [6:0] immediate,
              output logic [5:0] nzimm,
              output logic [8:0] offset,
              output logic [3:0] opcode);
              
  always_ff @ (instruction)
  begin
  nzimm = 0;
  offset = 0;
  immediate = 0;
  rs1=0;
  rs2=0;
  rd=0;
  case(instruction[15:13])
  3'b110:begin 
         case(instruction[1:0])
            2'b00 : begin immediate = {instruction[5],instruction[12],instruction[11:10],instruction[6],2'b00};rs1=instruction[9:7];rs2=instruction[4:2];opcode=4'b0001;end //sw
            2'b01 : begin offset = {instruction[12],instruction[12],instruction[6:5],instruction[2],instruction[11:10],instruction[4:3]}; rs1=instruction[9:7];opcode=4'b1010; end //beqz
         endcase
           end
  3'b010: begin immediate = {instruction[5],instruction[12],instruction[11:10],instruction[6],2'b00};rs1=instruction[9:7]; rd = instruction[4:2];opcode=4'b0000; end //lw
  3'b100 : begin
           case(instruction[11:10])
                2'b01 : begin
                        case(instruction[1:0])
                        2'b10: begin rd = instruction[9:7]; rs2 = instruction[4:2];opcode=4'b0010; end //add
                        2'b01: begin nzimm = {instruction[12],instruction[6:5],instruction[4:2]};rd = instruction[9:7];rs1=instruction[9:7];opcode= 4'b1000; end // srai
                        endcase 
                        end                                    
                2'b11 : begin
                        case(instruction[6:5])
                            2'b11: begin rs1 = instruction[9:7]; rd = instruction[9:7];rs2 = instruction[4:2];opcode=4'b0100;end // and 
                            2'b10: begin rs1 = instruction[9:7]; rd = instruction[9:7]; rs2 = instruction[4:2];opcode=4'b0110;end // or
                            2'b01 : begin rs1 = instruction[9:7]; rd = instruction[9:7]; rs2 = instruction[4:2];opcode=4'b0111; end //xor
                         endcase 
                        end 
                2'b10 : begin immediate = {1'b0,instruction[12],instruction[6:5],instruction[4:2]}; rs1 = instruction[9:7]; rd = instruction[9:7];opcode=4'b0101; end // andi
            endcase
           end
  3'b000 : begin
           case(instruction[1:0])
                2'b01: begin nzimm = {instruction[12],instruction[6:5],instruction[4:2]};rs1 = instruction[9:7]; rd = instruction[9:7];opcode=4'b0011; end //addi
                2'b10 : begin nzimm = {instruction[12],instruction[6:5],instruction[4:2]};rd = instruction[9:7];opcode=4'b1001; end //slli
           endcase 
           end
           
  3'b111 : begin offset = {instruction[12],instruction[12],instruction[6:5],instruction[2],instruction[11:10],instruction[4:3]}; rs1 = instruction[9:7];opcode=4'b1011; end // bnez
  endcase
  end
        

endmodule
