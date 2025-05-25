module top;
  parameter DATA_WIDTH = 11;

  reg  clk, reset;

  wire [DATA_WIDTH-1:0] a, b, f_alb, f_ref;
  wire [1:0] i;
  wire ci;

  wire co_alb, vo_alb, no_alb, zo_alb;
  wire co_ref, vo_ref, no_ref, zo_ref;

  stimulus #(.DATA_WIDTH(DATA_WIDTH)) u_st(.clk(clk), .reset(reset), 
                                          .i_out(i), .a_out(a), .b_out(b), .c_out(ci));

  alb #(.DATA_WIDTH(DATA_WIDTH)) u_alb(.clk(clk), .reset(reset), 
                                       .a(a), .b(b), .ci(ci), .i(i), 
                                       .f(f_alb), .co(co_alb), .vo(vo_alb), .no(no_alb), .zo(zo_alb));

  alb_ref #(.DATA_WIDTH(DATA_WIDTH)) u_ref(.clk(clk), .reset(reset), 
                                       .a(a), .b(b), .ci(ci), .i(i), 
                                       .f(f_ref), .co(co_ref), .vo(vo_ref), .no(no_ref), .zo(zo_ref));

  checker #(.DATA_WIDTH(DATA_WIDTH)) u_ck(.clk(clk), .reset(reset), 
                                       .f_alb(f_alb), .co_alb(co_alb), .vo_alb(vo_alb), .no_alb(no_alb), .zo_alb(zo_alb),
                                       .f_ref(f_ref), .co_ref(co_ref), .vo_ref(vo_ref), .no_ref(no_ref), .zo_ref(zo_ref));

  // clock generation
  initial begin
    clk <= 0;
    forever #5 clk = ~clk;
  end

  // reset generation
  initial begin
    reset <= 1'b0;
    #10 reset <= 1'b1;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(1);
    $dumpvars(1, u_alb);
  end
endmodule

