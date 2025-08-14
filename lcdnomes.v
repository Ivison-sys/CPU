module top(
 output reg[7:0] data,
 output reg EN, RW, RS,
 
 input clk
);

initial begin
 data = 0;
 EN = 0; //Enable
 RW = 0; //Read/Write
 RS = 0;//
end

reg [31:0] counter = 0;
parameter MS = 50_000;
parameter WRITE = 0, WAIT = 1;
reg [3:0] state = WRITE;

reg [7:0] instructions = 0;


always @(posedge clk) begin
 case (state)
  WRITE: begin
   if(counter == MS) begin
    state = WAIT;
    counter = 0;
   end else begin
    counter = counter + 1;
   end
  end
  WAIT: begin
   if(counter == MS - 1) begin
    state = WRITE;
    counter = 0;
    if(instructions < 20) instructions = instructions + 1;
   end else begin
    counter = counter + 1;
   end
 
  end
  default : begin end
 endcase
end

initial begin
//INICIALIZAÇÃO
  0: begin data <= 8'h38; RS <= 0; end //Habilita o modo de 8 bits, adiciona a segunda linha
  1: begin data <= 8'h0E; RS <= 0; end //Display ON, Cursos ON, Blink OFF
  2: begin data <= 8'h01; RS <= 0; end //Clear
  3: begin data <= 8'h02; RS <= 0; end //Cursor Home  
  4: begin data <= 8'h06; RS <= 0; end // Pula o cursor quando printa
end 

always @(posedge clk) begin
 case (state)
  WRITE: EN <= 1;
  WAIT: EN <= 0;
  default: EN <= EN;
 endcase
 
 case (instructions)

 
//DADOS
  LOAD:begin
    5: begin data <= 8'h4C; RS <= 1; end //L
    6: begin data <= 8'h4F; RS <= 1; end //O
    7: begin data <= 8'h41; RS <= 1; end //A
    8: begin data <= 8'h44; RS <= 1; end //D
  end
  
  ADD:begin
    5: begin data <= 8'h41; RS <= 1; end //A
    6: begin data <= 8'h44; RS <= 1; end //D
    7: begin data <= 8'h44; RS <= 1; end //D
  end
  
  ADDI:begin
    5: begin data <= 8'h41; RS <= 1; end //A
    6: begin data <= 8'h44; RS <= 1; end //D
    7: begin data <= 8'h44; RS <= 1; end //D
    8: begin data <= 8'h49; RS <= 1; end //I
  end
  
  SUB:begin
    5: begin data <= 8'h53; RS <= 1; end //S
    6: begin data <= 8'h55; RS <= 1; end //U
    7: begin data <= 8'h42; RS <= 1; end //B
  end

  SUBI:begin  
  5: begin data <= 8'h53; RS <= 1; end //S
  6: begin data <= 8'h55; RS <= 1; end //U
  7: begin data <= 8'h42; RS <= 1; end //B
  8: begin data <= 8'h49; RS <= 1; end //I
  end
  MUL:begin
    5: begin data <= 8'h4D; RS <= 1; end //M
    6: begin data <= 8'h55; RS <= 1; end //U
    7: begin data <= 8'h4C; RS <= 1; end //L
  end
  CLEAR:begin  
    5: begin data <= 8'h43; RS <= 1; end //C
    6: begin data <= 8'h4C; RS <= 1; end //L
    7: begin data <= 8'h45; RS <= 1; end //E
    8: begin data <= 8'h41; RS <= 1; end //A
    9: begin data <= 8'h52; RS <= 1; end //R
  end
  DPL:begin
    5: begin data <= 8'h44; RS <= 1; end //D
    6: begin data <= 8'h50; RS <= 1; end //P
    7: begin data <= 8'h4C; RS <= 1; end //L
  end

  default: begin data <= 8'h02; RS <= 0; end
 endcase
end

endmodule