module lcd(
    input wire clk,
    input wire [6:0] op1_in,
    input wire [6:0] op2_in,
    input wire [2:0] opcode,
    output reg [6:0] q,
    output reg [7:0] data,
    output reg EN,
    output reg RS
);

    // Registradores internos
    reg [6:0] op1;
    reg [3:0] estado;
    reg [3:0] instructions;

    // Estados
    parameter WAIT        = 4'd0,
              INIT_LCD    = 4'd1,
              OPERACOES   = 4'd2;

    // Instruções LCD
    parameter LCD_CMD0 = 4'd0,
              LCD_CMD1 = 4'd1,
              LCD_CMD2 = 4'd2,
              LCD_CMD3 = 4'd3,
              LCD_DONE = 4'd4;

    // OPCODES
    parameter LOAD    = 3'b000,
              ADD     = 3'b001,
              ADD1    = 3'b010,
              SUB     = 3'b011,
              SUBI    = 3'b100,
              MUL     = 3'b101,
              DISPLAY = 3'b111;

    always @(posedge clk) begin
        case (estado)

            // Espera inicial
            WAIT: begin
                EN <= 0;
                instructions <= LCD_CMD0;
                estado <= INIT_LCD;
            end

            // Sequência de inicialização do LCD
            INIT_LCD: begin
                case (instructions)
                    LCD_CMD0: begin data <= 8'h38; RS <= 0; instructions <= LCD_CMD1; end // Modo 8 bits, 2 linhas
                    LCD_CMD1: begin data <= 8'h0E; RS <= 0; instructions <= LCD_CMD2; end // Display ON, cursor ON
                    LCD_CMD2: begin data <= 8'h01; RS <= 0; instructions <= LCD_CMD3; end // Clear
                    LCD_CMD3: begin data <= 8'h02; RS <= 0; instructions <= LCD_DONE; end // Cursor home

            // Dados

                    LCD_CMD4: begin data <= 8'h4C; RS <= 0; instructions <= LCD_CMD1; end // L
                    LCD_CMD5: begin data <= 8'h4F; RS <= 0; instructions <= LCD_DONE; end // O
                    LCD_CMD6: begin data <= 8'h41; RS <= 0; instructions <= LCD_DONE; end // A
                    LCD_CMD7: begin data <= 8'h44; RS <= 0; instructions <= LCD_DONE; end // D

                    LCD_DONE: estado <= OPERACOES; // Vai para operações
                endcase
            end

            // Lógica da ULA
            OPERACOES: begin
                case (opcode)
                    LOAD:    op1 <= op2_in;
                    ADD:     q   <= op1 + op2_in;
                    ADD1:    q   <= op1 + 7'd1;
                    SUB:     q   <= op1 - op2_in;
                    SUBI:    q   <= op1 - 7'd1;
                    MUL:     q   <= op1 * op2_in;
                    DISPLAY: begin
                        RS <= 1; // Modo dado
                        data <= {1'b0, q}; // Mostra valor no LCD
                    end
                endcase
            end
    
        endcase
    end
    always @(posedge clk) begin

    end
endmodule
