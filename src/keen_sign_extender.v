// SPDX-License-Identifier: MPL-2.0
//
// keen_sign_extender.v -- sign extender
// Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

module keen_sign_extender #(
  parameter integer IMMLEN = 12,
  parameter integer XLEN   = 32,

  localparam integer SIGN_BITS = XLEN - IMMLEN + 1
) (
  input wire [IMMLEN - 1:0] imm,

  output wire [XLEN - 1:0] extended
);
  assign extended[XLEN - 1:IMMLEN - 1] = {SIGN_BITS{imm[IMMLEN - 1]}};
  assign extended[IMMLEN - 2:0]        = imm[IMMLEN - 2:0];
endmodule
