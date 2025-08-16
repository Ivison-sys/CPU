module ram16_16 (
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
      ram[1] <= 0;
      ram[2] <= 0;
      ram[3] <= 0;
      ram[4] <= 0;
      ram[5] <= 0;
      ram[6] <= 0;   
      ram[7] <= 0;
      ram[8] <= 0;
      ram[9] <= 0;
      ram[10] <= 0;
      ram[11] <= 0;
      ram[12] <= 0;
      ram[13] <= 0;
      ram[14] <= 0;
      ram[15] <= 0;
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

