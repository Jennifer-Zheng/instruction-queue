`include "instruction_queue.v"

module iq_testbench (
    input wire clk
);

reg[3:0] MajorOpcode_in;
reg[4:0] Source1_in;
reg[4:0] Source2_in;
reg[1:0] OffsetScale_in;
reg[4:0] Destination_in;
reg[3:0] MinorOpcode_in;
reg HasAddress_in;
reg[47:0] Address_in;
reg OffsetSub_in;
reg stall_in;
// reg[3:0] MajorOpcode_out;
// reg[4:0] Source1_out;
// reg[4:0] Source2_out;
// reg[1:0] OffsetScale_out;
// reg[4:0] Destination_out;
// reg[3:0] MinorOpcode_out;
// reg HasAddress_out;
// reg[47:0] Address_out;
// reg OffsetSub_out;
// reg stall_out;

// Test clock
reg r_CLOCK = 1'b0;

// Drives the clock
always #1 r_CLOCK = !r_CLOCK;

integer test_num = 0;

instruction_queue q(clk, MajorOpcode_in, Source1_in, Source2_in, OffsetScale_in, Destination_in, MinorOpcode_in, HasAddress_in, Address_in, OffsetSub_in, stall_in,
MajorOpcode_out, Source1_out, Source2_out, OffsetScale_out, Destination_out, MinorOpcode_out, HasAddress_out, Address_out, OffsetSub_out, stall_out);

always @(posedge r_CLOCK) begin
    if (test_num == 0) begin
        // $display("HERE");
        MajorOpcode_in <= 4'b1111;
        Source1_in <= 5'b11111;
        Source2_in <= 5'b11111;
        OffsetScale_in <= 2'b11;
        Destination_in <= 5'b11111;
        MinorOpcode_in <= 4'b1111;
        HasAddress_in <= 1;
        Address_in <= 98;
        OffsetSub_in <= 1;
        stall_in <= 1;
    end
end


endmodule