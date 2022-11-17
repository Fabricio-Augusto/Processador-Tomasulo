module CDBArbiter(clock, s1, s2, inRS_Name1,inRS_Name2, FUAddSub, FUMulDiv, out, RS_Name, writeCDB);
	
	input clock, s1, s2;
	input [15:0] FUAddSub, FUMulDiv;
	input  [2:0] inRS_Name1, inRS_Name2;
	output [15:0] out;
	output writeCDB;
	
	reg [1:0] SM1, SM2;
	reg Sinal;
	wire wireSinal;
	wire [2:0] wire_in_RS_Name;
	output [2:0] RS_Name;
	
	wire [15:0] wireDadoInCDB;
	reg [15:0] dadoInCDB;
	reg [2:0] tempName;
	
	initial begin
		SM1 = 0;
		SM2 = 0;
	end
	
	reg [18:0] Buffer;
	reg temBuffer;

	always@(negedge clock)
	begin
		
		if(temBuffer)
		begin
		
			tempName = Buffer[18:16];
			dadoInCDB = Buffer[15:0];
			
			if(s1)
			begin
				Sinal = 1'b1;
				Buffer[18:16] = inRS_Name1;
				Buffer[15:0] = FUAddSub;
			end
			else if(s2)
			begin
				Sinal = 1'b1;
				Buffer[18:16] = inRS_Name2;
				Buffer[15:0] = FUMulDiv;
			end
			else
				temBuffer=0;
				
		end
		else if(s2 && s1)
		begin
		
			Sinal = 1'b1;
			dadoInCDB = FUMulDiv;
			tempName = inRS_Name2;
			Buffer[18:16] = inRS_Name1;
			Buffer[15:0] = FUAddSub;
			temBuffer = 1'b1;
			
		end
		else if(s1)
		begin
		
			Sinal = 1'b1;
			dadoInCDB = FUAddSub;
			tempName = inRS_Name1;
			
		end
		else if(s2)
		begin
		
			Sinal = 1'b1;
			dadoInCDB = FUMulDiv;
			tempName = inRS_Name2;
			
		end
		else
		begin
		
			Sinal = 0;
			dadoInCDB = 16'bz;
			tempName = 3'bz;
			
		end
		
	end
	
	assign wireSinal = Sinal;
	assign wireDadoInCDB = dadoInCDB;
	assign wire_in_RS_Name = tempName;
	
	CDB cdb(wireDadoInCDB, wire_in_RS_Name, wireSinal, clock, out, RS_Name, writeCDB);

endmodule
