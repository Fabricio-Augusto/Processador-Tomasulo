module FU_MUL_DIV(op, in1, in2, out);

	input op;
	input [15:0] in1, in2;
	output [15:0] out;
	
	reg [15:0] temp;
	
	always@(*)
	begin
		if(op)
		begin
			temp = in1 / in2;
		end
		else
			temp = in1 * in2;
		begin
			
		end
	end
	
	assign out = temp;
	
endmodule
