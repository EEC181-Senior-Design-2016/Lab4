module sdram_master_lab4_ver3(
input       clk,
input       reset_n,
input       waitrequest,
input       ready,
input       readdatavalid,
input       [15:0]  readdata,
// *******************
output [31:0] toHexLed,                   // outputs readdata
output chipselect,                       // always 1
output [1:0]   byteenable,               // always 'b11
// *******************
output reg done,                             // 0 or 1
output reg read_n,                           // 0 or 1
output reg write_n,                          // 0 or 1
// *******************
output reg [15:0] writedata,                 // writes result 2 pixs at a time
output reg [31:0] address
);
// ###################################### STATES ####
localparam WAIT_READY_ST    = 0; 
localparam READY_ST         = 1; 
localparam RESET_ST         = 2; 
localparam IDLE_ST          = 3; 
//  ********************
localparam READ_2NUMS_ST    = 4; 
localparam SHIFT_ST         = 5;
localparam WRITE_RESULT_ST  = 6;
localparam CONTINUE_ST      = 7;
localparam WAIT_READ_ST     = 8;
localparam CALC_ST          = 9;
// ##################################### BASE_ADDRS ####
localparam BASE_ADDR_READ   = 32'h0;  
localparam BASE_ADDR_WRITE  = 32'h40000;  
// #####################################  MAXS ####
localparam MAX_COUNT_TIMER          = 17'd100000;
localparam MAX_COUNT_INITIAL_READ   = 18'd513;     // (512*2 +4)/2- 1 = 16 bit numbers in a row     
localparam MAX_COUNT_IMAGE_WHOLE    = 18'd131071;  // (512x512) / 2  -1 = 16 bit numbers in whole image
// ##################################### VARIABLES ####
reg [3:0]   State = WAIT_READY_ST;
reg [16:0]  Timer = 0;
//  **************************
reg [31:0]  address_read = BASE_ADDR_READ;
reg [31:0]  address_write = BASE_ADDR_WRITE;
reg [17:0]  Read_count = 0;
// ##################################### ARRAY ####
reg [15:0] Buffer = 0;
reg [8223:0] Sdramframe = 0;
wire signed [10:0] DX1,DY1,DX2,DY2;
wire [10:0] D1, D2;
// ######################################################################
// ##################################### FUNCTION LOGIC ####

function [10:0] abs( input signed [10:0] x);
  abs = x >= 0 ? x : -x;
endfunction

// ######################################################################
// ##################################### ASSIGN LOGIC ####
assign toHexLed = {{8{1'b0}}, State, waitrequest, readdatavalid,Read_count};
assign chipselect = 1'b1;
assign byteenable =  2'b11;
    //  *************************************
assign DX1 = - ({3'b000,Sdramframe[8223:8216]}) 
             + ({3'b000,Sdramframe[8207:8200]})
             - (({3'b000,Sdramframe[4127:4120]}) << 1) 
             + (({3'b000,Sdramframe[4111:4104]}) << 1)
             - ({3'b000,Sdramframe[31:24]}) 
             + ({3'b000,Sdramframe[15:8]});
             
assign DY1 =   ({3'b000,Sdramframe[8223:8216]}) 
             + (({3'b000,Sdramframe[8215:8208]}) << 1) 
             + ({3'b000,Sdramframe[8207:8200]})
             - ({3'b000,Sdramframe[31:24]}) 
             - (({3'b000,Sdramframe[23:16]}) << 1) 
             - ({3'b000,Sdramframe[15:8]});             
             
assign DX2 = - ({3'b000,Sdramframe[8215:8208]}) 
             + ({3'b000,Sdramframe[8199:8192]})
             - (({3'b000,Sdramframe[4119:4112]}) << 1) 
             + (({3'b000,Sdramframe[4103:4096]}) << 1)
             - ({3'b000,Sdramframe[23:16]}) 
             + ({3'b000,Sdramframe[7:0]});
             
assign DY2 =   ({3'b000,Sdramframe[8215:8208]}) 
             + (({3'b000,Sdramframe[8207:8200]}) << 1) 
             + ({3'b000,Sdramframe[8199:8192]})
             - ({3'b000,Sdramframe[23:16]}) 
             - (({3'b000,Sdramframe[15:8]}) << 1) 
             - ({3'b000,Sdramframe[7:0]});
             
assign D1 = abs(DX1) + abs(DY1);
assign D2 = abs(DX2) + abs(DY2);

// ###################################################################### 
// ##################################### SEQUENTIAL LOGIC ####
//  **************************************************** State Machine
always @ (posedge clk) begin
    if (!reset_n || State == RESET_ST)  begin State <= WAIT_READY_ST; end
    else begin
        case (State)
        WAIT_READY_ST:   begin  State <= (Timer > MAX_COUNT_TIMER)              ? READY_ST : WAIT_READY_ST; end
        READY_ST:        begin  State <= (ready)                                ? READ_2NUMS_ST : WAIT_READY_ST; end
        IDLE_ST:         begin  State <=                                          IDLE_ST; end
    //  ************************************************************
        READ_2NUMS_ST:   begin  State <= (!waitrequest)                         ? WAIT_READ_ST : READ_2NUMS_ST; end
        WAIT_READ_ST:    begin  State <= (readdatavalid)                        ? SHIFT_ST : WAIT_READ_ST; end
        SHIFT_ST:        begin  State <=                                          CALC_ST; end
        CALC_ST:         begin  State <= (Read_count > MAX_COUNT_INITIAL_READ)  ? WRITE_RESULT_ST : READ_2NUMS_ST; end
        WRITE_RESULT_ST: begin  State <= (!waitrequest)                         ? CONTINUE_ST : WRITE_RESULT_ST; end
        CONTINUE_ST:     begin  State <= (Read_count > MAX_COUNT_IMAGE_WHOLE)   ? IDLE_ST : READ_2NUMS_ST; end 
        default:         begin  State <=                                          RESET_ST; end
        endcase
    end // else
end // always clk
//  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @ (posedge clk) begin
    if (!reset_n || State == RESET_ST)  begin 
        Timer <= 0;
    //  **************************
        address_read    <= BASE_ADDR_READ;
        address_write   <= BASE_ADDR_WRITE;
    //  **************************
        Read_count      <= 0;
        Buffer          <= 0;
    //  **************************        
        Sdramframe      <= 0;
    end
    else begin 
        Timer           <= (State == WAIT_READY_ST) ? Timer + 17'd1 : 0;
    //  **************************
        address_read    <= (State == WAIT_READ_ST && readdatavalid)     ? address_read + 32'h2 : address_read;
        address_write   <= (State == WRITE_RESULT_ST && !waitrequest)   ? address_write + 32'h2 : address_write;
    //  **************************
        Read_count      <= (State == WAIT_READ_ST && readdatavalid) ? Read_count + 18'd1 : Read_count;
        Buffer          <= (State == WAIT_READ_ST && readdatavalid) ? readdata : Buffer;
    //  **************************
        Sdramframe      <= (State == SHIFT_ST) ? ({Sdramframe[8207:0],Buffer[7:0],Buffer[15:8]}) : Sdramframe;
    end // else
end// always clk
// ###################################################################### 
// ##################################### COMBINATIONAL LOGIC

always @ (*) begin
    done    = (State == IDLE_ST)            ? 1'b1 : 0;
    read_n  = (State == READ_2NUMS_ST)      ? 0 : 1'b1;
    write_n = (State == WRITE_RESULT_ST)    ? 0 : 1'b1; 
//  **************************
    address = (State == WRITE_RESULT_ST) ? address_write : address_read;
    writedata = {D2[10:3],D1[10:3]};
end

// ========================= END ========================= END ========================= END 
// ========================= END ========================= END ========================= END 
endmodule

