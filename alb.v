module alb #(parameter DATA_WIDTH = 8)(clk, reset, a, b, ci, i, f, co, vo, no, zo);
  input [DATA_WIDTH-1:0] a, b;
  input [1:0] i;
  input clk, reset, ci;
  output [DATA_WIDTH-1:0] f;
  output co, vo, no, zo;

  reg [DATA_WIDTH-1:0] s_reg, r_reg;
  wire [DATA_WIDTH-1:0] f_00, f_10, f_x1;
  wire f_x1_c, f_x1_v;

  always @(posedge clk) begin
      s_reg <= a;
      r_reg <= b;
  end

  op_00 #(.DATA_WIDTH(DATA_WIDTH)) u_op_00(.r(r_reg), .s(s_reg), .f(f_00));
  op_10 #(.DATA_WIDTH(DATA_WIDTH)) u_op_10(.r(r_reg), .s(s_reg), .f(f_10));
  op_add_sub #(.DATA_WIDTH(DATA_WIDTH)) u_op_add_sub(.r(r_reg), .s(s_reg), .ci(ci), .sub(i[1]), 
                                                     .f(f_x1), .co(f_x1_c), .vo(f_x1_v));

  f_mux #(.DATA_WIDTH(DATA_WIDTH)) u_mux(.i(i), .f_00(f_00), .f_10(f_10), .f_x1(f_x1), .ci(f_x1_c), .vi(f_x1_v), 
                                         .fout(f), .co(co), .vo(vo), .no(no), .zo(zo));

endmodule
