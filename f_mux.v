module f_mux #(parameter DATA_WIDTH = 8)(i, f_00, f_10, f_x1, ci, vi, fout, co, vo, no, zo);
  input [1:0] i;
  input [DATA_WIDTH-1:0] f_00, f_10, f_x1;
  input ci, vi;
  output [DATA_WIDTH-1:0] fout;
  output co, vo, no, zo;

  assign fout = (f_00 & {DATA_WIDTH{~i[1] & ~i[0]}}) |
                (f_10 & {DATA_WIDTH{ i[1] & ~i[0]}}) |
                (f_x1 & {DATA_WIDTH{ i[0]}});

  assign co = ci & i[0];
  assign vo = vi & i[0];
  assign no = fout[DATA_WIDTH-1];
  assign zo = (fout == 0);

endmodule