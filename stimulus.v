module stimulus #(parameter DATA_WIDTH = 11)(clk, reset, i_out, a_out, b_out, c_out);
  input clk, reset;
  output [1:0] i_out;
  output [DATA_WIDTH-1:0] a_out, b_out;
  output c_out;

  reg [1:0] i_out;
  reg [DATA_WIDTH-1:0] a_out, b_out;
  reg c_out;

  initial begin
    if (DATA_WIDTH != 11) begin
        $display("ERROR: DATA_WIDTH must be 11, but got %0d", DATA_WIDTH);
        $finish;
    end

    i_out <= 0; a_out <= 0; b_out <= 0; c_out <= 0;

    // waiting reset
    wait (reset == 1'b0);
    wait (reset == 1'b1);

    @ (negedge clk); i_out <= 2'b00; b_out <= 11'b0_0000000001; a_out <= 11'b1_0000000000; c_out <= 0;  // R | S (B | A)

    @ (negedge clk); i_out <= 2'b10; b_out <= 11'b1_0101010101; a_out <= 11'b1_1111111111; c_out <= 0; // ~R & S (~B & A)

    // A1 11'b0_1010010111 (663)
    // A2 11'b1_0101101001 (-663)
    // B1 11'b0_0110001110 (398)
    // B2 11'b1_1001110010 (-398)

    // R + S + CI (B + A + CI)
    @ (negedge clk); i_out <= 2'b01; b_out <= 11'b0_0110001110; a_out <= 11'b0_1010010111; c_out <= 0; // B1 + A1
    @ (negedge clk); i_out <= 2'b01; b_out <= 11'b0_0110001110; a_out <= 11'b1_0101101001; c_out <= 0; // B1 + A2
    @ (negedge clk); i_out <= 2'b01; b_out <= 11'b1_1001110010; a_out <= 11'b0_1010010111; c_out <= 0; // B2 + A1
    @ (negedge clk); i_out <= 2'b01; b_out <= 11'b1_1001110010; a_out <= 11'b1_0101101001; c_out <= 0; // B2 + A2

    // R - S - 1 + CI (B - A - 1 + CI)
    @ (negedge clk); i_out <= 2'b11; b_out <= 11'b0_0110001110; a_out <= 11'b0_1010010111; c_out <= 1; // B1 - A1
    @ (negedge clk); i_out <= 2'b11; b_out <= 11'b0_0110001110; a_out <= 11'b1_0101101001; c_out <= 1; // B1 - A2
    @ (negedge clk); i_out <= 2'b11; b_out <= 11'b1_1001110010; a_out <= 11'b0_1010010111; c_out <= 1; // B2 - A1
    @ (negedge clk); i_out <= 2'b11; b_out <= 11'b1_1001110010; a_out <= 11'b1_0101101001; c_out <= 1; // B2 - A2
    @ (negedge clk);

    $finish;   
  end
endmodule
