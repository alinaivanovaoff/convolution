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
// File: convol_uvm_agent_pkg.sv
// Created: 11.29.2016
//
// Description: UVM Agent Package for Convolution.
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
`include "convol_uvm_driver_pkg.sv"
`include "convol_uvm_monitor_pkg.sv"
//-----------------------------------------------------------------------------
package convol_uvm_agent_pkg;
    import uvm_pkg::*;
    import convol_uvm_transaction_pkg::*;
    import convol_uvm_driver_pkg::*;
    import convol_uvm_monitor_pkg::*;
//-----------------------------------------------------------------------------
//    class convol_agent extends uvm_agent;
    class convol_agent #(type IN_TYPE = convol_transaction,
                         type OUT_TYPE = convol_transaction) extends uvm_agent;
        `uvm_component_param_utils(convol_agent #(IN_TYPE, OUT_TYPE))
//        `uvm_component_utils(convol_agent)
//-----------------------------------------------------------------------------
        uvm_analysis_port #(OUT_TYPE) out_mon_port;
//        uvm_analysis_port #(convol_transaction #(.DATA_SIZE(FULL_SIZE))) out_mon_port;
//-----------------------------------------------------------------------------
        uvm_sequencer #(.REQ(IN_TYPE)) sequencer;
//        uvm_sequencer #(.REQ(convol_transaction #(.DATA_SIZE(DATA_SIZE)))) sequencer;
        convol_driver #(.TTYPE(IN_TYPE)) driver;
//        convol_driver #(.TTYPE(convol_transaction #(.DATA_SIZE(DATA_SIZE)))) driver;
        bus_monitor   #(.TTYPE(OUT_TYPE)) out_mon;
//        bus_monitor #(.TTYPE(convol_transaction #(.DATA_SIZE(FULL_SIZE)))) out_mon;
//-----------------------------------------------------------------------------
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
//-----------------------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            out_mon_port   = new(.name("out_mon_port"), .parent(this));
            out_mon        = bus_monitor #(.TTYPE(OUT_TYPE))::type_id::create("out_mon", this);
            //out_mon        = bus_monitor #(.TTYPE(convol_transaction #(.DATA_SIZE(FULL_SIZE))))::type_id::create("out_mon", this);
            if (get_is_active() == UVM_ACTIVE) begin
                sequencer = uvm_sequencer #(.REQ(IN_TYPE))::type_id::create("sequencer", this);
                //sequencer = uvm_sequencer #(.REQ(convol_transaction #(.DATA_SIZE(DATA_SIZE))))::type_id::create("sequencer", this);
                driver    = convol_driver #(.TTYPE(IN_TYPE))::type_id::create("driver", this);
                //driver    = convol_driver #(.TTYPE(convol_transaction #(.DATA_SIZE(DATA_SIZE))))::type_id::create("driver", this);
            end
        endfunction: build_phase
//-----------------------------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            out_mon.out_port.connect(out_mon_port);

            if(get_is_active() == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end
        endfunction: connect_phase
//-----------------------------------------------------------------------------
    endclass: convol_agent
//-----------------------------------------------------------------------------
endpackage: convol_uvm_agent_pkg