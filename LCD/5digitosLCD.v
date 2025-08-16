module ProjetoCPUUU (
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























/*module teste(
    input clk,                // clock de 50MHz da DE2-115
    input [6:0] imediato,
    output reg [7:0] data,     // barramento de dados do LCD
    output reg RS,              // modo: 0 = comando, 1 = caractere
    output reg EN,              // enable do LCD
    output reg RW               // 0 = escrita
);

    // Variáveis internas
	 reg sinal;
    reg [7:0] saida;
    reg [3:0] dezenasmilhares, milhares, centenas, dezenas, unidades;
    reg [4:0] estado; // Aumentado para [4:0] para acomodar novos estados
    reg [7:0] ultimo_valor;
    reg [19:0] delay_count; // contador para dar tempo ao LCD

    // ===== Conversão Binário -> BCD =====
    always @* begin
        saida    = imediato[5:0];
		sinal = imediato[6];
		dezenasmilhares = saida/10000;
		milhares = saida/1000;
        centenas = saida / 100;
        dezenas  = (saida % 100) / 10;
        unidades = saida % 10;
    end

    // ===== Sequência de inicialização + escrita =====
    always @(posedge clk) begin
        RW <= 0; // sempre escrevendo no LCD

        // contador de delay
        if (delay_count != 0) begin
            delay_count <= delay_count - 1;
            EN <= 0; // Garante que EN fique baixo durante o delay
        end else begin
            case (estado)
                // ===== Inicialização do LCD (executa apenas uma vez) =====
                0: begin data <= 8'h38; RS <= 0; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end // Function Set: 8-bit, 2-line
                1: begin                                  estado <= estado + 1; delay_count <= 100_000; end // Desativa EN

                2: begin data <= 8'h0C; RS <= 0; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end // Display ON, Cursor OFF
                3: begin                                  estado <= estado + 1; delay_count <= 100_000; end // Desativa EN

                4: begin data <= 8'h01; RS <= 0; EN <= 1; estado <= estado + 1; delay_count <= 200_000; end // Clear Display
                5: begin                                  estado <= estado + 1; delay_count <= 100_000; ultimo_valor <= imediato + 1; end // Desativa EN e força a primeira escrita

                // Estado de espera até o valor do switches
                6: begin
                    if (imediato != ultimo_valor) begin
                        ultimo_valor <= imediato; // Salva o novo valor
                        estado <= estado + 1;     // Prossiga para limpar a tela e escrever
                    end else begin
                        estado <= 6; // Permanece em espera
                    end
                end
					 

                // ===== Limpa a tela antes de escrever um novo número =====
                7: begin data <= 8'h01; RS <= 0; EN <= 1; estado <= estado + 1; delay_count <= 200_000; end // Clear Display
                8: begin                                  estado <= estado + 1; delay_count <= 100_000; end // Desativa EN
					 

                //  Escrita dos dígitos
                // Escreve o sinal
				9: begin data<=(sinal == 1'b1)? 8'h2D: 8'h2B  ; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 200_000; end // Clear Display
                10: begin                                  estado <= estado+1; delay_count <= 100_000; end 
                // Dezenas de milhares
				11: begin data <= 8'h30 + dezenasmilhares; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end
                12: begin                                 estado <= estado + 1; delay_count <= 100_000; end
                // Milhares
				13: begin data <= 8'h30 + milhares; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end
                14: begin                                 estado <= estado + 1; delay_count <= 100_000; end
                // Centenas
                15: begin data <= 8'h30 + centenas; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end
                16: begin                                 estado <= estado + 1; delay_count <= 100_000; end

                // Dezenas
                17: begin data <= 8'h30 + dezenas; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end
                18: begin                                 estado <= estado + 1; delay_count <= 100_000; end

                // Unidades
                19: begin data <= 8'h30 + unidades; RS <= 1; EN <= 1; estado <= estado + 1; delay_count <= 100_000; end
                20: begin                                 estado <= 0; delay_count <= 100_000; end // Escrita finalizada, VOLTA PARA O ESTADO DE ESPERA (6)
					 
                default: estado <= 0; // Estado seguro para caso algo dê errado
            endcase
        end
    end

endmodule