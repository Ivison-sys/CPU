module bcd (
    input btn,
    input enviar,
    input clk,
    input [2:0] opcode,
    output reg[7:0] data,
    output reg EN, RW, RS
);

// Variáveis do estado geral do LCD
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

// Variáveis do estado;
parameter LOAD = 3'b000, ADD = 3'b001, ADDI = 3'b010, SUB = 3'b011, SUBI = 3'b100, MUL = 3'b101, CLEAR = 3'b110, DPL = 3'b111;
reg [2:0] op = 0;

// Palavra que vai ser printada
reg [39:0] palavra;

codificador cod(
    .clk(clk),
    .opcode(opcode),
    .palavra(palavra)
);


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
            1: begin data <= 8'h0C; RS <= 0; end //Display ON, Cursos OFF, Blink OFF
            2: begin data <= 8'h01; RS <= 0; end //Clear
            3: begin data <= 8'h02; RS <= 0; end //Cursor Home
            4: begin data <= 8'h06; RS <= 0; end // Pula o cursor quando printa
            5: begin data <= palavra[7:0]; RS <= 0; end
            6: begin data <= palavra[15:8]; RS <= 0; end
            7: begin data <= palavra[23:16]; RS <= 0; end
            8: begin data <= palavra[31:24]; RS <= 0; end
            9: begin data <= palavra[39:32]; RS <= 0; end
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

