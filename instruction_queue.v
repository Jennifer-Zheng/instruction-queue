/*
for the instr queue, determine which reservation station by determining what type of operation it is (ex. floating point add)
- MUST BE FIFO, must block if RS not available, even if next instruction is good to go
*/
/*
1. decide on queue size
2. clock? every clock cycle get a instruction 
- keep track of start and end of queue
- full: counter of entries = queue size
3. how are instructions encoded?
- 
4. need a wire(?) to each reservation station/buffers
- reservation stations for adder, multiplier, load/store buffer, reorder buffer, integer
- incoming wire from each buffer to say if it's empty
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

 // Holds concatenation of the instruction metadata
reg [75:0] instruction;

// Number of instructions that are currently in the queue
integer counter = 0;

always @(posedge clk) begin
    stall_out <= stall_in;
    instruction[75:0]  <= {MajorOpcode_in, Source1_in, Source2_in, OffsetScale_in, Destination_in, MinorOpcode_in, HasAddress_in, Address_in, OffsetSub_in, stall_in};
    $display("instruction bits: %b", instruction);
    //if(stall_in != 1) {

    //}
end
endmodule /* main */