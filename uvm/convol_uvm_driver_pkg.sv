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
// File: convol_uvm_driver_pkg.sv
// Created: 11.28.2016
//
// Description: UVM Driver Package for Convolution.
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
package convol_uvm_driver_pkg;
//-----------------------------------------------------------------------------
     import uvm_pkg::*;
     import convol_uvm_transaction_pkg::*;
//-----------------------------------------------------------------------------
     class convol_driver #(type TTYPE) extends uvm_driver #(TTYPE);
          `uvm_component_utils (convol_driver #(TTYPE))
 
          protected virtual convol_data_intf vintf;
 
          function new (string name, uvm_component parent);
               super.new(name, parent);
          endfunction: new
 
          function void build_phase (uvm_phase phase);
               super.build_phase(phase);
               uvm_config_db #(virtual convol_data_intf)::get(this, "", "convol_data_intf", vintf);
          endfunction: build_phase
//----------------------------------------------------------------------------- 
          task run_phase (uvm_phase phase);
               vintf.input_data                          = '0;
               vintf.enable                              = '0;
 
               forever begin
                    seq_item_port.get_next_item(req);
                    @(posedge vintf.clk);
                    vintf.enable                         = '1;
                    vintf.input_data                     = req.data;
                    seq_item_port.item_done();
               end
          endtask: run_phase
//-----------------------------------------------------------------------------
     endclass: convol_driver
//-----------------------------------------------------------------------------
endpackage: convol_uvm_driver_pkg