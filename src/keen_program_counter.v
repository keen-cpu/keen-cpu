// SPDX-License-Identifier: MPL-2.0
//
// keen_program_counter.v -- program counter
// Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

module keen_program_counter #(
  parameter integer XLEN         = 32,
  parameter integer ILEN         = 32,
  parameter integer IALIGN       = $clog2(ILEN / 8),
  parameter integer RESET_VECTOR = 32'h8000_0000
) (
  input wire              clk,
  input wire              reset,
  input wire              branch,
  input wire [XLEN - 1:0] branch_address,

  output reg [XLEN - 1:0] pc
);
  always @(posedge clk) begin
    if (reset) pc <= RESET_VECTOR;

    if (!reset) pc <= branch ? branch_address : pc + (1 << IALIGN);
  end
endmodule
