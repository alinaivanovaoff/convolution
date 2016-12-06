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
// File: convol_uvm_scoreboard_pkg.sv
// Created: 11.30.2016
//
// Description: UVM Scoreboard Package for Convolution.
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
package convol_uvm_scoreboard_pkg;
    import uvm_pkg::*;
    import convol_uvm_transaction_pkg::*;
//-----------------------------------------------------------------------------
    class convol_scoreboard #(type OUT_TYPE = convol_transaction) extends uvm_scoreboard;
        `uvm_component_param_utils(convol_scoreboard #(OUT_TYPE))

        uvm_analysis_export #(OUT_TYPE)    out_mon_export;//#(convol_transaction #(FULL_SIZE))    out_mon_export;
        uvm_tlm_analysis_fifo #(OUT_TYPE)  out_mon_fifo;//#(convol_transaction #(FULL_SIZE))  out_mon_fifo;
//        OUT_TYPE out_trans;// convol_transaction #(FULL_SIZE) out_trans;

        int error;
//-----------------------------------------------------------------------------
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
//-----------------------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            out_mon_export    = new("out_mon_export", this);
            out_mon_fifo      = new("out_mon_fifo", this);
        endfunction: build_phase
//-----------------------------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            out_mon_export.connect(out_mon_fifo.analysis_export);
        endfunction: connect_phase
//-----------------------------------------------------------------------------
        virtual task run_phase(uvm_phase phase);
            OUT_TYPE out_trans;
            int counter = 0;
            error = 1;
            forever begin: out_checks
                out_trans = OUT_TYPE::type_id::create(.name("out_trans"), .contxt(get_full_name()));//convol_transaction #(FULL_SIZE)::type_id::create(.name("out_trans"), .contxt(get_full_name()));
                out_mon_fifo.get(out_trans);
                counter++; 
                if (counter > 5)
                    error = 0;
            end: out_checks
        endtask: run_phase
//-----------------------------------------------------------------------------
    endclass: convol_scoreboard
//-----------------------------------------------------------------------------
endpackage: convol_uvm_scoreboard_pkg