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
// File: convol_uvm_sequence_pkg.sv
// Created: 11.28.2016
//
// Description: UVM Sequence Package for Convolution.
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
package convol_uvm_sequence_pkg;
    import uvm_pkg::*;
    import nnfpga_uvm_transaction_pkg::*;
//-----------------------------------------------------------------------------
    class convol_sequence #(type TTYPE) extends uvm_sequence #(TTYPE);
        `uvm_object_utils(convol_sequence #(TTYPE))
 
        function new(string name = "");
            super.new(name);
        endfunction: new

        virtual task body();
            TTYPE cv_tx;
 
            repeat(40) begin
                cv_tx = TTYPE::type_id::create(...
 
                start_item(cv_tx);
                    assert(cv_tx.randomize());
                finish_item(cv_tx);
            end
        endtask: body
//-----------------------------------------------------------------------------
    endclass: convol_sequence
//-----------------------------------------------------------------------------
endpackage: convol_uvm_sequence_pkg
