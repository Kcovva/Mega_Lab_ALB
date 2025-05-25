module checker #(parameter DATA_WIDTH = 8)(clk, reset, f_alb, co_alb, vo_alb, no_alb, zo_alb, f_ref, co_ref, vo_ref, no_ref, zo_ref);
  input wire clk, reset;
  input wire [DATA_WIDTH-1:0] f_alb;
  input wire co_alb;
  input wire vo_alb;
  input wire no_alb;
  input wire zo_alb;

  input wire [DATA_WIDTH-1:0] f_ref;
  input wire co_ref;
  input wire vo_ref;
  input wire no_ref;
  input wire zo_ref;

  reg [DATA_WIDTH:0] corrected;

  always @(negedge clk) begin
    if (reset) begin
      $display("  ALB: f=%b(%d) co=%b vo=%b no=%b zo=%b", f_alb, $signed(f_alb), co_alb, vo_alb, no_alb, zo_alb);

      if (f_alb !== f_ref || co_alb !== co_ref || vo_alb !== vo_ref ||
        no_alb !== no_ref || zo_alb !== zo_ref) begin
        $display("ERROR @ %t", $time);
        $display("  REF: f=%b(%d) co=%b vo=%b no=%b zo=%b", f_ref, $signed(f_ref), co_ref, vo_ref, no_ref, zo_ref);
      end
      if (vo_alb) begin
        corrected = {co_alb, f_alb};
        $display("  corrected value: f=%b(%d)", corrected, $signed(corrected));
      end
    end
  end
endmodule
