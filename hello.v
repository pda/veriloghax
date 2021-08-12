`timescale 1us/1us

module hello (
  input wire clk,

  output reg flash_si = 0,
  input wire flash_so,
  output reg flash_sck = 0,
  output reg flash_cs_n = 1,
  output reg flash_wp_n = 1,
  output reg flash_hold_n = 1
);

`define STATE_INIT   0
`define STATE_STATUS 1
`define STATE_COPY   2

  reg [3:0] state = `STATE_INIT;
  reg [16:0] state_ttl = 8;

  reg [7:0] shift = 8'b00000000;

  reg [3:0] bit_count;

  reg [3:0] cmd_bits;

  always @(clk) begin
    if (cmd_bits == 0) begin
      if (flash_sck == 1) begin
        flash_si <= shift[7-cmd_bits];
        cmd_bits <= cmd_bits + 1; // nah this is fucked
      end
      flash_sck <= ~flash_sck;
    end else if (state == `STATE_INIT) begin
      state_ttl <= state_ttl - 1;
      if (state_ttl == 0) begin
        shift <= 8'b0000_0101; // RDSR
        state <= `STATE_STATUS;
        state_ttl <= 31;
      end
    end else if (state == `STATE_STATUS) begin
      if (flash_sck == 1) flash_si <= shift[7];
      if (flash_sck == 0) shift <= (shift << 1) | flash_so;
      flash_sck <= ~flash_sck;
      if (state_ttl == 0) begin
        state <= `STATE_COPY;
      end
    end else if (state == `STATE_COPY) begin
    end
  end

endmodule
