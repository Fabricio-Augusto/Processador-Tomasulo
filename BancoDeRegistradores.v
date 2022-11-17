module BancoDeRegistradores(in1, in2, sRen, clock, endereco, dadoCDB, RS_Name, writeCDB, out0, out1, out2, out3, out4, out5, out6, out7, rename0, rename1, rename2, rename3, rename4, rename5, rename6, rename7);
	
	input [2:0] endereco;
	input clock;
	input sRen;
	input [15:0] in1;
	input [2:0] in2;
	input [15:0]dadoCDB;
	input [2:0] RS_Name;
	input writeCDB;
	output [15:0] out0, out1, out2, out3, out4, out5, out6, out7;
	output [2:0] rename0, rename1, rename2, rename3, rename4, rename5, rename6, rename7;
	reg [2:0] regRenome [7:0];
	reg w [7:0];
	
	integer i;
	initial begin
		for(i=0; i<8; i=i+1)
			regRenome[i] = 0;
	end
	
	// regRenome recebe 1 para estação de reserva de AddSub e 2 para MulDiv
	always@(negedge clock)
	begin
	
		if(sRen)
			regRenome[endereco] = in2;
			
		if(writeCDB)
		begin
			
			for(i=0; i<8; i=i+1)
			begin
			
				if(regRenome[i]==RS_Name)
				begin
						regRenome[i] = 0;
						w[i] = 1;
				end
				else	
					w[i] = 0;
					
			end
					
		end
		else
			for(i=0; i<8; i=i+1)
				w[i] = 0;
		
	end

	regn reg0(dadoCDB, w[0], out0);
	regn1 reg1(dadoCDB, w[1], out1);
	regn1 reg2(dadoCDB, w[2], out2);
	regn1 reg3(dadoCDB, w[3], out3);
	regn2 reg4(dadoCDB, w[4], out4);
	regn reg5(dadoCDB, w[5], out5);
	regn1 reg6(dadoCDB, w[6], out6);
	regn reg7(dadoCDB, w[7], out7);
	
	assign rename0 = regRenome[0];
	assign rename1 = regRenome[1];
	assign rename2 = regRenome[2];
	assign rename3 = regRenome[3];
	assign rename4 = regRenome[4];
	assign rename5 = regRenome[5];
	assign rename6 = regRenome[6];
	assign rename7 = regRenome[7];

endmodule
