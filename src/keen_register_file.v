// SPDX-License-Identifier: MPL-2.0
//
// keen_register_file.v -- register file
// Copyright (C) 2024--2025  Jacob Koziej <jacobkoziej@gmail.com>

module keen_register_file #(
  parameter integer REGISTERS = 32,
  parameter integer WORD_SIZE = 32,
  parameter integer READS     = 2,
  parameter integer WRITES    = 1,

  localparam integer ADDRESS_SIZE = $clog2(WORD_SIZE)
) (
  input wire clk,
  input wire reset,

  input wire [ADDRESS_SIZE - 1:0] read_addresses [0:READS  - 1],
  input wire [ADDRESS_SIZE - 1:0] write_addresses[0:WRITES - 1],
  input wire [WORD_SIZE    - 1:0] write_data     [0:WRITES - 1],
  input wire                      write_enables  [0:WRITES - 1],

  output reg [WORD_SIZE - 1:0] read_data[0:READS - 1]
);
  wire reset_clk;
  wire read_clk;

  assign reset_clk = clk & reset;
  assign read_clk  = clk & !reset;

  reg [WORD_SIZE - 1:0] registers[0:REGISTERS - 1];

  genvar i;

  for (i = 0; i < READS; i = i + 1) begin : gen_register_file_read
    wire [ADDRESS_SIZE - 1:0] read_address;

    assign read_address = read_addresses[i];

    always @(posedge read_clk)
      read_data[i] <= (read_address != {ADDRESS_SIZE{1'b0}}) ?
          registers[read_address] : 0;

  end

  for (i = 0; i < WRITES; i = i + 1) begin : gen_register_file_write
    wire [ADDRESS_SIZE - 1:0] write_address;
    wire                      write_clk;
    wire                      write_enable;

    assign write_address = write_addresses[i];
    assign write_clk     = clk & write_enable & !reset;
    assign write_enable  = write_enables[i];

    always @(posedge write_clk or posedge reset_clk)
      registers[write_address] <= !reset ? write_data[i] : {WORD_SIZE{1'b0}};
  end
endmodule
