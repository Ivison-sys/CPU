// Módulo para operações com números de 7 bits com sinal (sem usar 'signed')
module operacoes(
    input [2:0] opcode,
    input [15:0] rg2,
    input [15:0] rg3,
    input [6:0] Imm,
    output reg [15:0] D1,
    output reg memoria_ativa
);

// Parâmetros para opcodes
parameter LOAD  = 3'h0;
parameter ADD = 3'h1;
parameter ADDI   = 3'h2;
parameter SUB   = 3'h3;
parameter SUBI = 3'h4;
parameter MULT = 3'h5

reg [15:0]tempaddi;
reg [15:0]tempsubi;  
reg [15:0]tempmult


always @(*) begin
    LOAD: begin
        
        if (Imm[6] == 0)begin 
        D1 = 16'b0 + Imm[5:0];
        memoria_ativa = 1;
        end else begin 
            D1 = 16'b0 + Imm[5:0];
            D1 = (~D1) +1;
			D1[15] = 1;
            memoria_ativa = 1;
        end
    end
    ADD: begin
        D1 = rg2 + rg3;
        memoria_ativa = 1;
    end
    ADDI: begin 
        memoria_ativa = 1;
        if (Imm[6] == 0 )begin
             D1 = rg2 + Imm[5:0];
              memoria_ativa = 1;                                                                                           
        end else begin
            temp[15:0] = {10'b1,((~Imm[5:0]) +1)};
            D1 = rg2 + temp[15:0];
             memoria_ativa = 1;
        end

    end
    SUB:begin
        D1 = rg2 -rg3;
        memoria_ativa = 1;
    end
    SUBI: begin 
        if (Imm[6] == 0)begin
            D1 = rg2 - Imm[5:0];
            memoria_ativa = 1;
        end
        else begin
            tempsubi[5:0] = (~Imm[5:0]) +1;
            D1 = rg2 -tempsubi[5:0];
            memoria_ativa = 1;
        end
    end
    MUL: begin

        if (Imm[6] == 0 )begin
            D1 = rg2 * Imm[5:0];
             memoria_ativa = 1;
        end else begin
            temp[15:0] = {10'b1,((~Imm[5:0]) +1)};
            D1 = rg2 * temp[15:0];
             memoria_ativa = 1;
        end
    end
    
end





endmodule
