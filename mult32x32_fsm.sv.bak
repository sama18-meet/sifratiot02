// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one 2-byte word from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

typedef enum {
	idle_st,
	start_st,
	a_0_b_0_st,
	a_1_b_0_st,
	a_0_b_1_st
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
				next_state = start_st;
				busy = 1'b0;
				clr_prod = 1'b1;
			end
			else begin 
				next_state = idle_st;
				busy = 1'b0;
				upd_prod = 1'b0;
			end
		end
		
		start_st: begin 
			a_sel = 1'b0;
			b_sel = 1'b0;
			shift_sel = 1'b0;
			next_state = a_0_b_0_st;
		end
		
		a_0_b_0_st: begin 
			b_sel = 1'b0;
			next_state = a_1_b_0_st;
		end
		
		a_1_b_0_st: begin
			a_sel = 1'b0;
			next_state = a_0_b_1_st;
		end
		
		a_0_b_1_st: begin
			shift_sel = 2'b10;
			next_state = start_st;
		end	

	endcase
end

endmodule
