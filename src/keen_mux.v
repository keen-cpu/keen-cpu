// SPDX-License-Identifier: MPL-2.0
//
// keen_mux.v -- two-to-one multiplexer
// Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

module keen_mux #(
  parameter integer XLEN = 32
) (
  input wire [XLEN - 1:0] a,
  input wire [XLEN - 1:0] b,
  input wire              sel,

  output wire [XLEN - 1:0] out
);

  assign out = sel ? b : a;

endmodule
