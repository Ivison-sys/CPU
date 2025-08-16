module codificador (
    input clk,
    input [2:0] opcode,
    input [3:0] destino,
    output reg [87:0] palavra,
    output reg [10:0] RS_list
);

parameter LOAD = 3'b000, ADD = 3'b001, ADDI = 3'b010, SUB = 3'b011, SUBI = 3'b100, MUL = 3'b101, CLEAR = 3'b110, DPL = 3'b111;

always @(posedge clk) begin 
    case (opcode)
        LOAD: begin 
            palavra[7:0] <= 8'h4C; // l
            palavra[15:8] <= 8'h4F; // O
            palavra[23:16] <= 8'h41; // A
            palavra[31:24] <= 8'h44; // D
            palavra[39:32] <= 8'h89; // ir para coluna 10, linha 1
            palavra[47:40] <= 8'h5B; // [
            palavra[55:48] <= 8'h30 + destino[3]; // 1
            palavra[63:56] <= 8'h30 + destino[2]; // 1
            palavra[71:64] <= 8'h30 + destino[1]; // 1
            palavra[79:72] <= 8'h30 + destino[0]; // 1
            palavra[87:80] <= 8'h5D; // ]
        end
        ADD: begin 
            palavra[7:0] <= 8'h41; // A
            palavra[15:8] <= 8'h44; // D
            palavra[23:16] <= 8'h44; // D
            palavra[31:24] <= 8'h89; // ir para coluna 10, linha 1
            palavra[39:32] <= 8'h5B; // [
            palavra[47:40] <= 8'h30 + destino[3]; // 1
            palavra[55:48] <= 8'h30 + destino[2]; // 1
            palavra[63:56] <= 8'h30 + destino[1]; // 1
            palavra[71:64] <= 8'h30 + destino[0]; // 1
            palavra[79:72] <= 8'h5D; // ]
            palavra[87:80] <=  8'h02; // curso home
        end
        ADDI: begin 
            palavra[7:0] <= 8'h41; // A
            palavra[15:8] <= 8'h44; // D
            palavra[23:16] <= 8'h44; // D
            palavra[31:24] <= 8'h49; // I
            palavra[39:32] <= 8'h89; // ir para coluna 10, linha 1
            palavra[47:40] <= 8'h5B; // [
            palavra[55:48] <= 8'h30 + destino[3]; // 1
            palavra[63:56] <= 8'h30 + destino[2]; // 1
            palavra[71:64] <= 8'h30 + destino[1]; // 1
            palavra[79:72] <= 8'h30 + destino[0]; // 1
            palavra[87:80] <= 8'h5D; // ]
        end
        SUB: begin 
            palavra[7:0] <= 8'h53; // S
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h42; // B
            palavra[31:24] <= 8'h89; // ir para coluna 10, linha 1
            palavra[39:32] <= 8'h5B; // [
            palavra[47:40] <= 8'h30 + destino[3]; // 1
            palavra[55:48] <= 8'h30 + destino[2]; // 1
            palavra[63:56] <= 8'h30 + destino[1]; // 1
            palavra[71:64] <= 8'h30 + destino[0]; // 1
            palavra[79:72] <= 8'h5D; // ]
            palavra[87:80] <=  8'h02; // curso home
        end
        SUBI: begin 
            palavra[7:0] <= 8'h53; // S
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h42; // B
            palavra[31:24] <= 8'h49; // I
            palavra[39:32] <= 8'h89; // ir para coluna 10, linha 1
            palavra[47:40] <= 8'h5B; // [
            palavra[55:48] <= 8'h30 + destino[3]; // 1
            palavra[63:56] <= 8'h30 + destino[2]; // 1
            palavra[71:64] <= 8'h30 + destino[1]; // 1
            palavra[79:72] <= 8'h30 + destino[0]; // 1
            palavra[87:80] <= 8'h5D; // ]
        end
        MUL: begin 
            palavra[7:0] <= 8'h4D; // M
            palavra[15:8] <= 8'h55; // U
            palavra[23:16] <= 8'h4C; // L
            palavra[31:24] <= 8'h89; // ir para coluna 10, linha 1
            palavra[39:32] <= 8'h5B; // [
            palavra[47:40] <= 8'h30 + destino[3]; // 1
            palavra[55:48] <= 8'h30 + destino[2]; // 1
            palavra[63:56] <= 8'h30 + destino[1]; // 1
            palavra[71:64] <= 8'h30 + destino[0]; // 1
            palavra[79:72] <= 8'h5D; // ]
            palavra[87:80] <=  8'h02; // curso home
        end
        CLEAR: begin 
            palavra[7:0] <= 8'h43; // C
            palavra[15:8] <= 8'h4C; // l
            palavra[23:16] <= 8'h45; // E
            palavra[31:24] <= 8'h41; // A
            palavra[39:32] <= 8'h52; // R
             palavra[47:40] <= 8'h02; // curso home
            palavra[55:48] <= 8'h02; // curso home
            palavra[63:56] <= 8'h02; // curso home
            palavra[71:64] <= 8'h02; // curso home
            palavra[79:72] <= 8'h02; // curso home 
            palavra[87:80] <= 8'h02; // curso home
        end
        DPL: begin 
            palavra[7:0] <= 8'h44; // D
            palavra[15:8] <= 8'h50; // P
            palavra[23:16] <= 8'h4C; // L
            palavra[31:24] <= 8'h89; // ir para coluna 10, linha 1
            palavra[39:32] <= 8'h5B; // [
            palavra[47:40] <= 8'h30 + destino[3]; // 1
            palavra[55:48] <= 8'h30 + destino[2]; // 1
            palavra[63:56] <= 8'h30 + destino[1]; // 1
            palavra[71:64] <= 8'h30 + destino[0]; // 1
            palavra[79:72] <= 8'h5D; // ]
            palavra[87:80] <= 8'h02; // curso home
        end 
        default: begin end
    endcase
end

// Controlando o valor de RS do LCD
always @(posedge clk) begin
    if(opcode == LOAD || opcode == ADDI || opcode == SUBI) begin 
        RS_list[0] <= 1;
        RS_list[1] <= 1;
        RS_list[2] <= 1;
        RS_list[3] <= 1;
        RS_list[4] <= 0;
        RS_list[5] <= 1;
        RS_list[6] <= 1;
        RS_list[7] <= 1;
        RS_list[8] <= 1;
        RS_list[9] <= 1;
        RS_list[10] <= 1;
    end else if(opcode == ADD || opcode == SUB || opcode == MUL || opcode == DPL) begin 
        RS_list[0] <= 1;
        RS_list[1] <= 1;
        RS_list[2] <= 1;
        RS_list[3] <= 0;
        RS_list[4] <= 1;
        RS_list[5] <= 1;
        RS_list[6] <= 1;
        RS_list[7] <= 1;
        RS_list[8] <= 1;
        RS_list[9] <= 1;
        RS_list[10] <= 0;
    end else if(opcode == CLEAR) begin 
        RS_list[0] <= 1;
        RS_list[1] <= 1;
        RS_list[2] <= 1;
        RS_list[3] <= 1;
        RS_list[4] <= 1;
        RS_list[5] <= 0;
        RS_list[6] <= 0;
        RS_list[7] <= 0;
        RS_list[8] <= 0;
        RS_list[9] <= 0;
        RS_list[10] <= 0;
    end
end
endmodule