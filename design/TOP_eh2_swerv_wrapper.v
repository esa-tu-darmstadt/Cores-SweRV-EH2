`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2021 04:04:25 PM
// Design Name: 
// Module Name: eh2_top_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// SPDX-License-Identifier: Apache-2.0
// Copyright 2020 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//********************************************************************************
// $Id$
//
// Function: Top wrapper file with eh2_swerv/mem instantiated inside
// Comments:
//
//********************************************************************************
`include "common_defines.vh"
module TOP_eh2_swerv_wrapper (
   input                          clk,
   input                          rst_l,
   input                          dbg_rst_l,
   input    [31:1]                rst_vec,
   input                          nmi_int,
   input    [31:1]                nmi_vec,
   input    [31:1]                jtag_id,


   output    [`RV_NUM_THREADS-1:0] [63:0] trace_rv_i_insn_ip,
   output    [`RV_NUM_THREADS-1:0] [63:0] trace_rv_i_address_ip,
   output    [`RV_NUM_THREADS-1:0] [1:0]  trace_rv_i_valid_ip,
   output    [`RV_NUM_THREADS-1:0] [1:0]  trace_rv_i_exception_ip,
   output    [`RV_NUM_THREADS-1:0] [4:0]  trace_rv_i_ecause_ip,
   output    [`RV_NUM_THREADS-1:0] [1:0]  trace_rv_i_interrupt_ip,
   output    [`RV_NUM_THREADS-1:0] [31:0] trace_rv_i_tval_ip,

   // Bus signals

`ifdef RV_BUILD_AXI4
   //-------------------------- LSU AXI signals--------------------------
   // AXI Write Channels
   output                               lsu_axi_awvalid,
   input                                lsu_axi_awready,
   output    [`RV_LSU_BUS_TAG-1:0]       lsu_axi_awid,
   output    [31:0]                     lsu_axi_awaddr,
   output    [3:0]                      lsu_axi_awregion,
   output    [7:0]                      lsu_axi_awlen,
   output    [2:0]                      lsu_axi_awsize,
   output    [1:0]                      lsu_axi_awburst,
   output                               lsu_axi_awlock,
   output    [3:0]                      lsu_axi_awcache,
   output    [2:0]                      lsu_axi_awprot,
   output    [3:0]                      lsu_axi_awqos,

   output                               lsu_axi_wvalid,
   input                                lsu_axi_wready,
   output    [63:0]                     lsu_axi_wdata,
   output    [7:0]                      lsu_axi_wstrb,
   output                               lsu_axi_wlast,

   input                                lsu_axi_bvalid,
   output                               lsu_axi_bready,
   input     [1:0]                      lsu_axi_bresp,
   input     [`RV_LSU_BUS_TAG-1:0]       lsu_axi_bid,

   // AXI Read Channels
   output                               lsu_axi_arvalid,
   input                                lsu_axi_arready,
   output    [`RV_LSU_BUS_TAG-1:0]       lsu_axi_arid,
   output    [31:0]                     lsu_axi_araddr,
   output    [3:0]                      lsu_axi_arregion,
   output    [7:0]                      lsu_axi_arlen,
   output    [2:0]                      lsu_axi_arsize,
   output    [1:0]                      lsu_axi_arburst,
   output                               lsu_axi_arlock,
   output    [3:0]                      lsu_axi_arcache,
   output    [2:0]                      lsu_axi_arprot,
   output    [3:0]                      lsu_axi_arqos,

   input                                lsu_axi_rvalid,
   output                               lsu_axi_rready,
   input     [`RV_LSU_BUS_TAG-1:0]       lsu_axi_rid,
   input     [63:0]                     lsu_axi_rdata,
   input     [1:0]                      lsu_axi_rresp,
   input                                lsu_axi_rlast,

   //-------------------------- IFU AXI signals--------------------------
   // AXI Write Channels
   output                               ifu_axi_awvalid,
   input                                ifu_axi_awready,
   output    [`RV_IFU_BUS_TAG-1:0]       ifu_axi_awid,
   output    [31:0]                     ifu_axi_awaddr,
   output    [3:0]                      ifu_axi_awregion,
   output    [7:0]                      ifu_axi_awlen,
   output    [2:0]                      ifu_axi_awsize,
   output    [1:0]                      ifu_axi_awburst,
   output                               ifu_axi_awlock,
   output    [3:0]                      ifu_axi_awcache,
   output    [2:0]                      ifu_axi_awprot,
   output    [3:0]                      ifu_axi_awqos,

   output                               ifu_axi_wvalid,
   input                                ifu_axi_wready,
   output    [63:0]                     ifu_axi_wdata,
   output    [7:0]                      ifu_axi_wstrb,
   output                               ifu_axi_wlast,

   input                                ifu_axi_bvalid,
   output                               ifu_axi_bready,
   input     [1:0]                      ifu_axi_bresp,
   input     [`RV_IFU_BUS_TAG-1:0]       ifu_axi_bid,

   // AXI Read Channels
   output                               ifu_axi_arvalid,
   input                                ifu_axi_arready,
   output    [`RV_IFU_BUS_TAG-1:0]       ifu_axi_arid,
   output    [31:0]                     ifu_axi_araddr,
   output    [3:0]                      ifu_axi_arregion,
   output    [7:0]                      ifu_axi_arlen,
   output    [2:0]                      ifu_axi_arsize,
   output    [1:0]                      ifu_axi_arburst,
   output                               ifu_axi_arlock,
   output    [3:0]                      ifu_axi_arcache,
   output    [2:0]                      ifu_axi_arprot,
   output    [3:0]                      ifu_axi_arqos,

   input                                ifu_axi_rvalid,
   output                               ifu_axi_rready,
   input     [`RV_IFU_BUS_TAG-1:0]       ifu_axi_rid,
   input     [63:0]                     ifu_axi_rdata,
   input     [1:0]                      ifu_axi_rresp,
   input                                ifu_axi_rlast,

   //-------------------------- SB AXI signals--------------------------
   // AXI Write Channels
   output                               sb_axi_awvalid,
   input                                sb_axi_awready,
   output    [`RV_SB_BUS_TAG-1:0]        sb_axi_awid,
   output    [31:0]                     sb_axi_awaddr,
   output    [3:0]                      sb_axi_awregion,
   output    [7:0]                      sb_axi_awlen,
   output    [2:0]                      sb_axi_awsize,
   output    [1:0]                      sb_axi_awburst,
   output                               sb_axi_awlock,
   output    [3:0]                      sb_axi_awcache,
   output    [2:0]                      sb_axi_awprot,
   output    [3:0]                      sb_axi_awqos,

   output                               sb_axi_wvalid,
   input                                sb_axi_wready,
   output    [63:0]                     sb_axi_wdata,
   output    [7:0]                      sb_axi_wstrb,
   output                               sb_axi_wlast,

   input                                sb_axi_bvalid,
   output                               sb_axi_bready,
   input     [1:0]                      sb_axi_bresp,
   input     [`RV_SB_BUS_TAG-1:0]        sb_axi_bid,

   // AXI Read Channels
   output                               sb_axi_arvalid,
   input                                sb_axi_arready,
   output    [`RV_SB_BUS_TAG-1:0]        sb_axi_arid,
   output    [31:0]                     sb_axi_araddr,
   output    [3:0]                      sb_axi_arregion,
   output    [7:0]                      sb_axi_arlen,
   output    [2:0]                      sb_axi_arsize,
   output    [1:0]                      sb_axi_arburst,
   output                               sb_axi_arlock,
   output    [3:0]                      sb_axi_arcache,
   output    [2:0]                      sb_axi_arprot,
   output    [3:0]                      sb_axi_arqos,

   input                                sb_axi_rvalid,
   output                               sb_axi_rready,
   input     [`RV_SB_BUS_TAG-1:0]        sb_axi_rid,
   input     [63:0]                     sb_axi_rdata,
   input     [1:0]                      sb_axi_rresp,
   input                                sb_axi_rlast,

   //-------------------------- DMA AXI signals--------------------------
   // AXI Write Channels
   input                             dma_axi_awvalid,
   output                            dma_axi_awready,
   input     [`RV_DMA_BUS_TAG-1:0]    dma_axi_awid,
   input     [31:0]                  dma_axi_awaddr,
   input     [2:0]                   dma_axi_awsize,
   input     [2:0]                   dma_axi_awprot,
   input     [7:0]                   dma_axi_awlen,
   input     [1:0]                   dma_axi_awburst,


   input                             dma_axi_wvalid,
   output                            dma_axi_wready,
   input     [63:0]                  dma_axi_wdata,
   input     [7:0]                   dma_axi_wstrb,
   input                             dma_axi_wlast,

   output                            dma_axi_bvalid,
   input                             dma_axi_bready,
   output    [1:0]                   dma_axi_bresp,
   output    [`RV_DMA_BUS_TAG-1:0]    dma_axi_bid,

   // AXI Read Channels
   input                             dma_axi_arvalid,
   output                            dma_axi_arready,
   input     [`RV_DMA_BUS_TAG-1:0]    dma_axi_arid,
   input     [31:0]                  dma_axi_araddr,
   input     [2:0]                   dma_axi_arsize,
   input     [2:0]                   dma_axi_arprot,
   input     [7:0]                   dma_axi_arlen,
   input     [1:0]                   dma_axi_arburst,

   output                            dma_axi_rvalid,
   input                             dma_axi_rready,
   output    [`RV_DMA_BUS_TAG-1:0]    dma_axi_rid,
   output    [63:0]                  dma_axi_rdata,
   output    [1:0]                   dma_axi_rresp,
   output                            dma_axi_rlast,

`endif


`ifdef RV_BUILD_AHB_LITE
 //// AHB LITE BUS
   output    [31:0]               haddr,
   output    [2:0]                hburst,
   output                         hmastlock,
   output    [3:0]                hprot,
   output    [2:0]                hsize,
   output    [1:0]                htrans,
   output                         hwrite,

   input    [63:0]                hrdata,
   input                          hready,
   input                          hresp,

   // LSU AHB Master
   output    [31:0]               lsu_haddr,
   output    [2:0]                lsu_hburst,
   output                         lsu_hmastlock,
   output    [3:0]                lsu_hprot,
   output    [2:0]                lsu_hsize,
   output    [1:0]                lsu_htrans,
   output                         lsu_hwrite,
   output    [63:0]               lsu_hwdata,

   input    [63:0]                lsu_hrdata,
   input                          lsu_hready,
   input                          lsu_hresp,
   // Debug Syster Bus AHB
   output    [31:0]               sb_haddr,
   output    [2:0]                sb_hburst,
   output                         sb_hmastlock,
   output    [3:0]                sb_hprot,
   output    [2:0]                sb_hsize,
   output    [1:0]                sb_htrans,
   output                         sb_hwrite,
   output    [63:0]               sb_hwdata,

   input     [63:0]               sb_hrdata,
   input                          sb_hready,
   input                          sb_hresp,

   // DMA Slave
   input                          dma_hsel,
   input    [31:0]                dma_haddr,
   input    [2:0]                 dma_hburst,
   input                          dma_hmastlock,
   input    [3:0]                 dma_hprot,
   input    [2:0]                 dma_hsize,
   input    [1:0]                 dma_htrans,
   input                          dma_hwrite,
   input    [63:0]                dma_hwdata,
   input                          dma_hreadyin,

   output    [63:0]               dma_hrdata,
   output                         dma_hreadyout,
   output                         dma_hresp,

`endif


   // clk ratio signals
   input                          lsu_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input                          ifu_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input                          dbg_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input                          dma_bus_clk_en, // Clock ratio b/w cpu core clk & AHB slave interface

 // all of these test inputs are brought to top-level; must be tied off based on usage by physical design (ie. icache or not, iccm or not, dccm or not)

   input                               [`RV_DCCM_NUM_BANKS-1:0] dccm_ext_in_pkt,
   input                              [`RV_ICCM_NUM_BANKS/4-1:0][1:0][1:0] iccm_ext_in_pkt,
   input                               [1:0] btb_ext_in_pkt,
   input                               [`RV_ICACHE_NUM_WAYS-1:0][`RV_ICACHE_BANKS_WAY-1:0] ic_data_ext_in_pkt,
   input                                [`RV_ICACHE_NUM_WAYS-1:0]                        ic_tag_ext_in_pkt,

   input    [`RV_NUM_THREADS-1:0]  timer_int,
   input    [`RV_NUM_THREADS-1:0]  soft_int,
   input    [`RV_PIC_TOTAL_INT:1] extintsrc_req,

   output    [`RV_NUM_THREADS-1:0] [1:0] dec_tlu_perfcnt0,                  // toggles when perf counter 0 has an event inc
   output    [`RV_NUM_THREADS-1:0] [1:0] dec_tlu_perfcnt1,                  // toggles when perf counter 1 has an event inc
   output    [`RV_NUM_THREADS-1:0] [1:0] dec_tlu_perfcnt2,                  // toggles when perf counter 2 has an event inc
   output    [`RV_NUM_THREADS-1:0] [1:0] dec_tlu_perfcnt3,                  // toggles when perf counter 3 has an event inc

   // ports added by the soc team
   input                          jtag_tck,    // JTAG clk
   input                          jtag_tms,    // JTAG TMS
   input                          jtag_tdi,    // JTAG tdi
   input                          jtag_trst_n, // JTAG Reset
   output                         jtag_tdo,    // JTAG TDO

   input    [31:4]     core_id, // Core ID


   // external MPC halt/run interface
   input     [`RV_NUM_THREADS-1:0] mpc_debug_halt_req, // Async halt request
   input     [`RV_NUM_THREADS-1:0] mpc_debug_run_req,  // Async run request
   input     [`RV_NUM_THREADS-1:0] mpc_reset_run_req,  // Run/halt after reset
   output    [`RV_NUM_THREADS-1:0] mpc_debug_halt_ack, // Halt ack
   output    [`RV_NUM_THREADS-1:0] mpc_debug_run_ack,  // Run ack
   output    [`RV_NUM_THREADS-1:0] debug_brkpt_status, // debug breakpoint

   output    [`RV_NUM_THREADS-1:0] dec_tlu_mhartstart, // running harts

   input             [`RV_NUM_THREADS-1:0]         i_cpu_halt_req,      // Async halt req to CPU
   output            [`RV_NUM_THREADS-1:0]         o_cpu_halt_ack,      // core response to halt
   output            [`RV_NUM_THREADS-1:0]         o_cpu_halt_status,   // 1'b1 indicates core is halted
   output            [`RV_NUM_THREADS-1:0]         o_debug_mode_status, // Core to the PMU that core is in debug mode. When core is in debug mode, the PMU should refrain from sendng a halt or run request
   input             [`RV_NUM_THREADS-1:0]         i_cpu_run_req, // Async restart req to CPU
   output            [`RV_NUM_THREADS-1:0]         o_cpu_run_ack, // Core response to run req
   input                          scan_mode, // To enable scan mode
   input                          mbist_mode // to enable mbist
);


eh2_swerv_wrapper TOP_eh2_swerv_wrapper_inst(
clk,
rst_l,
dbg_rst_l,
rst_vec,
nmi_int,
nmi_vec,
jtag_id,
`ifdef RV_BUILD_AXI4
trace_rv_i_insn_ip,
trace_rv_i_address_ip,
trace_rv_i_valid_ip,
trace_rv_i_exception_ip,
trace_rv_i_ecause_ip,
trace_rv_i_interrupt_ip,
trace_rv_i_tval_ip,
lsu_axi_awvalid,
lsu_axi_awready,
lsu_axi_awid,
lsu_axi_awaddr,
lsu_axi_awregion,
lsu_axi_awlen,
lsu_axi_awsize,
lsu_axi_awburst,
lsu_axi_awlock,
lsu_axi_awcache,
lsu_axi_awprot,
lsu_axi_awqos,
lsu_axi_wvalid,
lsu_axi_wready,
lsu_axi_wdata,
lsu_axi_wstrb,
lsu_axi_wlast,
lsu_axi_bvalid,
lsu_axi_bready,
lsu_axi_bresp,
lsu_axi_bid,
lsu_axi_arvalid,
lsu_axi_arready,
lsu_axi_arid,
lsu_axi_araddr,
lsu_axi_arregion,
lsu_axi_arlen,
lsu_axi_arsize,
lsu_axi_arburst,
lsu_axi_arlock,
lsu_axi_arcache,
lsu_axi_arprot,
lsu_axi_arqos,
lsu_axi_rvalid,
lsu_axi_rready,
lsu_axi_rid,
lsu_axi_rdata,
lsu_axi_rresp,
lsu_axi_rlast,
ifu_axi_awvalid,
ifu_axi_awready,
ifu_axi_awid,
ifu_axi_awaddr,
ifu_axi_awregion,
ifu_axi_awlen,
ifu_axi_awsize,
ifu_axi_awburst,
ifu_axi_awlock,
ifu_axi_awcache,
ifu_axi_awprot,
ifu_axi_awqos,
ifu_axi_wvalid,
ifu_axi_wready,
ifu_axi_wdata,
ifu_axi_wstrb,
ifu_axi_wlast,
ifu_axi_bvalid,
ifu_axi_bready,
ifu_axi_bresp,
ifu_axi_bid,
ifu_axi_arvalid,
ifu_axi_arready,
ifu_axi_arid,
ifu_axi_araddr,
ifu_axi_arregion,
ifu_axi_arlen,
ifu_axi_arsize,
ifu_axi_arburst,
ifu_axi_arlock,
ifu_axi_arcache,
ifu_axi_arprot,
ifu_axi_arqos,
ifu_axi_rvalid,
ifu_axi_rready,
ifu_axi_rid,
ifu_axi_rdata,
ifu_axi_rresp,
ifu_axi_rlast,
sb_axi_awvalid,
sb_axi_awready,
sb_axi_awid,
sb_axi_awaddr,
sb_axi_awregion,
sb_axi_awlen,
sb_axi_awsize,
sb_axi_awburst,
sb_axi_awlock,
sb_axi_awcache,
sb_axi_awprot,
sb_axi_awqos,
sb_axi_wvalid,
sb_axi_wready,
sb_axi_wdata,
sb_axi_wstrb,
sb_axi_wlast,
sb_axi_bvalid,
sb_axi_bready,
sb_axi_bresp,
sb_axi_bid,
sb_axi_arvalid,
sb_axi_arready,
sb_axi_arid,
sb_axi_araddr,
sb_axi_arregion,
sb_axi_arlen,
sb_axi_arsize,
sb_axi_arburst,
sb_axi_arlock,
sb_axi_arcache,
sb_axi_arprot,
sb_axi_arqos,
sb_axi_rvalid,
sb_axi_rready,
sb_axi_rid,
sb_axi_rdata,
sb_axi_rresp,
sb_axi_rlast,
dma_axi_awvalid,
dma_axi_awready,
dma_axi_awid,
dma_axi_awaddr,
dma_axi_awsize,
dma_axi_awprot,
dma_axi_awlen,
dma_axi_awburst,
dma_axi_wvalid,
dma_axi_wready,
dma_axi_wdata,
dma_axi_wstrb,
dma_axi_wlast,
dma_axi_bvalid,
dma_axi_bready,
dma_axi_bresp,
dma_axi_bid,
dma_axi_arvalid,
dma_axi_arready,
dma_axi_arid,
dma_axi_araddr,
dma_axi_arsize,
dma_axi_arprot,
dma_axi_arlen,
dma_axi_arburst,
dma_axi_rvalid,
dma_axi_rready,
dma_axi_rid,
dma_axi_rdata,
dma_axi_rresp,
dma_axi_rlast,
`endif
`ifdef RV_BUILD_AHB_LITE
haddr,
hburst,
hmastlock,
hprot,
hsize,
htrans,
hwrite,
hrdata,
hready,
hresp,
lsu_haddr,
lsu_hburst,
lsu_hmastlock,
lsu_hprot,
lsu_hsize,
lsu_htrans,
lsu_hwrite,
lsu_hwdata,
lsu_hrdata,
lsu_hready,
lsu_hresp,
sb_haddr,
sb_hburst,
sb_hmastlock,
sb_hprot,
sb_hsize,
sb_htrans,
sb_hwrite,
sb_hwdata,
sb_hrdata,
sb_hready,
sb_hresp,
dma_hsel,
dma_haddr,
dma_hburst,
dma_hmastlock,
dma_hprot,
dma_hsize,
dma_htrans,
dma_hwrite,
dma_hwdata,
dma_hreadyin,
dma_hrdata,
dma_hreadyout,
dma_hresp,
`endif
lsu_bus_clk_en, 
ifu_bus_clk_en, 
dbg_bus_clk_en, 
dma_bus_clk_en, 
dccm_ext_in_pkt,
iccm_ext_in_pkt,
btb_ext_in_pkt,
ic_data_ext_in_pkt,
ic_tag_ext_in_pkt,
timer_int,
soft_int,
extintsrc_req,
dec_tlu_perfcnt0,  
dec_tlu_perfcnt1,  
dec_tlu_perfcnt2,  
dec_tlu_perfcnt3,  
jtag_tck,    
jtag_tms,    
jtag_tdi,    
jtag_trst_n, 
jtag_tdo,    
core_id,
mpc_debug_halt_req,
mpc_debug_run_req, 
mpc_reset_run_req, 
mpc_debug_halt_ack,
mpc_debug_run_ack, 
debug_brkpt_status,
dec_tlu_mhartstart,
i_cpu_halt_req,     
o_cpu_halt_ack,     
o_cpu_halt_status,  
o_debug_mode_status,
i_cpu_run_req,
o_cpu_run_ack,
scan_mode,
mbist_mode);




endmodule