module Tomasulo(clock);
	
	//instrucao ooo xxx yyy zzz 0000
	// ooo->op | xxx-> reg destino | yyy->operando1 | zzz-> operando2
	//instrucao ooo xxx yyy DDDDDDD
	// ooo->op | xxx-> reg destino | yyy->operando1 | DDDDDDD -> imediato
	// ooo = 1??-> mul ou div | ooo = 0??-> add ou sub
	// 000 add
	// 001 addi
	// 010 sub
	// 011 subi
	// 100 mul
	// 101 muli
	// 110 div
	// 111 divi
	// desta forma instruçoes com ooo = ??1 são com imediato

	input clock;
	
	parameter _R0=3'b000, _R1=3'b001, _R2=3'b010, _R3=3'b011, _R4=3'b100, _R5=3'b101, _R6=3'b110, _R7=3'b111;
	
	wire [15:0] instrucao;
	
	wire [15:0] add_sub_op1, add_sub_op2, mul_div_op1, mul_div_op2;
	
	wire add_or_sub, mul_or_div;
	
	wire [15:0] out_fu1, out_fu2;
	
	//SINAIS
	wire wireSinalFIFO;
	wire teveDespacho1;
	wire teveDespacho2;
	wire s1, s2;
	wire writeCDB;
	wire sinal_1_Dependencia, sinal_2_Dependencia;
	
	wire [15:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7;
	wire [2:0] rename_out0, rename_out1, rename_out2, rename_out3, rename_out4, rename_out5, rename_out6, rename_out7;
	wire [15:0] out_Dado_CDB;
	wire [2:0] RS_Name;
	wire [2:0] nameForRegs1, nameForRegs2;
	wire [2:0] inRS_Name1, inRS_Name2;
	wire [2:0] in2;
	reg [2:0] reg_in2;
	wire [2:0] reg_write1;
	wire [2:0] reg_write2;
	reg [2:0] reg_reg_write;
	wire [2:0] reg_write;
	
	Fila_de_Instrucao FIFO(clock, wireSinalFIFO, instrucao);

	reg [15:0] temp1;
	wire [15:0] vj;
	
	always@(*)
	begin
	
		case(instrucao[9:7])
			_R0:
				temp1 = reg_out0;
			_R1:
				temp1 = reg_out1;
			_R2:
				temp1 = reg_out2;
			_R3:
				temp1 = reg_out3;
			_R4:
				temp1 = reg_out4;
			_R5:
				temp1 = reg_out5;
			_R6:
				temp1 = reg_out6;
			_R7:
				temp1 = reg_out7;
		endcase
		
	end
	
	assign vj = temp1;
	
	reg [15:0] temp2;
	wire [15:0] vk;
	
	always@(*)
	begin
		
		if(instrucao[13])
		begin
			temp2 = {{9{instrucao[6]}}, instrucao[5:0]};
		end
		else
		begin
		
			case(instrucao[6:4])
				_R0:
					temp2 = reg_out0;
				_R1:
					temp2 = reg_out1;
				_R2:
					temp2 = reg_out2;
				_R3:
					temp2 = reg_out3;
				_R4:
					temp2 = reg_out4;
				_R5:
					temp2 = reg_out5;
				_R6:
					temp2 = reg_out6;
				_R7:
					temp2 = reg_out7;
			endcase
		
		end
			
	end
	
	assign vk = temp2;
	
	reg [2:0] temp3;
	wire [2:0] Qj;
	
	always@(*)
	begin
		
		case(instrucao[9:7])
				_R0:
					temp3 = rename_out0;
				_R1:
					temp3 = rename_out1;
				_R2:
					temp3 = rename_out2;
				_R3:
					temp3 = rename_out3;
				_R4:
					temp3 = rename_out4;
				_R5:
					temp3 = rename_out5;
				_R6:
					temp3 = rename_out6;
				_R7:
					temp3 = rename_out7;
			endcase
			
	end
	
	assign Qj = temp3;
	
	reg [2:0] temp4;
	wire [2:0] Qk;
	
	always@(*)
	begin
		
		case(instrucao[6:4])
				_R0:
					temp4 = rename_out0;
				_R1:
					temp4 = rename_out1;
				_R2:
					temp4 = rename_out2;
				_R3:
					temp4 = rename_out3;
				_R4:
					temp4 = rename_out4;
				_R5:
					temp4 = rename_out5;
				_R6:
					temp4 = rename_out6;
				_R7:
					temp4 = rename_out7;
			endcase
			
	end
	
	assign Qk = temp4;
	
	assign sinal_1_Dependencia = Qj[2] | Qj[1] | Qj[0];
	assign sinal_2_Dependencia = Qk[2] | Qk[1] | Qk[0];
	
	//module estacaoDeReservaAddSub(instrucao, clock,sinal_1_Dependencia, sinal_2_Dependencia, Vj, Vk, Qj, Qk, out0, out1,
   //teveEscritaCDB, nameCDB, dadoCDB, teveDespacho, reg_write, dadoPronto, operation, nameForCDB, nameForRegs);
	//RS de Add ou Sub
	estacaoDeReservaAddSub RS1(instrucao, clock, sinal_1_Dependencia, sinal_2_Dependencia, vj, vk, Qj, Qk, add_sub_op1, 
	add_sub_op2, writeCDB, RS_Name, out_Dado_CDB, teveDespacho1, reg_write1,s1, add_or_sub, inRS_Name1, nameForRegs1);
	//RS de Mul ou Div
	estacaoDeReservaMulDiv RS2(instrucao, clock, sinal_1_Dependencia, sinal_2_Dependencia, vj, vk, Qj, Qk, mul_div_op1, 
	mul_div_op2, writeCDB, RS_Name, out_Dado_CDB, teveDespacho2, reg_write2,s2,mul_or_div,inRS_Name2, nameForRegs2);
	
	assign wireSinalFIFO = teveDespacho1 | teveDespacho2;
	
	FU_ADD_SUB fu1(add_or_sub,add_sub_op1, add_sub_op2, out_fu1);
	
	FU_MUL_DIV fu2(mul_or_div, mul_div_op1, mul_div_op2,out_fu2);
	
	//module CDBArbiter(clock, s1, s2, inRS_Name1,inRS_Name2, FUAddSub, FUMulDiv, out, RS_Name, writeCDB);
	CDBArbiter cdb_arbiter(clock, s1, s2, inRS_Name1, inRS_Name2, out_fu1, out_fu2, out_Dado_CDB, RS_Name, writeCDB);
	
	always@(*)
	begin
		if(teveDespacho1)
		begin
			reg_in2 = nameForRegs1;
			reg_reg_write = reg_write1;
		end
		else if(teveDespacho2)begin
			reg_reg_write = reg_write2;
			reg_in2 = nameForRegs2;
		end
	end
	assign in2 = reg_in2;
	assign reg_write = reg_reg_write;
	
	//in1, in2, sRen, clock, endereco, dadoCDB, RS_Name, writeCDB, out0, out1, out2, out3, out4, out5, out6, out7, rename0, rename1, rename2, rename3, rename4, rename5, rename6, rename7
	BancoDeRegistradores bancoReg(out_Dado_CDB, in2, teveDespacho1 | teveDespacho2, clock, reg_write, out_Dado_CDB, RS_Name,
	writeCDB, reg_out0, reg_out1 ,reg_out2 ,reg_out3 ,reg_out4 ,reg_out5 ,reg_out6 ,reg_out7 , rename_out0, rename_out1, rename_out2, rename_out3, 
	rename_out4, rename_out5, rename_out6, rename_out7);
	
endmodule
