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
// File: convol_uvm_transaction_pkg.sv
// Created: 11.28.2016
//
// Description: UVM Transaction Package for Convol Test.sv.
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
package convol_uvm_transaction_pkg;
//-----------------------------------------------------------------------------
    import uvm_pkg::*;
    import nnfpga_uvm_pkg::*;
//-----------------------------------------------------------------------------
    class convol_transaction #(parameter DATA_SIZE) extends uvm_sequence_item;
//-----------------------------------------------------------------------------
        rand bit signed [DATA_SIZE-1:0]                   data;
//-----------------------------------------------------------------------------
        function new(string name = "");
            super.new(name);
        endfunction: new
//----------------------------------------------------------------------------- 
        `uvm_object_utils_begin(convol_transaction)
        `uvm_field_int(input_data, UVM_ALL_ON)
        `uvm_object_utils_end
//-----------------------------------------------------------------------------
    endclass: convol_transaction
//-----------------------------------------------------------------------------
endpackage: convol_uvm_transaction_pkg