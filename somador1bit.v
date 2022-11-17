module somador1bit(A, B, TE, S, TS);

input A;
input B;
input TE;

output S;
output  TS;

assign S = (~A & ~B & TE) | (~A & B & ~TE) | (A & B & TE) | (A & ~B & ~TE);
assign TS = (A & TE) | (B & TE) | (A & B);

endmodule
