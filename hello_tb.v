module hello_tb;

  reg clk, rst;
  reg [3:0] x;

  initial begin
    $display("hello verilog");
    // $monitor("[%4t] clk=%b x=%b", $time, clk, x);
    $monitor("[t:%4t] x=%b", $time, x);
  end

  // clock & reset
  initial begin
    clk = 1'b1;
    rst = 1'b1;              // reset
    repeat(8) #1 clk = ~clk; // run a few clocks with reset held
    rst = 1'b0;              // release reset
    forever #1 clk = ~clk;   // run the clock
  end

  initial begin
    x = 0;
    @(negedge rst);
    repeat(32) @(posedge clk) begin
      x = x + 1;
    end
    $finish;
  end

endmodule
