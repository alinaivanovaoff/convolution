//-----------------------------------------------------------------------------
// Original Author: Alina Ivanova
// Email:           alina.al.ivanova@gmail.com
// Skype:           alina.al.ivanova
// Web:             alinaivanovaoff.com
// LinkedIn:        linkedin.com/in/alina-ivanova/en
// Twitter:         @AlinaIvanovaOff
// GitHub:          github.com/alinaivanovaoff
// Facebook:        facebook.com/alinaivanovaoff
// AngelList:       angel.co/alina-al-ivanova
// AboutMe:         about.me/alinaivanova
// Upwork:          upwork.com/o/profiles/users/_~018edd0e7608f33edc/
//-----------------------------------------------------------------------------
// File: one_dim_convol_kernel.sv
// Created: 11.16.2016
//
// Description: One-dimensional Convolution Kernel.
//
//-----------------------------------------------------------------------------
// Copyright (c) 2016 by Alina Ivanova
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
//----------------------------------------------------------------------------- 
`include "settings_pkg.sv"
//-----------------------------------------------------------------------------
module one_dim_convol_kernel import settings_pkg::*;(
//-----------------------------------------------------------------------------
// Input Ports
//-----------------------------------------------------------------------------
    input  wire                                           clk,
    input  wire                                           reset,
//-----------------------------------------------------------------------------
    input  wire        [DATA_SIZE-1:0]                    input_data,
    input  wire                                           enable,
    input  wire        [DATA_SIZE-1:0]                    coeff            [WINDOW_SIZE],
//-----------------------------------------------------------------------------
// Output Ports
//-----------------------------------------------------------------------------
    output reg  signed [FULL_SIZE-1:0]                    output_data,
    output reg                                            output_data_valid);
//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
    reg                                                   reset_synch;
    reg                [2:0]                              reset_z;
//-----------------------------------------------------------------------------
    reg         signed [DATA_SIZE-1:0]                    shift_reg        [WINDOW_SIZE];
    reg                                                   enable_shift     [WINDOW_SIZE];
    reg         signed [2*DATA_SIZE-1:0]                  mult             [WINDOW_SIZE];
    reg         signed [2*DATA_SIZE-1:0]                  mult_z           [WINDOW_SIZE];
    reg                                                   enable_mult;
    reg                                                   enable_mult_z;

    genvar g;
    generate
        for (g = 1; g <= ADDER_STAGES; g++) begin: adder_stage
            localparam ADDER_SIZE = (WINDOW_SIZE >> g) + (WINDOW_SIZE % (1 << g) ? 1 : 0);
            reg signed [ADDER_SIZE-1:0][FULL_SIZE-1:0]    adder;
            reg                                           enable_adder;
        end: adder_stage
    endgenerate
//-----------------------------------------------------------------------------
// Function Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Sub Module Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Signal Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Process Section
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: ONE_DIM_CONVOL_KERNEL_RESET_SYNCH
        reset_z                                          <= {reset_z[1:0], reset};
        reset_synch                                      <= (reset_z[1] & (~reset_z[2])) ? '1 : '0 ;
    end: ONE_DIM_CONVOL_KERNEL_RESET_SYNCH
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: ONE_DIM_CONVOL_KERNEL_SHIFT_REG
        if (reset_synch) begin
            for (int i = 0; i < WINDOW_SIZE; i++) begin
                shift_reg[i]                             <= '0;
                enable_shift[i]                          <= '0;
            end
        end else begin
            shift_reg[0]                                 <= input_data;
            enable_shift[0]                              <= enable;
            for (int i = 1; i < WINDOW_SIZE; i++) begin
                shift_reg[i]                             <= shift_reg[i-1];
                enable_shift[i]                          <= enable_shift[i-1]; 
            end
        end
    end: ONE_DIM_CONVOL_KERNEL_SHIFT_REG
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: ONE_DIM_CONVOL_KERNEL_MULT
        if (reset_synch) begin
            for (int i = 0; i < WINDOW_SIZE; i++) begin
                mult[i]                                  <= '0;
                mult_z[i]                                <= '0;
            end
            enable_mult                                  <= '0;
            enable_mult_z                                <= '0;
        end else begin
            for (int i = 0; i < WINDOW_SIZE; i++) begin
                mult[i]                                  <= shift_reg[i] * coeff[i];
                mult_z[i]                                <= mult[i][2*DATA_SIZE-1] ? {{EXTRA_BITS{1'b1}}, mult[i]} : {{EXTRA_BITS{1'b0}}, mult[i]};
            end
            enable_mult                                  <= enable_shift[WINDOW_SIZE];
            enable_mult_z                                <= enable_mult;
        end
    end: ONE_DIM_CONVOL_KERNEL_MULT

    always_ff @(posedge clk) begin: ONE_DIM_CONVOL_KERNEL_ADDER
        if (reset_synch) begin
            for (int i = 1; i <= ADDER_STAGES; i++) begin
                adder_stage[i].adder                     <= '0;
                adder_stage[i].enable_adder              <= '0;
            end
        end else begin
            adder_stage[1].enable_adder                  <= enable_mult_z;
            for (int j = 0; j < adder_stage[0].ADDER_SIZE; j++) begin
                automatic bit m = (j == (adder_stage[1].ADDER_SIZE - 1)) && (WINDOW_SIZE % 2);
                adder_stage[1].adder[j]                  <= m ? mult_z[2 * j] : mult_z[2 * j] + mult_z[2 * j + 1];
            end
            for (int i = 2; i <= ADDER_STAGES; i++) begin
                adder_stage[i].enable_adder              <= adder_stage[i - 1].enable_adder;   
            end
            for (int i = 2; i <= ADDER_STAGES; i++) begin
                for (int j = 0; j < adder_stage[i].ADDER_SIZE; j++) begin
                    automatic bit m = (j == (adder_stage[i].ADDER_SIZE - 1)) && (adder_stage[i - 1].ADDER_SIZE % 2);
                    adder_stage[i].adder[j]              <= m ? adder_stage[i - 1].adder[2 * j] : adder_stage[i - 1].adder[2 * j] + adder_stage[i - 1].adder[2 * j + 1];
                end
            end
        end
    end: ONE_DIM_CONVOL_KERNEL_ADDER
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: ONE_DIM_CONVOL_KERNEL_OUTPUT_DATA
        if (reset_synch) begin
            output_data                                  <= '0;
            output_data_valid                            <= '0;
        end else begin
            output_data                                  <= adder_stage[ADDER_STAGES - 1].adder[0];
            output_data_valid                            <= adder_stage[ADDER_STAGES - 1].enable_adder;
        end
    end: ONE_DIM_CONVOL_KERNEL_OUTPUT_DATA
//-----------------------------------------------------------------------------
endmodule: one_dim_convol_kernel