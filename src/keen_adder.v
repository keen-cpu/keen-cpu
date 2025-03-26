// SPDX-License-Identifier: MPL-2.0
//
// keen_adder.v -- carry-lookahead adder
// Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

module keen_adder #(
  parameter integer XLEN = 2
) (
  input wire [XLEN - 1:0] a,
  input wire [XLEN - 1:0] b,
  input wire              c_in,

  output wire [XLEN - 1:0] sum,
  output wire              c_out
);
  wire [XLEN:0] c;

  assign c[0]  = c_in;
  assign c_out = c[XLEN];

  wire [XLEN - 1:0] g;
  wire [XLEN - 1:0] p;

  genvar i;

  for (i = 0; i < XLEN; i = i + 1) begin : gen_lookahead
    assign g[i]     = a[i] & b[i];
    assign p[i]     = a[i] | b[i];
    assign c[i + 1] = g[i] | (p[i] & c[i]);
  end

  for (i = 0; i < XLEN; i = i + 1) begin : gen_sum
    assign sum[i] = (a[i] ^ b[i]) ^ c[i];
  end
endmodule
