import "instruction_queue.vl"

module iq_testbench (
    input wire clk
);

input wire[3:0] MajorOpcode_in,
input wire[4:0] Source1_in,
input wire[4:0] Source2_in,
input wire[1:0] OffsetScale_in,
input wire[4:0] Destination_in,
input wire[3:0] MinorOpcode_in,
input wire HasAddress_in,
input wire[47:0] Address_in,
input wire OffsetSub_in,
input wire stall_in,
output reg[3:0] MajorOpcode_out,
output reg[4:0] Source1_out,
output reg[4:0] Source2_out,
output reg[1:0] OffsetScale_out,
output reg[4:0] Destination_out,
output reg[3:0] MinorOpcode_out,
output reg HasAddress_out,
output reg[47:0] Address_out,
output reg OffsetSub_out,
output reg stall_out

//instruction_queue q(clk, );