//ULA Somador/Subtrator

module FU_ADD_SUB(AddSub, in1, in2, out);

	input AddSub;
	input [15:0] in1, in2;
	output [15:0] out;

	reg [15:0] temp;	

	always@(*)
	begin
		if(AddSub)
			temp = in1 - in2;
		else
			temp = in1 + in2;
	end
	
	assign out = temp;
	
endmodule
