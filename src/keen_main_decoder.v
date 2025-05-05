// SPDX-License-Identifier: MPL-2.0
//
// keen_main_decoder.v -- main decoder
// Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

/*
 * Sets the control signals of the control unit based on the opcode
 */

`include "rv32i.vh"
`include "main_decoder.vh"

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
  always @(*) begin

    // Default Values
    branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
    jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
    result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
    mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
    alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
    alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
    imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
    reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;

    case (opcode)
      // R-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_OP: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ADD: begin
            case (funct7)
              // ADD or SUB
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_ADD: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SUB: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SUB;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLT: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SLT: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLT;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTU: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SLTU: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLTU;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_XOR: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_XOR: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_XOR;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          // SRL or SRA
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SRL: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRL: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SRL;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRA: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SRA;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_OR: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_OR: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_OR;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_AND: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_AND: begin
                branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_AND;
                alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src =
                    KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;  // dont care
                reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          default: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
        endcase
      end

      // I-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_JALR: begin
        branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
        jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_ACTIVE;
        result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_PCP4;
        mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
        alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
        alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
        imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
        reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_LOAD: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LB: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_DMEM;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LH: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_DMEM;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LW: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_DMEM;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LBU: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_DMEM;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_LHU: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_DMEM;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          default: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
        endcase
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_OP_IMM: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ADDI: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTI: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLT;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLTIU: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLTU;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ORI: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_OR;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_ANDI: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_AND;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SLLI: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLL;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          // SRLI or SRAI
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SRLI: begin
            case (funct7)
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRLI: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SRL;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              KEEN_INSTRUCTION_SET_RV32I_FUNCT7_SRAI: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SRA;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
              end
              default: begin
                branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
                jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
                result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
                mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
                alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
                alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
                imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
                reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
              end
            endcase
          end
          default: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          // fence, ecall, ebreak
        endcase
      end

      // S-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_STORE: begin
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SB: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_ACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_STYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SH: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_ACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_STYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_SW: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_ACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_SIGN_EXT;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_STYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
          end
          default: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
        endcase
      end

      // Branch Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_BRANCH: begin
        // BE PREPARED TO CHANGE ALU_CTRL DEPENDING ON ALU ITSELF (NEED TO CHECK)
        case (funct3)
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BEQ: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SUB;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BNE: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SUB;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BLT: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLT;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BGE: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SGT;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BLTU: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SLTU;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          KEEN_INSTRUCTION_SET_RV32I_FUNCT3_BGEU: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_ACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            // don't care
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_SGTU;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_BTYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
          default: begin
            branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
            jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
            result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
            mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
            alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
            alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
            imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
            reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
          end
        endcase
      end

      // U-Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_LUI: begin
        branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
        jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
        result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
        mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
        alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;  // don't care
        alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;  // don't care
        imm_src = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_JTYPE;
        reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
      end
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_AUIPC: begin
        branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
        jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
        result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
        mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
        alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
        alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;  // don't care
        imm_src = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_JTYPE;
        reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
      end

      // Jump Type
      KEEN_INSTRUCTION_SET_RV32I_OPCODE_JAL: begin
        branch = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
        jump = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_ACTIVE;
        result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_PCP4;
        mem_write = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
        alu_ctrl = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;  // don't care
        alu_src = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;  // don't care
        imm_src = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_JTYPE;
        reg_write = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_ACTIVE;
      end

      // Unsure for now
      // KEEN_INSTRUCTION_SET_RV32I_OPCODE_MISC_MEM:
      // KEEN_INSTRUCTION_SET_RV32I_OPCODE_SYSTEM:
      default: begin
        branch     = KEEN_INSTRUCTION_SET_MAINDEC_BRANCH_INACTIVE;
        jump       = KEEN_INSTRUCTION_SET_MAINDEC_JUMP_INACTIVE;
        result_src = KEEN_INSTRUCTION_SET_MAINDEC_RESULT_SRC_ALU;
        mem_write  = KEEN_INSTRUCTION_SET_MAINDEC_MEM_WRITE_INACTIVE;
        alu_ctrl   = KEEN_INSTRUCTION_SET_MAINDEC_ALU_CTRL_ADD;
        alu_src    = KEEN_INSTRUCTION_SET_MAINDEC_ALU_SRC_REGFILE;
        imm_src    = KEEN_INSTRUCTION_SET_MAINDEC_IMM_SRC_ITYPE;
        reg_write  = KEEN_INSTRUCTION_SET_MAINDEC_REG_WRITE_INACTIVE;
      end
    endcase
  end
endmodule
