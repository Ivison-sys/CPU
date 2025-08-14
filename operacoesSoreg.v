// Módulo para operações com números de 7 bits com sinal (sem usar 'signed')
module operacoes (
    input clk,
    input [2:0] opcode,
    input [6:0] op1, // agora são sem sinal
    input [6:0] op2,
    output reg [13:0] q,       // resultado com sinal em complemento de dois
    output wire led_sinal,     // 1 se resultado for negativo
    output wire [13:0] led_valor // magnitude absoluta
);

// Parâmetros para opcodes
parameter LOAD  = 3'h0;
parameter ADD   = 3'h1;
parameter SUB   = 3'h2;
parameter MUL   = 3'h3;
parameter CLEAR = 3'h4;

// Função para converter de 7 bits complemento de dois para 14 bits
function [13:0] ext_sinal;
    input [6:0] valor;
    begin
        if (valor[6] == 1'b1) // negativo
            ext_sinal = {7'b1111111, valor}; // extensão com sinal
        else
            ext_sinal = {7'b0000000, valor};
    end
endfunction

always @(posedge clk) begin
    case (opcode)
        LOAD:  q <= ext_sinal(op2);                 // extensão de sinal
        ADD:   q <= ext_sinal(op1) + ext_sinal(op2);
        SUB:   q <= ext_sinal(op1) - ext_sinal(op2);
        MUL:   q <= ext_sinal(op1) * ext_sinal(op2); // resultado 14 bits
        CLEAR: q <= 0;
        default: q <= q;
    endcase
end

// LED de sinal (1 se negativo)
assign led_sinal = q[13];

// Magnitude absoluta
assign led_valor = (q[13]) ? (~q + 14'd1) : q; // módulo em complemento de dois

endmodule
