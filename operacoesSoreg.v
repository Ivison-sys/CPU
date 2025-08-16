// Módulo para operações com números de 7 bits com sinal (sem usar 'signed')
module ProjetoCPUUU (
    input clk,
    input [15:0] rg2,
    input [15:0] rg1,
    output reg [15:0] resultado,
    output reg memoria_ativa
);

// Parâmetros para opcodes
parameter LOAD  = 3'h0;
parameter ADD = 3'h1;
parameter ADDI   = 3'h2;
parameter SUB   = 3'h3;
parameter SUBI = 3'h4;
parameter MULT = 3'h5
parameter CLEAR = 3'h6;
parameter DPS = 3'h7;

reg [15:0]tempaddi;
reg [15:0]tempsubi;  
reg [15:0]tempmult


always @(posedge clk) begin
    
    ADD: begin 
       
        resultado = rg1 + rg2;
       

    end
    SUB: begin 
        resultado = rg1 - rg2;
    end
    
end



/*always @(posedge clk) begin
    case (opcode)
        LOAD:  q <= resultado;                 // extensão de sinal
        ADD:   q <= ext_sinal(op1) + ext_sinal(op2);
        SUB:   q <= ext_sinal(op1) - ext_sinal(op2);
        MUL:   q <= ext_sinal(op1) * ext_sinal(op2); // resultado 14 bits
        CLEAR: q <= 0;
        default: q <= q;
    endcase
end*/



endmodule
