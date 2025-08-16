module cpu(
    // input dos switchs 
    input wire [2:0]op,
    input wire [3:0] D1,
    input wire [3:0] R2
    input wire [6:0]ImmR3,
    
    // input  dos botao key3 e key2
    input botao1,
    input botao2,
    
    // input do lcd
    input EN,
    input RS,
    input WR,
    input clk
    output reg[7:0] dado,


);



wire [15:0] R2_value;
wire [15:0] R3_value;


ram16_16 carregando_R2(
    .data(16'b0),
    .addr(R2),
    .we(0),
    .clk(clk),
    .q(R2_value)
);
ram16_16 carregando_R3(
    .data(16'b0),
    .addr(ImmR3[6:3]),
    .we(0),
    .clk(clk),
    .q(R3_value)
);



operacoes operation(
    .op(opcode),
    .rg2(R2_value),
    .rg3(R3_value),
    .Imm(ImmR3),
    .D1()
    
);


endmodule