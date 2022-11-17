module Fila_de_Instrucao(clock, sinal, instrucao);
	
	input clock;
	
	//sinal para saber se podemos despachar uma instrução
	
	input sinal;
	
	output [15:0] instrucao;
	
	reg [15:0] temp;
	
	reg [15:0] Fila [255:0];
	
	reg [7:0] endereco;
	
	initial begin
		endereco = 8'b00000000;
		//deve-se começar no 1 pois se não da ruim
		Fila[0] = 16'b0000110010100000;
		Fila[1] = 16'b0101010110010000;
		Fila[2] = 16'b0001011001100000;
		Fila[3] = 16'b1001101011000000;
		Fila[4] = 16'b1000101010110000;
		Fila[5] = 16'b0101101011000000;
		Fila[6] = 16'b0001101011010000;
	end
	
	always@(negedge clock)
	begin
		if(sinal)
			endereco <= endereco + 1;
	end
	
	always@(*)
	begin
		temp <= Fila[endereco];
	end

	assign instrucao = temp;
	
endmodule
