module bcd(
output reg[7:0] data,
output reg EN, RW, RS,
input rst,
input clk
);

initial begin
data = 0;
EN = 0; //Enable
RW = 0; //Read/Write
RS = 0;//
end


reg [3:0] uni = 4;
reg [3:0] dez = 5;
reg [31:0] counter = 0;
parameter MS = 50_000;
parameter WRITE = 0, WAIT = 1;
reg [3:0] state = WRITE;
reg [7:0] instructions = 0;
reg old

always @(posedge clk) begin
    case (state)
        WRITE: begin
            if(counter == MS) begin

                state = WAIT;
                counter = 0;
                end
                end
                end
                WAIT: begin
                if(counter == MS - 1) begin
                state = WRITE;
                counter = 0;
                if(instructions < 6) instructions = instructions + 1;

            end else begin
                counter = counter + 1;
            end
        end
        default : begin end
    endcase
end

always @(posedge clk) begin
    case (state)
        WRITE: EN <= 1;
        WAIT: EN <= 0;
        default: EN <= EN;
    endcase
    case (instructions)
        0: begin data <= 8'h38; RS <= 0; end //Habilita o modo de 8 bits, adiciona a
        1: begin data <= 8'h0c; RS <= 0; end //Display ON, Cursos OF, Blink OFF
        2: begin data <= 8'h01; RS <= 0; end //Clear
        3: begin data <= 8'h02; RS <= 0; end //Cursor Home
        4: begin

        case(dez)
            0: begin data <= 8'h30; RS <= 1; end // printa 0;
            1: begin data <= 8'h31; RS <= 1; end // printa 1;
            2: begin data <= 8'h32; RS <= 1; end // printa 2;
            3: begin data <= 8'h33; RS <= 1; end // printa 3;
            4: begin data <= 8'h34; RS <= 1; end // printa 4;
            5: begin data <= 8'h35; RS <= 1; end // printa 5;
            6: begin data <= 8'h36; RS <= 1; end // printa 6;
            7: begin data <= 8'h37; RS <= 1; end // printa 7;
            8: begin data <= 8'h38; RS <= 1; end // printa 8;
            9: begin data <= 8'h39; RS <= 1; end // printa 9;
        endcase

        end
        5: begin
            case(uni)
                0: begin data <= 8'h30; RS <= 1; end // printa 0;
                1: begin data <= 8'h31; RS <= 1; end // printa 1;
                2: begin data <= 8'h32; RS <= 1; end // printa 2;
                3: begin data <= 8'h33; RS <= 1; end // printa 3;
                4: begin data <= 8'h34; RS <= 1; end // printa 4;
                5: begin data <= 8'h35; RS <= 1; end // printa 5;
                6: begin data <= 8'h36; RS <= 1; end // printa 6;
                7: begin data <= 8'h37; RS <= 1; end // printa 7;
                8: begin data <= 8'h38; RS <= 1; end // printa 8;
                9: begin data <= 8'h39; RS <= 1; end // printa 9;
            endcase
        end

        6: begin data <= 8'h02; RS <= 0; end //Cursor Home
        
        7: begin  data <= 8'h08; RS <= 0; end


    default: begin data <= 8'h02; RS <= 0; end
    endcase
end
endmodule