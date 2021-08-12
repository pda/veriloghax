`include "models/25AA512.v"
`include "hello.v"

// timescale macro defines “time unit” / “time precision”
// > The time_unit is the measurement of delays and simulation time while the
// > time_precision specifies how delay values are rounded before being used in
// > simulation.
// > ...
// > The integers in these specifications can be either 1, 10 or 100 and the
// > character string that specifies the unit can [be one of s, ms, us, ns, ps, fs]
// — https://www.chipverify.com/verilog/verilog-timescale
`timescale 10us/1us

// “test bench” modules (..._tb) are used to simulate and test the device
// under test (DUT).
module hello_tb;

  // registers, unlike wires, are stateful; can be assigned to.
  reg clk = 0;

  wire flash_si;
  wire flash_so;
  wire flash_sck; // rising:MOSI, falling:MISO
  wire flash_cs_n;
  wire flash_wp_n;
  wire flash_hold_n;

  reg flash_reset;

  // `flash` is a Microchip 25AA512 512K SPI EEPROM
  M25AA512 flash (
    .SI(flash_si),
    .SO(flash_so),
    .SCK(flash_sck),
    .CS_N(flash_cs_n),
    .WP_N(flash_wp_n),
    .HOLD_N(flash_hold_n),
    .RESET(flash_reset)
  );

  // `dut` (device under test) is an instance of `module hello` from hello.v
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
    // get some 1s into status register
    //
    // Five months later: okay, we're setting WriteEnable to 1 not because we
    // want to enable writes, but because we want a 1 in the status register.
    // But why?  I guess it seemed obvious at the time.
    // Okay... it looks like in commit c23059e we were reading out the status
    // register via RDSR SPI command, and wanted a sentinel value to expect.
    flash.WriteEnable = 1;
  end

  initial begin
    repeat(64) begin
      #1 // delay: wait N timescale units, rounded to timescale precision.
      clk = ~clk;
    end

    $finish;
  end


  // This was old code from commit c23059e to try out talking SPI to the
  // 25AA512 EEPROM model. It worked, but it uses non-synthesisable delays
  // etc, so isn't useful as an example for real hardware.
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
