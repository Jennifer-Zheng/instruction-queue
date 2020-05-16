/*
Instruction queue is implemented as a circular buffer. 

Key notes:
- The queue itself is a fixed size array (8 instructions * 75 bits for instructions + metadata).
- We keep track of the start index and the end index of the queue. 
- The start index is the next instruction to be dispatched.
- The end index is where the new instruction will be appended to the queue.
- We keep a counter of the number of instructions currently in the queue. We stall if the counter hits capacity.
*/

module instruction_queue (
input wire clk,
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
);

// Instruction queue: 75 bits wide * 8 entries
reg [74:0] queue [7:0];

// Location of next instruction to dispatch (aka start of queue)
integer start_idx = 0;

// Location to append next item (aka end of queue)
integer end_idx = 0;

// Number of instructions that are currently in the queue
integer counter = 0;

// Holds concatenation of the instruction metadata that was fetched
reg [74:0] instruction_fetched;

// Instruction to be dispatched
reg [74:0] instruction_dispatched;

always @(negedge clk) begin 
    if(stall_in == 1 && counter == 8) begin
        stall_out = stall_in;
    end else begin
        stall_out = 0;
    end
end

integer test = 0;
always @(posedge clk) begin 
    if(test < 5) begin
    // Dispatch handling code (only when dispatch is not stalled and queue is not empty)
    if (stall_in == 0 && counter > 0) begin
        instruction_dispatched[74:0] = queue[start_idx];
        $display("instruction_dispatched: %b", instruction_dispatched);
        MajorOpcode_out[3:0] = instruction_dispatched[74:71];
        $display("MajorOpcode_out: %b", MajorOpcode_out);
        Source1_out[4:0] = instruction_dispatched[70:66];
        $display("Source1_out: %b", Source1_out);
        Source2_out[4:0] = instruction_dispatched[65:61];
        $display("Source2_out: %b", Source2_out);
        OffsetScale_out[1:0] = instruction_dispatched[60:59];
        $display("OffsetScale_out: %b", OffsetScale_out);
        Destination_out[4:0] = instruction_dispatched[58:54];
        $display("Destination_out: %b", Destination_out);
        MinorOpcode_out[3:0] = instruction_dispatched[53:50];
        $display("MinorOpcode_out: %b", MinorOpcode_out);
        HasAddress_out = instruction_dispatched[49];
        $display("HasAddress_out: %b", HasAddress_out);
        Address_out[47:0] = instruction_dispatched[48:1];
        $display("Address_out: %b", Address_out);
        OffsetSub_out = instruction_dispatched[0];
        $display("OffsetSub_out: %b", OffsetSub_out);

        // Reset start_idx when we reach the end of the queue
        if(start_idx == 7) begin
            start_idx = 0;
        end else begin
            start_idx = start_idx + 1;
        end
        $display("start_idx: %d", start_idx);

        counter = counter - 1;
        $display("counter: %d", counter);
    end

    // Handle fetched instruction (only when we are not at capacity)
    if(counter != 8) begin
        instruction_fetched[74:0]  = {MajorOpcode_in, Source1_in, Source2_in, OffsetScale_in, Destination_in, MinorOpcode_in, HasAddress_in, Address_in, OffsetSub_in};
        $display("instruction_fetched: %b", instruction_fetched);

        queue[end_idx] = instruction_fetched;
        $display("queue info: %b", queue[end_idx]);
        counter = counter + 1;
        $display("counter: %d", counter);

        // Reset end_idx when we reach the end of the queue
        if(end_idx == 7) begin
            end_idx = 0;
        end else begin
            end_idx = end_idx + 1;
        end
        $display("end_idx: %d", end_idx);
    end 
    test = test + 1;
    end
end
endmodule 