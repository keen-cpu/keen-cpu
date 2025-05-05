// SPDX-License-Identifier: MPL-2.0
//
// keen_alu.v -- alu
// Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

`include "alu_ctrl.h"

module keen_alu #(
  parameter integer XLEN         = 32,
  parameter integer ALU_CTRL_LEN = 4
) (
  input wire [       XLEN - 1:0] a,
  input wire [       XLEN - 1:0] b,
  input wire [ALU_CTRL_LEN- 1:0] alu_ctrl,

  output reg [XLEN - 1:0] alu_out,
  output reg              zero
);

  wire signed [XLEN - 1:0] a_s, b_s;

  assign a_s  = a;
  assign b_s  = b;

  assign zero = (alu_out == 0);

  // Need to fix linter issue
  always_comb begin
    //  always @(*) begin
    case (alu_ctrl)
      KEEN_ALU_CTRL_ADD: begin
        alu_out = a + b;
      end
      KEEN_ALU_CTRL_SLT: begin
        alu_out = (a_s < b_s) ? 1 : 0;
      end
      KEEN_ALU_CTRL_SLTU: begin
        alu_out = (a < b) ? 1 : 0;
      end
      KEEN_ALU_CTRL_AND: begin
        alu_out = a & b;
      end
      KEEN_ALU_CTRL_OR: begin
        alu_out = a | b;
      end
      KEEN_ALU_CTRL_XOR: begin
        alu_out = a ^ b;
      end
      KEEN_ALU_CTRL_SLL: begin
        alu_out = a << b[4:0];
      end
      KEEN_ALU_CTRL_SRL: begin
        alu_out = a >> b[4:0];
      end
      KEEN_ALU_CTRL_SRA: begin
        // signed shift (>>>)
        alu_out = a_s >>> b_s[4:0];
      end
      KEEN_ALU_CTRL_SUB: begin
        alu_out = a - b;
      end
      KEEN_ALU_CTRL_SGT: begin
        alu_out = (a_s > b_s) ? 1 : 0;
      end
      KEEN_ALU_CTRL_SGTU: begin
        alu_out = (a > b) ? 1 : 0;
      end
      default: begin
        alu_out = 0;
      end
    endcase
  end
endmodule
