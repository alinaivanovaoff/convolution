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
// File: frame_tb.sv
// Created: 11.16.2016
//
// Description: Testbench for frame_dut.sv.
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
`include "interfaces_pkg.sv"
//-----------------------------------------------------------------------------
module frame_tb;
    import tb_settings_pkg::*;
    import uvm_pkg::*;
    import convol_uvm_pkg::*;
    import convol_uvm_test_pkg::*;
//-----------------------------------------------------------------------------
    int sim_status                                     = 0;
//-----------------------------------------------------------------------------
    tb_main_intf TbMainIntf ();

    convol_data_intf ConvolDataIntf (
        .clk                                           (tb_main_intf.clk),
        .reset                                         (tb_main_intf.reset));

    convol_result_intf ConvolResultIntf (
        .clk                                           (tb_main_intf.clk),
        .reset                                         (tb_main_intf.reset));
//-----------------------------------------------------------------------------
    initial begin: FRAME_TB_INI
        TbMainIntf.clk                                 = '0;
        TbMainIntf.reset                               = '0;
        #RESET_TIME TbMainIntf.reset                   = '1;
    end: FRAME_TB_INI
//-----------------------------------------------------------------------------
    always begin: FRAME_TB_CLK
        #(CLK_T/2) TbMainIntf.clk                      = ~TbMainIntf.clk;
    end: FRAME_TB_CLK
//-----------------------------------------------------------------------------
// Connects the Interfaces to the FrameDut
//-----------------------------------------------------------------------------
    frame_dut FrameDut (
        .TbMainIntf                                    (TbMainIntf),
        .ConvolDataIntf                                (ConvolDataIntf),
        .ConvolResultIntf                              (ConvolResultIntf));
//-----------------------------------------------------------------------------
    initial begin: FRAME_TB_TEST_INSTANCE
//-----------------------------------------------------------------------------
// registers the Interfaces in the configuration block so that other blocks can use it
        uvm_resource_db # (virtual tb_main_intf)      ::set(.scope("intfs"), .name("tb_main_intf"), .val(TbMainIntf));
        uvm_resource_db # (int)                       ::set(.scope("flags"), .name("sim_status"), .val(sim_status));
        uvm_config_db   # (virtual convol_data_intf)  ::set(null, "*driver","convol_data_intf", ConvolDataIntf);
        uvm_config_db   # (virtual convol_result_intf)::set(null, "*out_mon","convol_result_intf", ConvolResultIntf);
//-----------------------------------------------------------------------------
// executes the test
        run_test(); //requires test name option in the sumulator run command
//-----------------------------------------------------------------------------
    end: FRAME_TB_TEST_INSTANCE
//-----------------------------------------------------------------------------
endmodule: frame_tb