module alb_ref #(parameter DATA_WIDTH = 8)(clk, reset, a, b, ci, i, f, co, vo, no, zo);
  input [DATA_WIDTH-1:0] a, b;
  input [1:0] i;
  input clk, reset, ci;
  output reg [DATA_WIDTH-1:0] f;
  output reg co, vo, no, zo;

  reg [DATA_WIDTH:0] result_ext;
  reg [DATA_WIDTH-1:0] a_reg, b_reg;
  reg ci_reg;

  always @(posedge clk) begin
      a_reg  <= a;
      b_reg  <= b;
      ci_reg <= ci;
  end

  always @(*) begin
      case (i)
          2'b00: begin // B | A
              $display("  OP=%b (B | A), b=%b, a=%b", i, b_reg, a_reg);
              result_ext = b_reg | a_reg;
          end
          2'b10: begin // ~B & A
              $display("  OP=%b (~B & A), b=%b, a=%b", i, b_reg, a_reg);
              result_ext = ~b_reg & a_reg;
          end
          2'b01: begin // B + A + CI
              $display("  OP=%b (B + A + CI), b=%d, a=%d ci:%b", i, $signed(b_reg), $signed(a_reg), ci_reg);
              result_ext = b_reg + a_reg + ci_reg;
          end
          2'b11: begin // B - A - 1 + CI
              $display("  OP=%b (B - A - 1 + CI), b=%d, a=%d ci:%b", i, $signed(b_reg), $signed(a_reg), ci_reg);
              result_ext = b_reg - a_reg - 1 + ci_reg;
          end
          default: begin
              result_ext = 0;
          end
      endcase

      f = result_ext[DATA_WIDTH-1:0];

      // Overflow (VO)
      if (i == 2'b01 || i == 2'b11) begin
        if (i[1] == 0) begin // add
          co = result_ext[DATA_WIDTH];
          vo = (a_reg[DATA_WIDTH-1] == b_reg[DATA_WIDTH-1]) && (f[DATA_WIDTH-1] != b_reg[DATA_WIDTH-1]);
        end else begin // sub
          co = ~result_ext[DATA_WIDTH];
          vo = (a_reg[DATA_WIDTH-1] != b_reg[DATA_WIDTH-1]) && (f[DATA_WIDTH-1] != b_reg[DATA_WIDTH-1]);
        end
      end else begin
          co = 0;
          vo = 0;
      end

      no = f[DATA_WIDTH-1];
      zo = (f == 0);
  end

endmodule
