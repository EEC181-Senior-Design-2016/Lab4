module sdram_master(
input						clk,
input						waitrequest,
input						readdatavalid,
input 		[15:0]	readdata,
input						reset_n,
input 					ready,
//****************************************
output reg				chipselect,				// always 1
output reg 	[1:0]		byteenable,				// always 'b11
//****************************************
output reg 				done,						// 0 or 1
output reg 				read_n,					// 0 or 1
output reg				write_n,					// 0 or 1
//****************************************
output reg 	[31:0]	address = BASE_ADDR,			// constant ADDRs
output reg	[15:0]	writedata,				// Max or Min
//****************************************
output 		[31:0]	toHexLed					// outputs readdata
);
//############################################## CONSTANTS
localparam WAIT_ST = 0;	
localparam READY_ST = 1;	
localparam READ_ST = 2;
localparam MAX_ST = 3; 		
localparam MIN_ST = 4;		
localparam RESET_ST = 5;	
localparam IDLE_ST = 6;	
//****************************************							
localparam BASE_ADDR 	 = 32'h0;		
localparam BASE_ADDR_MAX = 32'h14;		
localparam BASE_ADDR_MIN = 32'h16;
//****************************************
localparam MAX_READ_COUNT = 'h9;
localparam MAX_TIMER = 17'd100_000;
//############################################## INTERNAL REGS
reg [2:0] 	State = RESET_ST;
reg [2:0]	State_next = RESET_ST;
reg [3:0] 	Read_count = 0;
reg [16:0] 	Timer = 0;
reg [15:0]	Maxnum = 0; 
reg [15:0]	Minnum = 16'hFFFF; 
reg [31:0]	address_next = BASE_ADDR; 
//################################################################################### ASSIGN LOGIC
assign toHexLed = {Maxnum,Minnum};

// ################################################################################## SEQUENTIAL LOGIC
// **************************************************************************** always update constant regs 
always @ (posedge clk) begin
	// constant regs
		chipselect 	<= 1'b1;
		byteenable 	<= 2'b11;
end 
// **************************************************************************** always update 1 bit signals
always @ (posedge clk) begin
		// 1 bit signals
		if (reset_n == 0 || State == RESET_ST) begin
			done 		<= 0;
			read_n	    <= 1'b1;
			write_n 	<= 1'b1;	
		end	
		else begin
			done 		<= (Read_count > MAX_READ_COUNT)	? 1 : 0;
			read_n 	    <= (State == READ_ST)	? 0 : 1'b1;
			write_n 	<= (State == MAX_ST || State == MIN_ST)	? 0 : 1'b1;
		end
end 
// **************************************************************************** always update regs w/ reset 
always @ (posedge clk) begin
        // multiple bit signals
		if (reset_n == 0 || State == RESET_ST) begin
			State 		<= READY_ST;
			Read_count	<= 0;
			Timer 		<= 0;
            Maxnum      <= 0;
            Minnum      <= 16'hFFFF;
			address		<= BASE_ADDR;
			writedata	<= 0;
		end	
		else begin
			State 		<= State_next;
            Timer 		<= (State == WAIT_ST) ? Timer + 17'h1 : 0;
			Read_count	<= (State == READ_ST && readdatavalid) ? Read_count + 4'h1 : Read_count;
            Maxnum      <= (State == READ_ST && readdatavalid && Read_count < 4'hA && readdata > Maxnum) ? readdata : Maxnum;
            Minnum      <= (State == READ_ST && readdatavalid && Read_count < 4'hA && readdata < Minnum) ? readdata : Minnum;
			writedata	<= (State == MAX_ST) ? Maxnum : Minnum;
            address		<= address_next;
		end
end 
// ################################################################################## COMBINATIONAL LOGIC
// **************************************************************************** always update next state
always @ (*) begin
	case (State)
	WAIT_ST:	begin   State_next = (Timer > MAX_TIMER) ? READY_ST : WAIT_ST;	end 
    READY_ST: 	begin	State_next = (ready) ? READ_ST : WAIT_ST;	end
	READ_ST:	begin	State_next = (Read_count > MAX_READ_COUNT) ? MAX_ST : READ_ST; end 
	MAX_ST:		begin   State_next = (waitrequest == 0) ? MIN_ST : MAX_ST;		end
	MIN_ST:		begin   State_next = (waitrequest == 0) ? IDLE_ST : MIN_ST;	    end
	IDLE_ST: 	begin	State_next = IDLE_ST;	end
	RESET_ST: 	begin	State_next = WAIT_ST;	end
	default: 	begin	State_next = RESET_ST;	end
	endcase
	
end 

// **************************************************************************** always update next address
always @ (*) begin
	case (State)
	READ_ST: 	begin address_next = (waitrequest == 0) ? address + 32'h2 : address; end
	MAX_ST:		begin address_next = BASE_ADDR_MAX; end
	MIN_ST:		begin address_next = BASE_ADDR_MIN; end
	RESET_ST: 	begin address_next = BASE_ADDR; end
	default: 	begin address_next = address; end
	endcase
end 
// ################################################ END
endmodule
