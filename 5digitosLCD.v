module decompositor (
    input  [15:0] numero,
    output reg [3:0] unidade, 
    output reg [3:0] dezena,  
    output reg [3:0] centena, 
    output reg [3:0] milhar,  
    output reg [3:0] dezena_milhar,
    output reg sinal // 0 = positivo, 1 = negativo
);

    reg [15:0] temp;

    always @(*) begin
        if (numero[15] == 0) begin
            sinal = 0;
            temp = numero;
        end else begin
            sinal = 1;
            temp = ~numero + 1; // valor absoluto (complemento de 2)
        end

        unidade       = temp % 10;
        dezena        = (temp / 10) % 10;
        centena       = (temp / 100) % 10;
        milhar        = (temp / 1000) % 10;
        dezena_milhar = (temp / 10000) % 10;
    end

endmodule