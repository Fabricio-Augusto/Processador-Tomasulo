module estacaoDeReservaMulDiv(instrucao, clock,sinal_1_Dependencia, sinal_2_Dependencia, Vj, Vk, Qj, Qk, out0, out1,
teveEscritaCDB, nameCDB, dadoCDB, teveDespacho, reg_write, dadoPronto, operation, nameForCDB, nameForRegs);
	
	input clock;
	input [15:0] Vj, Vk;
	input [2:0] Qj, Qk;
	input [15:0] instrucao;
	input sinal_1_Dependencia;
	input sinal_2_Dependencia;
	input teveEscritaCDB;
	input [2:0] nameCDB;
	input [15:0] dadoCDB;
	output [15:0] out0, out1;
	output reg teveDespacho;
	output reg [2:0] reg_write;
	output dadoPronto;
	output operation;
	output [2:0] nameForCDB;
	output reg [2:0] nameForRegs;
	
	//0 desocupado e 1 ocupado
	//output Busy;
	
	// 44:42->name | 41->Busy | 40:38->Op | 37:22->Vj | 21:6->Vk | 5:3->Qj | 2:0->Qk
	reg [44:0] RS1;
	reg [44:0] RS2;
	reg [44:0] RS3;
	reg [5:0] dadoValido;
	reg [1:0] state_rs1;
	reg [1:0] state_rs2;
	reg [1:0] state_rs3;
	
	initial begin
		RS1[44:42] = 3'b100;
		RS1[41:0] = 0;
		RS2[44:42] = 3'b101;
		RS2[41:0] = 0;
		RS3[44:42] = 3'b110;
		RS3[41:0] = 0;
		dadoValido = 0;
		state_rs1 = 2'b00;
		state_rs2 = 2'b00;
		state_rs3 = 2'b00;
	end
	
	reg BUSY;
	
	always@(posedge clock)
	begin
				
		if(teveEscritaCDB)
		begin
			
			if(nameCDB == RS1[43:42])
				RS1[41] = 0;
			else if(nameCDB == RS2[43:42])
				RS2[41] = 0;
			else if(nameCDB == RS3[43:42])
				RS3[41] = 0;
			
			if(dadoValido[1] == 0 && RS1[5:3] == nameCDB)
			begin
				 RS1[37:22] = dadoCDB;
				 dadoValido[1] = 1'b1;
			end
			
			if(dadoValido[0] == 0 && RS1[2:0] == nameCDB)
			begin
				RS1[21:6] = dadoCDB;
				dadoValido[0] = 1'b1;
			end
			
			if(dadoValido[3] == 0 && RS2[5:3] == nameCDB)
			begin
				 RS2[37:22] = dadoCDB;
				 dadoValido[3] = 1'b1;
			end
			
			if(dadoValido[2] == 0 && RS2[2:0] == nameCDB)
			begin
				RS2[21:6] = dadoCDB;
				dadoValido[2] = 1'b1;
			end
			
			if(dadoValido[5] == 0 && RS3[5:3] == nameCDB)
			begin
				 RS3[37:22] = dadoCDB;
				 dadoValido[5] = 1'b1;
			end
			
			if(dadoValido[4] == 0 && RS3[2:0] == nameCDB)
			begin
				RS3[21:6] = dadoCDB;
				dadoValido[4] = 1'b1;
			end
			
		end
		
		if(state_rs1 == 2'b11)begin
			state_rs1 = 2'b00;
			dadoValido[1:0] = 2'b00;
		end
		if(state_rs2 == 2'b11)begin
			state_rs2 = 2'b00;
			dadoValido[3:2] = 2'b00;
		end
		if(state_rs3 == 2'b11)begin
			state_rs3 = 2'b00;
			dadoValido[5:4] = 2'b00;
		end
		
		if(dadoValido[0] == 1 && dadoValido[1] == 1 && state_rs1 == 2'b00)
			if(state_rs2 != 2'b10 && state_rs2 != 2'b11 && state_rs3 != 2'b10 && state_rs3 != 2'b11)
				state_rs1 = 2'b10;
			else
				state_rs1 = 2'b01;
		else if(state_rs1 == 2'b01 && state_rs2 != 2'b10 && state_rs2 != 2'b11 && state_rs3 != 2'b10 && state_rs3 != 2'b11)
			state_rs1 = 2'b10;
		else if(state_rs1 == 2'b10)
			state_rs1 = 2'b11;
		
		
		if(state_rs2 == 2'b01 && state_rs1 != 2'b10 && state_rs1 != 2'b11 && state_rs3 != 2'b10 && state_rs3 != 2'b11)
			state_rs2 = 2'b10;
		else if(dadoValido[2] == 1 && dadoValido[3] == 1 && state_rs2 == 2'b00)
			if(state_rs1 != 2'b10 && state_rs1 != 2'b11 && state_rs3 != 2'b10 && state_rs3 != 2'b11)
				state_rs2 = 2'b10;
			else
				state_rs2 = 2'b01;
		else if(state_rs2 == 2'b10)
			state_rs2 = 2'b11;
		
		
		if(state_rs3 == 2'b01 && state_rs1 != 2'b10 && state_rs1 != 2'b11 && state_rs2 != 2'b10 && state_rs2 != 2'b11)
			state_rs3 = 2'b10;
		else if(dadoValido[4] == 1 && dadoValido[5] == 1 && state_rs3 == 2'b00)
			if(state_rs1 != 2'b10 && state_rs1 != 2'b11 && state_rs2 != 2'b10 && state_rs2 != 2'b11)
				state_rs3 = 2'b10;
			else
				state_rs3 = 2'b01;
		else if(state_rs3 == 2'b10)
			state_rs3 = 2'b11;
		
		if(~RS1[41] && instrucao[15] == 1)
		begin
			
			teveDespacho = 1'b1;
			reg_write = instrucao[12:10];
			
			if(sinal_1_Dependencia)
			begin
				RS1[5:3] = Qj;
				dadoValido[1] = 1'b0;
			end
			else
			begin
				RS1[37:22] = Vj;
				dadoValido[1] = 1'b1;
			end
				
			if(sinal_2_Dependencia)
			begin
				RS1[2:0] = Qk;
				dadoValido[0] = 1'b0;
			end
			else
			begin
				RS1[21:6] = Vk;
				dadoValido[0] = 1'b1;
			end
			
			RS1[41] = 1'b1;
			RS1[40:38] = instrucao[15:13];
			nameForRegs = 3'b100;
			
		end
		else if(~RS2[41] && instrucao[15] == 1)
		begin
			
			teveDespacho = 1'b1;
			reg_write = instrucao[12:10];
			
			if(sinal_1_Dependencia)
			begin
				RS2[5:3] = Qj;
				dadoValido[3] = 1'b0;
			end
			else
			begin
				RS2[37:22] = Vj;
				dadoValido[3] = 1'b1;
			end
				
			if(sinal_2_Dependencia)
			begin
				RS2[2:0] = Qk;
				dadoValido[2] = 1'b0;
			end
			else
			begin
				RS2[21:6] = Vk;
				dadoValido[2] = 1'b1;
			end
			
			RS2[41] = 1'b1;
			RS2[40:38] = instrucao[15:13];
			nameForRegs = 3'b101;
			
		end
		else if(~RS3[41] && instrucao[15] == 1)
		begin
			
			teveDespacho = 1'b1;
			reg_write = instrucao[12:10];
			
			if(sinal_1_Dependencia)
			begin
				RS3[5:3] = Qj;
				dadoValido[5] = 1'b0;
			end
			else
			begin
				RS3[37:22] = Vj;
				dadoValido[5] = 1'b1;
			end
				
			if(sinal_2_Dependencia)
			begin
				RS3[2:0] = Qk;
				dadoValido[4] = 1'b0;
			end
			else
			begin
				RS3[21:6] = Vk;
				dadoValido[4] = 1'b1;
			end
			
			RS3[41] = 1'b1;
			RS3[40:38] = instrucao[15:13];
			nameForRegs = 3'b110;
			
		end
		else
			teveDespacho = 1'b0;
					
	end
	
	reg [15:0] temp_out0, temp_out1;
	reg temp_op, temp_dadoPronto;
	reg [2:0] temp_name;
	
	always@(*)
	begin
		if(state_rs1 == 2'b11)
		begin
			temp_out0 = RS1[37:22];
			temp_out1 = RS1[21:6];
			temp_op = RS1[39];
			temp_name = 3'b100;
			temp_dadoPronto = 1'b1;
		end
		else if(state_rs2 == 2'b11)
		begin
			temp_out0 = RS2[37:22];
			temp_out1 = RS2[21:6];
			temp_op = RS2[39];
			temp_name = 3'b101;
			temp_dadoPronto = 1'b1;
		end
		else if(state_rs3 == 2'b11)
		begin
			temp_out0 = RS3[37:22];
			temp_out1 = RS3[21:6];
			temp_op = RS3[39];
			temp_name = 3'b110;
			temp_dadoPronto = 1'b1;
		end
		else
			temp_dadoPronto = 1'b0;
	end
	
	assign dadoPronto = temp_dadoPronto;
	assign operation = temp_op;
	assign out0 = temp_out0;
	assign out1 = temp_out1;
	assign nameForCDB = temp_name;
	
endmodule
