// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic a_sel,           // Select one 2-byte word from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [1:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msw_is_0,     // Indicates MSW of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

logic [15:0] a_cut;
logic [15:0] b_cut;
logic [31:0] mult_out;
logic [63:0] shift0_out;
logic [63:0] shift16_out;
logic [63:0] shift32_out;
logic [63:0] shifted_res;

always_comb begin

	if(a[31:16] == 16'b0) begin
		a_msw_is_0 = 1;
	end
	else begin
		a_msw_is_0 = 0;
	end
	
	if(b[31:16] == 16'b0) begin
		b_msw_is_0 = 1;
	end
	else begin
		b_msw_is_0 = 0;
	end
	
	
	case (a_sel)
		1'b0: a_cut = a[15:0];
		1'b1: a_cut = a[31:16];
	endcase

	case (b_sel)
		1'b0: b_cut = b[15:0];
		1'b1: b_cut = b[31:16];
	endcase
	
	mult_out = a_cut * b_cut;
	
	shift0_out = mult_out;
	shift16_out = mult_out << 16;
	shift32_out = mult_out << 32;
	
	case (shift_sel)
		2'b0: shifted_res = shift0_out;
		2'b1: shifted_res = shift16_out;
		2'b10: shifted_res = shift32_out;
		default: shifted_res = shift0_out; // needed because we dont want to create a ff
	endcase
	
end

always_ff @(posedge clk, posedge reset) begin
	if (reset == 1'b1) begin
		product <= 63'b0;
	end
	else begin
		if (clr_prod == 1'b1) begin
			product <= 63'b0;
		end
		else if (upd_prod == 1'b1) begin
			product <= product + shifted_res;
		end
	end

end
endmodule
