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
// File: interfaces_pkg.sv
// Created: 11.23.2016
//
// Description: Interfaces package.
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
interface tb_main_intf;
   logic                                                  clk;
   logic                                                  reset;
endinterface: tb_main_intf
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
interface convol_data_intf import settings_pkg::*; (
    input wire                                            clk,
    input wire                                            reset);
    wire signed [DATA_SIZE-1:0]                           input_data;
    wire        [DATA_SIZE-1:0]                           coeff            [WINDOW_SIZE],
    wire                                                  enable;
    modport master                                        (output input_data, enable);
    modport slave                                         (input  input_data, enable);
endinterface: convol_data_intf
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
interface convol_result_intf import settings_pkg::*; ();
    wire signed [FULL_SIZE-1:0]                           output_data;
    wire                                                  output_data_valid;
    modport master                                        (output output_data, output_data_valid);
    modport slave                                         (input  output_data, output_data_valid);
endinterface: convol_result_intf