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
// File: frame_dut.sv
// Created: 11.23.2016
//
// Description: Frame for dut.
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
`include "one_dim_convol_kernel.sv"
//-----------------------------------------------------------------------------
module frame_dut import settings_pkg::*; (
//-----------------------------------------------------------------------------
// Interfaces
//-----------------------------------------------------------------------------
   interface TbMainIntf,
   interface ConvolDataIntf,
   interface ConvolResultIntf);
//-----------------------------------------------------------------------------
// Function Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Sub Module Section
//-----------------------------------------------------------------------------
    one_dim_convol_kernel OneDimConvolKernel (
        .clk                                              (TbMainIntf.clk),
        .reset                                            (TbMainIntf.reset),
        .input_data                                       (ConvolDataIntf.input_data),
        .enable                                           (ConvolDataIntf.enable),
        .coeff                                            (ConvolDataIntf.coeff),
        .output_data                                      (ConvolResultIntf.output_data),
        .output_data_valid                                (ConvolResultIntf.output_data_valid));
//-----------------------------------------------------------------------------
// Signal Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Process Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
endmodule: frame_dut