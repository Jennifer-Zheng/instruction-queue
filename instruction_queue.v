/*
Instruction queue is implemented as a circular buffer. 

Key notes:
- The queue itself is a fixed size array (8 instructions * 76 bits for instructions + metadata).
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

// Instruction queue: 76 bits wide * 8 entries
reg [75:0] queue [7:0];

// Location of next instruction to dispatch (aka start of queue)
integer start_idx = 0;

// Location to append next item (aka end of queue)
integer end_idx = 0;

// Number of instructions that are currently in the queue
integer counter = 0;

// Holds concatenation of the instruction metadata
reg [75:0] instruction;

always @(posedge clk) begin
    // Queue is not yet at capacity so we can continue
    if(counter != 8) begin
        stall_out <= stall_in;
        instruction[75:0]  <= {MajorOpcode_in, Source1_in, Source2_in, OffsetScale_in, Destination_in, MinorOpcode_in, HasAddress_in, Address_in, OffsetSub_in, stall_in};
        $display("instruction bits: %b", instruction);
        queue[end_idx] <= instruction;
        $display("queue info: %b", queue[end_idx]);
        end_idx = end_idx + 1;
        $display("end_idx: %d", end_idx);
        counter = counter + 1;
        $display("counter: %d", counter);

        // Reset end_idx when we reach the end of the queue
        if(end_idx == 7) begin
            end_idx = 0;
        end
    
    end 
    else begin
        // Queue is at capacity so stall until we have an empty slot.

    end 
end
endmodule /* main */