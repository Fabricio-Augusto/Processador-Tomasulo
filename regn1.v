module regn1 (in, w, out);

	input [15:0] in;
	input w;
	output [15:0] out;
	
	reg [15:0] registrador;
	
	initial begin
		registrador = 16'b0000000000000001;
	end
	
	always @(*)
	begin
		if(w)
			registrador = in;
	end
	
	assign out = registrador;
	
endmodule
	
	