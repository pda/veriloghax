`include "models/25AA512.v"

`timescale 1us/1us

module hello_tb;

  reg flash_si = 0;
  wire flash_so;
  reg flash_sck = 0; // rising:MOSI, falling:MISO
  reg flash_cs_n = 1;
  reg flash_wp_n = 1;
  reg flash_hold_n = 1;
  reg flash_reset = 0;

  reg [7:0] shift = 0;

  M25AA512 flash (
    .SI(flash_si),
    .SO(flash_so),
    .SCK(flash_sck),
    .CS_N(flash_cs_n),
    .WP_N(flash_wp_n),
    .HOLD_N(flash_hold_n),
    .RESET(flash_reset)
  );

  initial begin
    //$monitor("t:%1t shift:%b", $time, shift);
    $monitor("[t:%4t] CS':%b SCK:%b SI:%b SO:%b shift:%08b", $time, flash_cs_n, flash_sck, flash_si, flash_so, shift);
    $dumpfile("hello.vcd");
    $dumpvars(0,hello_tb);
    $readmemh("data.txt", flash.MemoryBlock, 0, 3);
  end

  initial begin
    #100 // tPUP (power-up)
    flash_cs_n = 0;
    #100 // tCSS (CS setup time)
    shift = 8'b0000_0101; // RDSR
    repeat(8 + 8 - 1) begin // 8 SI + 8 SO - 1 shared clock
      flash_si = shift[7];
      flash_sck = 1;
      #1 flash_sck = 0;
      #1 shift = (shift << 1) | flash_so;
    end

    #1 $display("STATUS: %b", shift);

    $finish;
  end

endmodule
