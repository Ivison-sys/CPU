module ram16_8 (
    input  wire [15:0] data,
    input  wire [3:0] addr,
    input  wire       we,
    input  wire       clk,
    output wire [15:0] q
);


    // declaracao da memoria RAM
    reg [15:0] ram [15:0];

    // registrador para armazenar o endereço de leitura
    reg [3:0] addr_reg;  // 2^4 = 16 posicoes de memoria
  
    //inicializacao da memoria
    initial begin 
      ram[0] <= 0;
      ram[1] <= 1;
      ram[2] <= 2;
      ram[3] <= 3;
      ram[4] <= 4;
      ram[5] <= 5;
      ram[6] <= 6;   
      ram[7] <= 7;
      ram[8] <= 8;
      ram[9] <= 9;
      ram[10] <= 10;
      ram[11] <= 11;
      ram[12] <= 12;
      ram[13] <= 13;
      ram[14] <= 14;
      ram[15] <= 15;
    end

    always @(posedge clk) begin
        // escrita na memoria
        if (we)
            ram[addr] <= data;

        // registro do endereco de leitura
        addr_reg <= addr;
    end

    // leitura assincrona com base no endereco registrado
    assign q = ram[addr_reg];

