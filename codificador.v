module codificador (
    input clk,
    input [2:0] opcode,
    output reg [39:0] palavra
);

parameter LOAD = 3'b000, ADD = 3'b001, ADDI = 3'b010, SUB = 3'b011, SUBI = 3'b100, MUL = 3'b101, CLEAR = 3'b110, DPL = 3'b111;

always @(posedge clk) begin 
    case (opcode)
        LOAD: begin 
            palavra[7:0] <= 8'h4C; // l
            palavra[15:8] <= 8'h4F; // O
            palavra[23:16] <= 8'h41; // A
            palavra[31:24] <= 8'h44; // D
            palavra[39:32] <= 8'h14; // curso a direita
        end
        ADD: begin 
            palavra[7:0] <= 8'h41; // A
            palavra[15:8] <= 8'h44; // D
            palavra[23:16] <= 8'h44; // D
            palavra[31:24] <= 8'h14; // curso a direita
            palavra[39:32] <= 8'h14; // curso a direita
        end
        ADDI: begin 
            palavra[7:0] <= 8'h41; // A
            palavra[15:8] <= 8'h44; // D
            palavra[23:16] <= 8'h44; // D
            palavra[31:24] <= 8'h49; // I
            palavra[39:32] <= 8'h14; // curso a direita
        end
        SUB: begin 
            palavra[7:0] <= 8'h53; // S
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h42; // B
            palavra[31:24] <= 8'h14; // curso a direita
            palavra[39:32] <= 8'h14; // curso a direita
        end
        SUBI: begin 
            palavra[7:0] <= 8'h53; // S
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h42; // B
            palavra[31:24] <= 8'h49; // I
            palavra[39:32] <= 8'h14; // curso a direita
        end
        MUL: begin 
            palavra[7:0] <= 8'h4D; // M
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h4C; // L
            palavra[31:24] <= 8'h14; // curso a direita
            palavra[39:32] <= 8'h14; // curso a direita
        end
        CLEAR: begin 
            palavra[7:0] <= 8'h43; // C
            palavra[15:8] <= 8'h4C; // l
            palavra[23:16] <= 8'h45; // E
            palavra[31:24] <= 8'h41; // A
            palavra[39:32] <= 8'h52; // R 
        end
        DPL: begin 
            palavra[7:0] <= 8'h44; // D
            palavra[15:8] <= 8'h50; // P
            palavra[23:16] <= 8'h4C; // L
            palavra[31:24] <= 8'h14; // curso a direita
            palavra[39:32] <= 8'h14; // curso a direita
        end 
        default: 
    endcase
end

endmodule