// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msw_is_0,       // Indicates MSW of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one 2-byte word from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

typedef enum {
	idle_st,
	a_0_b_0_st,
	a_1_b_0_st,
	a_0_b_1_st,
	a_1_b_1_st
} sm_type;

sm_type current_state;
sm_type next_state;


always_ff @(posedge clk, posedge reset) begin
	if (reset == 1'b1) begin
		current_state <= idle_st;
		// might need to update busy & clr_prod
	end
	else begin
		current_state <= next_state;
	end
end

always_comb begin
	next_state = current_state;
	busy = 1'b1;
	a_sel = 1'b1;
	b_sel = 1'b1;
	shift_sel = 2'b1;
	upd_prod = 1'b1;
	clr_prod = 1'b0;
	
	case (current_state)
		idle_st: begin
			if (start == 1'b1) begin
				next_state = a_0_b_0_st;
				busy = 1'b0;
				a_sel = 1'b0;
				b_sel = 1'b0;
				shift_sel = 2'b0;
			end
			else begin
				next_state = idle_st;
				busy = 1'b0;
				upd_prod = 1'b0;
			end
		end
		a_0_b_0_st: begin
			if (a_msw_is_0 == 1'b0) begin
				b_sel = 1'b0;
				next_state = a_1_b_0_st;
			end
			else begin
				case (b_msw_is_0)
					1'b0: begin 
					a_sel = 1'b0;
					next_state = a_0_b_1_st; 
					end
					1'b1: begin 
					next_state = idle_st; 
					upd_prod = 1'b0;
					end
				endcase
			end
		end
		a_1_b_0_st: begin
			case (b_msw_is_0)
				1'b0: begin
				next_state = a_0_b_1_st; 
				a_sel = 1'b0;
				end
				1'b1: begin
				next_state = idle_st;
				upd_prod = 1'b0;
				end
			endcase
		end
		a_0_b_1_st: begin
			case (a_msw_is_0)
			1'b0: begin 
			next_state = a_1_b_1_st;
			shift_sel = 2'b10;
			end
			1'b1: begin 
			next_state = idle_st;
			upd_prod = 1'b0;
			end
			endcase
		end
		a_1_b_1_st: begin
			next_state = idle_st;
			upd_prod = 1'b0;
		end
	endcase
end


endmodule
