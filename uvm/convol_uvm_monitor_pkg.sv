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
// File: convol_uvm_monitor_pkg.sv
// Created: 11.29.2016
//
// Description: UVM Monitor Package for Convolution.
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
`include "uvm_macros.svh"
//-----------------------------------------------------------------------------
package convol_uvm_monitor_pkg;
    import uvm_pkg::*;
    import convol_uvm_transaction_pkg::*;
//-----------------------------------------------------------------------------
    class bus_monitor #(type TTYPE) extends uvm_monitor;
        `uvm_component_param_utils(bus_monitor #(TTYPE))

        uvm_analysis_port #(TTYPE) out_port;

        protected virtual tb_main_intf                    tb_vintf;
        protected virtual convol_result_intf              vintf;
        protected         TTYPE                           trans_collected;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            void'(uvm_resource_db #(virtual tb_main_intf)::read_by_name(.scope("intfs"), .name("tb_main_intf"), .val(tb_vintf)));
            uvm_config_db #(virtual convol_result_intf)::get(this,"","convol_result_intf", vintf);
            out_port = new(.name("out_port"), .parent(this));
        endfunction: build_phase

        virtual task run_phase(uvm_phase phase);
            forever begin
                @(posedge tb_vintf.clk);
                if (vintf.output_data_valid) begin
                    trans_collected = TTYPE::type_id::create(.name("trans_collected"), .contxt(get_full_name()));
                    trans_collected.data = vintf.output_data;
                    out_port.write(trans_collected);
                end
            end
        endtask: run_phase
//----------------------------------------------------------------------------- 
    endclass: bus_monitor
//-----------------------------------------------------------------------------   
endpackage: convol_uvm_monitor_pkg