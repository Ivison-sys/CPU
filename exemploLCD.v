module bcd (
    input btn,
    input clk,
    output reg[7:0] data,
    output reg EN, RW, RS,
    output reg ld
);

parameter LIGADO= 0, DESLIGADO= 1;
reg estadoAtual = DESLIGADO;
reg oldBtn = 1;
reg ativo = DESLIGADO;

// Variaveis relacionadas ao LCD
reg [31:0] counterA = 0;
reg [31:0] counterB = 0;
parameter MS = 50_000;
parameter WRITE = 0, WAIT = 1;
reg [3:0] stateA = WRITE;
reg [3:0] stateB = WRITE;
reg [7:0] instructionsA = 0;
reg [7:0] instructionsB = 0;


initial begin
	data = 0;
	EN = 0; //Enable
	RW = 0; //Read/Write
	RS = 0;//
end


always @(posedge clk) begin
    if(oldBtn == 0 && btn ==1) begin 
        case (estadoAtual)
           LIGADO: begin estadoAtual <= DESLIGADO; end
           DESLIGADO: begin estadoAtual <= LIGADO; end
        endcase
    end
    oldBtn <= btn;
end

always @(estadoAtual) begin
    case (estadoAtual)
        LIGADO: begin ativo <= LIGADO; end 
        DESLIGADO: begin
            ativo <= DESLIGADO; 

        end 
    endcase
end

always @(posedge clk) begin
    if(ativo == LIGADO) begin
		  instructionsB <= 0;
		  counterB <= 0;
        case (stateA)
            WRITE: begin
                if(counterA == MS) begin
                    stateA = WAIT;
                    counterA = 0;
                end else begin
                    counterA = counterA + 1;
                end
            end
            WAIT: begin
                if(counterA == MS - 1) begin
                    stateA = WRITE;
                    counterA = 0;
                    if(instructionsA < 20) instructionsA = instructionsA + 1;
                end else begin
                    counterA = counterA + 1;
                end
            end
            default : begin end
        endcase
    end else begin 
        instructionsA <= 0;
		  counterA <= 0;
        case (stateB)
            WRITE: begin
                if(counterB == MS) begin
                    stateB = WAIT;
                    counterB = 0;
                end else begin
                    counterB = counterB + 1;
                end
            end
            WAIT: begin
                if(counterB == MS - 1) begin
                    stateB = WRITE;
                    counterB = 0;
                    if(instructionsB < 3) instructionsB = instructionsB + 1;
                end else begin
                    counterB = counterB + 1;
                end
            end
            default : begin end
        endcase
    end
end

always @(posedge clk) begin
    if(ativo == LIGADO) begin
        case (stateA)
            WRITE: EN <= 1;
            WAIT: EN <= 0;
            default: EN <= EN;
        endcase
        case (instructionsA)
            0: begin data <= 8'h38; RS <= 0; end //Habilita o modo de 8 bits, adiciona a segunda linha
            1: begin data <= 8'h0C; RS <= 0; end //Display ON, Cursos ON, Blink OFF
            2: begin data <= 8'h01; RS <= 0; end //Clear
            3: begin data <= 8'h02; RS <= 0; end //Cursor Home
            4: begin data <= 8'h06; RS <= 0; end // Pula o cursor quando printa
            5: begin data <= 8'h48; RS <= 1; end //H
            6: begin data <= 8'h65; RS <= 1; end //E
            7: begin data <= 8'h6C; RS <= 1; end //L
            8: begin data <= 8'h6C; RS <= 1; end //L
            9: begin data <= 8'h6F; RS <= 1; end //O
            10:begin data <= 8'hC0; RS <= 0; end //Space
            11: begin data <= 8'h57; RS <= 1; end //W
            12: begin data <= 8'h6F; RS <= 1; end //O
            13: begin data <= 8'h72; RS <= 1; end //R
            14: begin data <= 8'h6C; RS <= 1; end //L
            15: begin data <= 8'h64; RS <= 1; end //D
            16: begin data <= 8'h21; RS <= 1; end //!
            17: begin data <= 8'h21; RS <= 1; end //!
            18: begin data <= 8'h3a; RS <= 1; end //:
            19: begin data <= 8'h44; RS <= 1; end //D
            default: begin data <= 8'h02; RS <= 0; end
        endcase
    end
    else begin 
        case (stateB)
            WRITE: EN <= 1;
            WAIT: EN <= 0;
            default: EN <= EN;
        endcase
        case (instructionsB)
            0: begin data <= 8'h38; RS <= 0; end //Habilita o modo de 8 bits, adiciona a segunda linha
            1: begin data <= 8'h0C; RS <= 0; end //Display ON, Cursos ON, Blink OFF
            2: begin data <= 8'h01; RS <= 0; end //Clear
            default: begin data <= 8'h02; RS <= 0; end
        endcase
    end
end
endmodule

