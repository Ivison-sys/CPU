module cpu(
    input clk,
    // input dos switchs 
    input wire [2:0] op,
    input wire [3:0] destino,
    input wire [3:0] R2,
    input wire [6:0] inp,
    
    // input  dos botao key3 e key2
    input btn,
    input enviar,
    
    // input do lcd
    output wire EN, RS,RW,
    output wire[7:0] data
);

// Separando inp.
wire [6:0] Imm = inp;
wire [3:0] R3 = inp[6:3];

// Iniciando valores de r2 r3 e destino
wire [15:0] R2_value;
wire [15:0] R3_value;
wire [15:0] destino_value;
wire [15:0] destino_read;


wire activate; // Variável que controla o estado da memoria.

ram16_16 carregando_R2(
    .data(16'b0),
    .addr(R2),
    .we(0),
    .clk(clk),
    .q(R2_value)
);

ram16_16 carregando_R3(
    .data(16'b0),
    .addr(R3),
    .we(0),
    .clk(clk),
    .q(R3_value)
);

operacoes operation(
    .opcode(op),
    .rg2(R2_value),
    .rg3(R3_value),
    .Imm(Imm),
    .destino_value(destino_value),
    .memoria_ativa(activate)
);

ram16_16 atualizando_destino(
    .data(destino_value),
    .addr(destino),
    .we(activate),
    .clk(clk),
    .q(destino_read)
);

lcd display(
    .btn(btn),
    .enviar(enviar),
    .clk(clk),
    .opcode(op),
    .destino(destino),
    .value(destino_value),
    .data(data),
    .EN(EN), 
    .RW(RW), 
    .RS(RS)
);

endmodule