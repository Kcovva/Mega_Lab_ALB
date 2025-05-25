module op_10 #(parameter DATA_WIDTH = 8)(r, s, f);
  input [DATA_WIDTH-1:0] r, s;
  output [DATA_WIDTH-1:0] f;

  assign f = ~r & s;
endmodule
