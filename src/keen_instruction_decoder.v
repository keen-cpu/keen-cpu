// SPDX-License-Identifier: MPL-2.0
//
// keen_instruction_decoder.v -- instruction decoder
// Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

`include "keen/config.vh"
`include "keen/instruction-set/format.vh"
`include "keen/instruction-set/rv32i.vh"

module keen_instruction_decoder #(
  parameter integer ILEN = 32
) (
  input wire [IMMLEN - 1:0] imm,

  output wire [XLEN - 1:0] extended
);
  assign extended[XLEN - 1:IMMLEN - 1] = {SIGN_BITS{imm[IMMLEN - 1]}};
  assign extended[IMMLEN - 2:0]        = imm[IMMLEN - 2:0];
endmodule
