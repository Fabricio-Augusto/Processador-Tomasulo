module CDB(in, in_RS_Name, sinal, clock, out, RS_Name, writeCDB);

	input clock, sinal;
	input [15:0] in;
	input [2:0] in_RS_Name;
	output [15:0] out;
	output [2:0] RS_Name;
	output reg writeCDB;
	reg [15:0] regCDB;
	reg [2:0] reg_RS_Name;
	
	always@(posedge clock)
	begin
		if(sinal)
		begin
			regCDB = in;
			reg_RS_Name = in_RS_Name;
			writeCDB = 1'b1;
		end
		else
			writeCDB = 1'b0;
	end
	
	assign out = regCDB;
	assign RS_Name = reg_RS_Name;
endmodule

