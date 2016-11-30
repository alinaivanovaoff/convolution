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
// File: convol_uvm_test_pkg.sv
// Created: 11.30.2016
//
// Description: UVM Test Package for Convolution.
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
package convol_uvm_test_pkg;
   import uvm_pkg::*;
   import convol_uvm_env_pkg::*;
   import convol_uvm_transaction_pkg::*;
   import convol_uvm_sequence_pkg::*;
   import convol_uvm_sequencer_pkg::*;
   import convol_uvm_pkg::*;
//-----------------------------------------------------------------------------
    class convol_uvm_test extends uvm_test;
        `uvm_component_utils(convol_uvm_test)
//-----------------------------------------------------------------------------
        convol_env        env;
        uvm_table_printer printer;
        int               sim_status = 0;
//-----------------------------------------------------------------------------
        protected virtual tb_main_intf vintf;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
//-----------------------------------------------------------------------------
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Enable transaction recording for everything
            uvm_config_db#(int)::set(this, "*", "recording_detail", UVM_FULL);
            void'(uvm_resource_db #(virtual tb_main_if)::read_by_name(.scope("ifs"), .name("tb_main_intf"), .val(vintf)));
            void'(uvm_resource_db #(int)::read_by_name(.scope("flags"), .name("sim_status"), .val(sim_status)));

            env = convol_uvm_env::type_id::create(.name("env"), .parent(this));

            // Create a specific depth printer for printing the created topology
            printer = new();
            printer.knobs.depth = 3;
        endfunction: build_phase
//-----------------------------------------------------------------------------
        virtual function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.set_report_verbosity_level_hier(UVM_FULL);
            `uvm_info(get_type_name(), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
        endfunction: end_of_elaboration_phase
//-----------------------------------------------------------------------------
        virtual task main_phase(uvm_phase phase);
            convol_sequence #(.REQ(convol_transaction #(DATA_SIZE))) out_seq;

            phase.raise_objection(.obj(this));
                out_seq = convol_sequence #(.REQ(convol_transaction #(DATA_SIZE)))::type_id::create(.name("out_seq"), .contxt(get_full_name()));
                out_seq.start(env.out_agnt.sequencer);
                #10000;
            phase.drop_objection(.obj(this));
        endtask: main_phase
//-----------------------------------------------------------------------------
        virtual function void extract_phase(uvm_phase phase);
            if (env.sb.error) begin
                sim_status = 1;
            end
        endfunction: extract_phase
//-----------------------------------------------------------------------------
        virtual function void report_phase(uvm_phase phase);
            if (sim_status) begin
                `uvm_error(get_type_name(), "** CONVOL TEST FAIL **")
            end else begin
                `uvm_info(get_type_name(), "** CONVOL TEST PASSED **", UVM_NONE)
            end
        endfunction: report_phase
//-----------------------------------------------------------------------------
    endclass: convol_uvm_test
//-----------------------------------------------------------------------------
endpackage: convol_uvm_test_pkg