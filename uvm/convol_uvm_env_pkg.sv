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
// File: convol_uvm_env_pkg.sv
// Created: 11.30.2016
//
// Description: UVM Env Package for Convolution.
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
`include "convol_uvm_transaction_pkg.sv"
`include "convol_uvm_agent_pkg.sv"
`include "convol_uvm_scoreboard_pkg.sv"
//-----------------------------------------------------------------------------
package convol_uvm_env_pkg;
    import uvm_pkg::*;
    import convol_uvm_transaction_pkg::*;
    import convol_uvm_agent_pkg::*;
    import convol_uvm_scoreboard_pkg::*;
//-----------------------------------------------------------------------------
    class convol_env #(type IN_TYPE, type OUT_TYPE) extends uvm_env;
        `uvm_component_utils(convol_env #(IN_TYPE, OUT_TYPE))
//-----------------------------------------------------------------------------
        convol_agent #(IN_TYPE, OUT_TYPE) cv_agnt;
        convol_uvm_scoreboard #(OUT_TYPE)      sb;
//-----------------------------------------------------------------------------
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
//-----------------------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cv_agnt  = convol_agent #(IN_TYPE, OUT_TYPE)::type_id::create(.name("cv_agnt"), .parent(this));
            sb       = convol_uvm_scoreboard #(OUT_TYPE)::type_id::create(.name("sb"), .parent(this));
        endfunction: build_phase
//-----------------------------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cv_agnt.out_mon_port.connect(sb.out_mon_export);
        endfunction: connect_phase
//-----------------------------------------------------------------------------
    endclass: convol_env
//-----------------------------------------------------------------------------
endpackage: convol_uvm_env_pkg