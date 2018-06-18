
module	LCDController(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Inputs
			//------------------------------------------------------------------
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Outputs
			//------------------------------------------------------------------
			State,
			Enable,
			RS,
			RW,
			Data
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	reg		REPEAT_STATE = 1;
	reg		PREVIOUS_STATE	=	3'b000;
										
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock;	// System clock
	input					Reset;	// System reset
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Inputs
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Outputs
	//--------------------------------------------------------------------------
	output	[2:0]		State;
	output			 Enable;
	output				reg RS;
	output				reg RW;
	output	[7:0]		Data;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	State Encoding
	//--------------------------------------------------------------------------
	
	// place state encoding here
	
	//--------------------------------------------------------------------------

	parameter [2:0] 	FUNCTION_SET = 3'b000,
						DISPLAY_ONOFF = 3'b001,
						DISPLAY_CLEAR = 3'b010,
						ENTRY_MODE_SET = 3'b011,
						WAIT_30MS = 3'b100,
						WAIT_39US = 3'b101,
						WAIT_153MS = 3'b110;

	
	//--------------------------------------------------------------------------
	//	Wire Declarations
	//--------------------------------------------------------------------------
	
	reg[2:0]	estado, next;
	reg[7:0] dados;
	
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Logic
	//--------------------------------------------------------------------------
	
	always @(posedge Clock or posedge Reset) begin
		if(Reset) 	estado <= DISPLAY_ONOFF;
		else		estado <= next;
	end

	always @(estado) begin
		case(estado)
			WAIT_30MS: begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00000000;
						REPEAT_STATE = 0;
                        //-------O valor X ainda será calculado--------
						if(REPEAT_STATE == X)	begin
							next = PREVIOUS_STATE;
						end
						else	begin
							REPEAT_STATE = REPEAT_STATE + 1;
							next = WAIT_30MS;
						end
			end
			
			WAIT_39US: begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00000000;
						REPEAT_STATE = 0;
                        //-------O valor X ainda será calculado--------
						if(REPEAT_STATE == X)	begin
							if(PREVIOUS_STATE == FUNCTION_SET)	next = DISPLAY_ONOFF;
							else								next = DISPLAY_CLEAR;
						end
						else	begin
							REPEAT_STATE = REPEAT_STATE + 1;
							next = WAIT_30MS;
						end
			end

			WAIT_153MS: begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00000000;
						REPEAT_STATE = 0;
                        //-------O valor X ainda será calculado--------
						if(REPEAT_STATE == X)	next = ENTRY_MODE_SET;
						else	begin
							REPEAT_STATE = REPEAT_STATE + 1;
							next = WAIT_30MS;
						end
			end

			FUNCTION_SET:	begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b001111xx;
						REPEAT_STATE = 0;
						PREVIOUS_STATE = estado;
						next = WAIT_39US;
					end

			DISPLAY_ONOFF:	begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00001111;
						REPEAT_STATE = 0;
						PREVIOUS_STATE = estado;
						next = WAIT_39US;
					end

			DISPLAY_CLEAR:	begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00000001;
						REPEAT_STATE = 0;
						PREVIOUS_STATE = estado;
						next = WAIT_153MS;
					end

			ENTRY_MODE_SET:	begin
						RS = 1'b0;
						RW = 1'b0;
						dados = 8'b00000111;
						REPEAT_STATE = 0;
						PREVIOUS_STATE = estado;
						next = WAIT_30MS;
					end

		endcase
	end

	assign State = estado;
	assign Enable = Clock;
	assign Data = dados;


	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
