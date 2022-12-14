`timescale 1ns / 1ps

module instruction_decoder(
    input logic [3:0] opcode,
    input logic [6:0] immediate,
    input logic [8:0] offset,
    input logic [5:0] nzimm,
    output logic RegWrite,
    output logic RegDst,
    output logic [15:0] instr_i,
    output logic ALUSrc1,
    output logic ALUSrc2,
    output logic [3:0] ALUOp,
    output logic MemWrite,
    output logic MemToReg,
    output logic Regsrc
    );
    always_comb 
        begin
        case (opcode)
            4'b0000: // lw
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{9{immediate[6]}}, immediate};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 0;
                MemWrite = 0;
                MemToReg = 1;
                Regsrc = 0;
                end
            4'b0001: // sw
                begin
                RegWrite = 0;
                RegDst = 0; // DONT CARE
                instr_i = {{9{immediate[6]}}, immediate};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 0;
                MemWrite = 1;
                MemToReg = 0; //DONT CARE
                Regsrc = 0;
                end
            4'b00010: // add
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = 0; // DONT CARE
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 0;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b0011: // addi
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 0;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b0100: // and
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = 0; //DONT CARE
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 2;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b0101: // andi
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{9{immediate[6]}}, immediate};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 2;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b0110: // or
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = 0; //DONT CARE
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 3;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b0111: // xor
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = 0; //DONT CARE
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 8;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end
            4'b1000: // srai
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end 
            4'b1001: // sll
                begin
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 5;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;
                end  
            4'b1010: // beqz
                begin
                RegWrite = 0;
                RegDst = 0; // DONT CARE
                instr_i = offset;
                ALUSrc1 = 0;
                ALUSrc2 = 0; // DONT CARE
                ALUOp = 6;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;
                end  
            4'b1011: // bneqz
                begin
                RegWrite = 0;
                RegDst = 0; //DONT CARE
                instr_i = offset;
                ALUSrc1 = 0;
                ALUSrc2 = 0; // DONT CARE
                ALUOp = 7;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;
                end   
            default: // Produces an output of only zero in the entire circuit
                begin
                RegWrite = 0;
                RegDst = 0; // DONT CARE
                instr_i = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 1;
                ALUOp = 0;
                MemWrite = 0;
                MemToReg = 0; // DONT CARE
                Regsrc = 0; // DONT CARE
                end
            endcase
        end
endmodule
