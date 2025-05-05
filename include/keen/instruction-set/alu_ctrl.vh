// SPDX-License-Identifier: MPL-2.0
//
// alu_ctrl.vh -- definition of ALU control signals
// Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

`ifndef KEEN_INSTRUCTION_SET_ALU_CTRL
`define KEEN_INSTRUCTION_SET_ALU_CTRL

// verilog_format: off

`define KEEN_ALU_CTRL_ADD   4'b0000
`define KEEN_ALU_CTRL_SLT   4'b0001
`define KEEN_ALU_CTRL_SLTU  4'b0010
`define KEEN_ALU_CTRL_AND   4'b0011
`define KEEN_ALU_CTRL_OR    4'b0100
`define KEEN_ALU_CTRL_XOR   4'b0101
`define KEEN_ALU_CTRL_SLL   4'b0110
`define KEEN_ALU_CTRL_SRL   4'b0111
`define KEEN_ALU_CTRL_SRA   4'b1000
`define KEEN_ALU_CTRL_SUB   4'b1001
// Not formally defined within ISA
`define KEEN_ALU_CTRL_SGT   4'b1010
`define KEEN_ALU_CTRL_SGTU  4'b1011

`endif  // KEEN_INSTRUCTION_SET_ALU_CTRL
