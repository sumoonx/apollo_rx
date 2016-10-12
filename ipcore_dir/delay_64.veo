/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used solely      *
*     for design, simulation, implementation and creation of design files      *
*     limited to Xilinx devices or technologies. Use with non-Xilinx           *
*     devices or technologies is expressly prohibited and immediately          *
*     terminates your license.                                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY     *
*     FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY     *
*     PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE              *
*     IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS       *
*     MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY       *
*     CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY        *
*     RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY        *
*     DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE    *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A    *
*     PARTICULAR PURPOSE.                                                      *
*                                                                              *
*     Xilinx products are not intended for use in life support appliances,     *
*     devices, or systems.  Use in such applications are expressly             *
*     prohibited.                                                              *
*                                                                              *
*     (c) Copyright 1995-2016 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/

/*******************************************************************************
*     Generated from core with identifier: xilinx.com:ip:c_shift_ram:11.0      *
*                                                                              *
*     The Xilinx LogiCORE RAM-based Shift Register generates fast, compact     *
*     FIFO-style registers, delay lines or time-skew buffers up to 256 bits    *
*     wide and up to 1024 words deep using Select RAM in SRL16 or SRLC32       *
*     mode. User options allow you to create either fixed-length or            *
*     variable-length shift registers, as well as to specify output            *
*     register capability with clock enable and synchronous controls.          *
*******************************************************************************/

// Interfaces:
//    a_intf
//    clk_intf
//    sclr_intf
//    ce_intf
//    d_intf
//    sset_intf
//    sinit_intf
//    q_intf

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
delay_64 your_instance_name (
  .d(d), // input [7 : 0] d
  .clk(clk), // input clk
  .ce(ce), // input ce
  .q(q) // output [7 : 0] q
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file delay_64.v when simulating
// the core, delay_64. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

