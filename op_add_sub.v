module op_add_sub #(parameter DATA_WIDTH = 8)(r, s, ci, sub, f, co, vo);
  input [DATA_WIDTH-1:0] r, s;
  input ci, sub;	
  output [DATA_WIDTH-1:0] f;
  output co, vo;

  wire [DATA_WIDTH:0] carry;
  wire [DATA_WIDTH-1:0] s_mod; // modified s (can be inverted)

  assign carry[0] = ci;

  // if sub=1, then invert s
  assign s_mod = sub ? ~s : s;

  genvar i;
  generate
      for (i = 0; i < DATA_WIDTH; i = i + 1) begin : GEN_ADD
          bitsum sum (
              .A    (r[i]),
              .B    (s_mod[i]),
              .Cin  (carry[i]),
              .S    (f[i]),
              .Cout (carry[i+1])
          );
      end
  endgenerate

  // Ознака переносу за межі розрядної сітки (carry out)
  assign co = carry[DATA_WIDTH];

  // Ознака переповнення в знаковий розряд 
  assign vo = carry[DATA_WIDTH] ^ carry[DATA_WIDTH-1];

endmodule

module bitsum (A, B, S, Cin, Cout); 
  input A, B, Cin; 
  output S, Cout; 
  
  wire A, B, S, Res; 
  wire c1, c2, Cin, Cout; 
  
  xor(Res, A, B); 
  and(c1, A, B); 
  xor(S, Cin, Res); 
  and(c2, Cin, Res); 
  or(Cout, c1, c2); 
endmodule
