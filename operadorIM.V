module operacoes(
    input [2:0] opcode,
    input [15:0] rg2,
    input [15:0] rg3,
    input [6:0] Imm,
    output reg [15:0] destino_value,
    output reg memoria_ativa
);

// Parâmetros para opcodes
parameter LOAD  = 3'h0;
parameter ADD = 3'h1;
parameter ADDI   = 3'h2;
parameter SUB   = 3'h3;
parameter SUBI = 3'h4;
parameter MUL = 3'h5;

reg [15:0]tempaddi;
reg [15:0]tempsubi;  
reg [15:0]tempmult;


always @(*) begin
    case(opcode) 
    LOAD: begin
        
        if (Imm[6] == 0)begin 
        destino_value = 16'b0 + Imm[5:0];
        memoria_ativa = 1;
        end else begin 
            destino_value = 16'b0 + Imm[5:0];
            destino_value = (~destino_value) +1;
			destino_value[15] = 1;
            memoria_ativa = 1;
        end
    end
    ADD: begin
        destino_value = rg2 + rg3;
        memoria_ativa = 1;
    end
    ADDI: begin 
        memoria_ativa = 1;
        if (Imm[6] == 0 )begin
             destino_value = rg2 + Imm[5:0];
              memoria_ativa = 1;                                                                                           
        end else begin
            tempaddi[15:0] = {10'b1,((~Imm[5:0]) +1)};
            destino_value = rg2 + tempaddi[15:0];
             memoria_ativa = 1;
        end

    end
    SUB:begin
        destino_value = rg2 -rg3;
        memoria_ativa = 1;
    end
    SUBI: begin 
        if (Imm[6] == 0)begin
            destino_value = rg2 - Imm[5:0];
            memoria_ativa = 1;
        end
        else begin
            tempsubi[5:0] = (~Imm[5:0]) +1;
            destino_value = rg2 -tempsubi[5:0];
            memoria_ativa = 1;
        end
    end
    MUL: begin

        if (Imm[6] == 0 )begin
            destino_value = rg2 * Imm[5:0];
             memoria_ativa = 1;
        end else begin
            tempmult[15:0] = {10'b1,((~Imm[5:0]) +1)};
            destino_value = rg2 * tempmult[15:0];
             memoria_ativa = 1;
        end
    end
    endcase
    
end

endmodule
