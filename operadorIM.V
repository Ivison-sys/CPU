module operacoes(
    input [6:0] op1,
    input [6:0] op2,
    input clk,
    input [2:0] opcode,
    output reg[6:0] q,
	
    
    
);

parameter LOAD = 3'b000, ADD1= 3'b010, SUBI = 3'b100, MUL = 3'b101;

always @(posedge clk) begin
    case(opcode)
    LOAD: begin
    if(op2[6] ==0) q <= op2;
    else q <= op2 * -1;
    end  
    ADD1: if(op2[6] == 0) q <= (op1 + op2 );
        else q <= (op1 + op2 )*-1;

    SUBI:begin        
    if(op2[6] == 0) q <= (op1 + op2 );
        else q <= (op1 + op2 )*-1;
    end
    MUL:  begin 
    if(op2[6] ==0) q <= (op1 * op2 );
        else q <= (op1 + op2 )*-1;
    end

	endcase
end


endmodule
