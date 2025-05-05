// SPDX-License-Identifier: MPL-2.0
//
// keen_main_decoder.v -- main decoder
// Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

/*
 * Sets the control signals of the control unit based on the opcode
 */

`include "rv32i.vh"

module keen_main_decoder #(
  parameter integer XLEN         = 32,
  parameter integer OPLEN        = 7,
  parameter integer FUNCT7_LEN   = 7,
  parameter integer FUNCT3_LEN   = 3,
  parameter integer ALU_CTRL_LEN = 4,
  parameter integer IMM_SRC_LEN  = 2
) (
  input wire [     OPLEN - 1:0] opcode,
  input wire [FUNCT7_LEN - 1:0] funct7,
  input wire [FUNCT3_LEN - 1:0] funct3,

  output reg                      branch,
  output reg                      jump,
  output reg                      result_src,
  output reg                      mem_write,
  output reg [ALU_CTRL_LEN - 1:0] alu_ctrl,
  output reg                      alu_src,
  output reg [ IMM_SRC_LEN - 1:0] imm_src,
  output reg                      reg_write
);
  // Am under the impression this is a SystemVerilog concept that the linter wants?
  always_comb begin

    // Default Values
    branch     = 1'b0;
    jump       = 1'b0;
    result_src = 1'b0;
    mem_write  = 1'b0;
    alu_ctrl   = 4'b0000;
    alu_src    = 1'b0;
    imm_src    = 2'b00;
    reg_write  = 1'b0;

    case (opcode)
      // R-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_OP: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ADD: begin
            case (funct7)
              // ADD or SUB
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_ADD: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SUB: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b1001;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLT: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SLT: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0001;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTU: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SLTU: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0010;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_XOR: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_XOR: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0101;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          // SRL or SRA
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SRL: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRL: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0111;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRA: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b1000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_OR: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_OR: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0100;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_AND: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_AND: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0011;
                alu_src    = 1'b0;
                imm_src    = 2'b00;  // dont care
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          default: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b0;
            imm_src    = 2'b00;
            reg_write  = 1'b0;
          end
        endcase
      end

      // I-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_JALR: begin
        branch     = 1'b0;
        jump       = 1'b1;
        result_src = 1'b0;
        mem_write  = 1'b0;
        alu_ctrl   = 4'b0000;
        alu_src    = 1'b1;
        imm_src    = 2'b00;
        reg_write  = 1'b1;
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_LOAD: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LB: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b1;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LH: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b1;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LW: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b1;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LBU: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b1;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LHU: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b1;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          default: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b0;
            imm_src    = 2'b00;
            reg_write  = 1'b0;
          end
        endcase
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_OP_IMM: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ADDI: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTI: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0001;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTIU: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0010;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ORI: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0100;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ANDI: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0011;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLLI: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0110;
            alu_src    = 1'b1;
            imm_src    = 2'b00;
            reg_write  = 1'b1;
          end
          // SRLI or SRAI
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SRLI: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRLI: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0111;
                alu_src    = 1'b1;
                imm_src    = 2'b00;
                reg_write  = 1'b1;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRAI: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b1000;
                alu_src    = 1'b1;
                imm_src    = 2'b00;
                reg_write  = 1'b1;
              end
              default: begin
                branch     = 1'b0;
                jump       = 1'b0;
                result_src = 1'b0;
                mem_write  = 1'b0;
                alu_ctrl   = 4'b0000;
                alu_src    = 1'b0;
                imm_src    = 2'b00;
                reg_write  = 1'b0;
              end
            endcase
          end
          default: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b0;
            imm_src    = 2'b00;
            reg_write  = 1'b0;
          end
          // fence, ecall, ebreak
        endcase
      end

      // S-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_STORE: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SB: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b1;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b01;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SH: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b1;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b01;
            reg_write  = 1'b1;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SW: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b1;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b1;
            imm_src    = 2'b01;
            reg_write  = 1'b1;
          end
          default: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b0;
            imm_src    = 2'b00;
            reg_write  = 1'b0;
          end
        endcase
      end

      // Branch Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_BRANCH: begin
        // BE PREPARED TO CHANGE ALU_CTRL DEPENDING ON ALU ITSELF (NEED TO CHECK)
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BEQ: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b1001;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BNE: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b1001;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BLT: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0001;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BGE: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b1010;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BLTU: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0010;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BGEU: begin
            branch     = 1'b1;
            jump       = 1'b0;
            result_src = 1'b0;  // don't care
            mem_write  = 1'b0;
            alu_ctrl   = 4'b1011;
            alu_src    = 1'b0;
            imm_src    = 2'b10;
            reg_write  = 1'b0;
          end
          default: begin
            branch     = 1'b0;
            jump       = 1'b0;
            result_src = 1'b0;
            mem_write  = 1'b0;
            alu_ctrl   = 4'b0000;
            alu_src    = 1'b0;
            imm_src    = 2'b00;
            reg_write  = 1'b0;
          end
        endcase
      end

      // U-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_LUI: begin
        branch     = 1'b0;
        jump       = 1'b0;
        result_src = 1'b0;
        mem_write  = 1'b0;
        alu_ctrl   = 4'b0000;  // don't care
        alu_src    = 1'b0;  // don't care
        imm_src    = 2'b11;
        reg_write  = 1'b1;
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_AUIPC: begin
        branch     = 1'b0;
        jump       = 1'b0;
        result_src = 1'b0;
        mem_write  = 1'b0;
        alu_ctrl   = 4'b0000;
        alu_src    = 1'b0;  // don't care
        imm_src    = 2'b11;
        reg_write  = 1'b1;
      end

      // Jump Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_JAL: begin
        branch     = 1'b0;
        jump       = 1'b1;
        result_src = 1'b0;
        mem_write  = 1'b0;
        alu_ctrl   = 4'b0000;  // don't care
        alu_src    = 1'b0;  // don't care
        imm_src    = 2'b11;
        reg_write  = 1'b1;
      end

      // Unsure for now
      // KEEN_INSTRUCTION_SET_RV32I_OPCODE_MISC_MEM:
      // KEEN_INSTRUCTION_SET_RV32I_OPCODE_SYSTEM:
      default: begin
        branch     = 1'b0;
        jump       = 1'b0;
        result_src = 1'b0;
        mem_write  = 1'b0;
        alu_ctrl   = 4'b0000;
        alu_src    = 1'b0;
        imm_src    = 2'b00;
        reg_write  = 1'b0;
      end
    endcase
  end
endmodule
