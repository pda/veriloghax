`include "models/25AA512.v"
`include "hello.v"

`timescale 10us/10us

module hello_tb;

  reg clk = 0;

  wire flash_si;
  wire flash_so;
  wire flash_sck; // rising:MOSI, falling:MISO
  wire flash_cs_n;
  wire flash_wp_n;
  wire flash_hold_n;

  reg flash_reset;

  M25AA512 flash (
    .SI(flash_si),
    .SO(flash_so),
    .SCK(flash_sck),
    .CS_N(flash_cs_n),
    .WP_N(flash_wp_n),
    .HOLD_N(flash_hold_n),
    .RESET(flash_reset)
  );

  hello dut (
    .clk(clk),
    .flash_si(flash_si),
    .flash_so(flash_so),
    .flash_sck(flash_sck),
    .flash_cs_n(flash_cs_n),
    .flash_wp_n(flash_wp_n),
    .flash_hold_n(flash_hold_n)
  );

  initial begin
    $dumpfile("hello.vcd");
    $dumpvars(0,hello_tb);
    $readmemh("data.txt", flash.MemoryBlock, 0, 3);
    flash.WriteEnable = 1; // get some 1s into status register
  end

  initial begin
    repeat(64) begin
      #1
      clk = ~clk;
    end

    $finish;
  end


    //#100 // tPUP (power-up)
    //flash_cs_n = 0;
    //#100 // tCSS (CS setup time)
    //shift = 8'b0000_0101; // RDSR
    //repeat(8 + 8 - 1) begin // 8 SI + 8 SO - 1 shared clock
    //  flash_si = shift[7];
    //  flash_sck = 1;
    //  #1 flash_sck = 0;
    //  #1 shift = (shift << 1) | flash_so;
    //end
    //#1 $display("STATUS: %b", shift);


endmodule
