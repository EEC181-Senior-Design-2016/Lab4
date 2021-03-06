module lab4(
      input              CLOCK_50,
      
		output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
      
		output      [6:0]  HEX0,
      output      [6:0]  HEX1,
      output      [6:0]  HEX2,
      output      [6:0]  HEX3,
      output      [6:0]  HEX4,
      output      [6:0]  HEX5,
		
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,

      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,

      input              HPS_UART_RX,
      output             HPS_UART_TX,

      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,

      input       [3:0]  KEY,

      output      [9:0]  LEDR,

      input       [9:0]  SW,

      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
);

wire         		 hps_fpga_reset_n;
wire               clk_65;
wire [7:0]         vid_r,vid_g,vid_b;
wire               vid_v_sync ;
wire               vid_h_sync ;
wire               vid_datavalid;
   
assign   VGA_BLANK_N          =     1'b1;
assign   VGA_SYNC_N           =     1'b0;	

assign   VGA_CLK              =     clk_65;
assign   {VGA_B,VGA_G,VGA_R}  =     {vid_b,vid_g,vid_r};
assign   VGA_VS               =     vid_v_sync;
assign   VGA_HS               =     vid_h_sync;
 QSYS_lab4 u0 (
		  .clk_65_clk 									  ( clk_65),
        .memory_mem_a                          ( HPS_DDR3_ADDR),
        .memory_mem_ba                         ( HPS_DDR3_BA),
        .memory_mem_ck                         ( HPS_DDR3_CK_P),
        .memory_mem_ck_n                       ( HPS_DDR3_CK_N),
        .memory_mem_cke                        ( HPS_DDR3_CKE),
        .memory_mem_cs_n                       ( HPS_DDR3_CS_N),
        .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),
        .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),
        .memory_mem_we_n                       ( HPS_DDR3_WE_N),
        .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),
        .memory_mem_dq                         ( HPS_DDR3_DQ),
        .memory_mem_dqs                        ( HPS_DDR3_DQS_P),
        .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),
        .memory_mem_odt                        ( HPS_DDR3_ODT),
        .memory_mem_dm                         ( HPS_DDR3_DM),
        .memory_oct_rzqin                      ( HPS_DDR3_RZQ),		  
		  .hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),    
        .hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ), 
        .hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ), 
        .hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),     
        .hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),
        .hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),
		  .hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),
        .hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),
        .hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ), 
        .hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),    
        .hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),   
        .hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),   
		  .hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX    ),   
        .hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX    ),   
		  .led_pio_external_connection_export    (LEDR),        
        .dipsw_pio_external_connection_export  ( SW ),  
        .hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),      
		  .alt_vip_itc_0_clocked_video_vid_clk         (~clk_65),         	
        .alt_vip_itc_0_clocked_video_vid_data        ({vid_r,vid_g,vid_b}),
        .alt_vip_itc_0_clocked_video_underflow       (),                   
        .alt_vip_itc_0_clocked_video_vid_datavalid   (vid_datavalid),      
        .alt_vip_itc_0_clocked_video_vid_v_sync      (vid_v_sync),      	
        .alt_vip_itc_0_clocked_video_vid_h_sync      (vid_h_sync),      	
        .alt_vip_itc_0_clocked_video_vid_f           (),           			
        .alt_vip_itc_0_clocked_video_vid_h           (),           			
        .alt_vip_itc_0_clocked_video_vid_v           (),            		

		  .sdram_wire_addr        (DRAM_ADDR),        //       sdram_wire.addr
        .sdram_wire_ba          (DRAM_BA),          //                 .ba
        .sdram_wire_cas_n       (DRAM_CAS_N),       //                 .cas_n
        .sdram_wire_cke         (DRAM_CKE),         //                 .cke
        .sdram_wire_cs_n        (DRAM_CS_N),        //                 .cs_n
        .sdram_wire_dq          (DRAM_DQ[15:0]),          //                 .dq:]
        .sdram_wire_dqm         ({DRAM_UDQM,DRAM_LDQM}),         //                 .dqm
        .sdram_wire_ras_n       (DRAM_RAS_N),       //                 .ras_n
        .sdram_wire_we_n        (DRAM_WE_N),         //                 .we_n
		  
        .clk_clk                                   (CLOCK_50),                                   //                           clk.clk
        .reset_reset                               (~hps_fpga_reset_n),                               //                         reset.reset
        .sdram_clk_clk                             (DRAM_CLK)                              //                     sdram_clk.

    );
endmodule

/*

    QSYS_lab4 u0 (
        .alt_vip_itc_0_clocked_video_vid_clk       (<connected-to-alt_vip_itc_0_clocked_video_vid_clk>),       //   alt_vip_itc_0_clocked_video.vid_clk
        .alt_vip_itc_0_clocked_video_vid_data      (<connected-to-alt_vip_itc_0_clocked_video_vid_data>),      //                              .vid_data
        .alt_vip_itc_0_clocked_video_underflow     (<connected-to-alt_vip_itc_0_clocked_video_underflow>),     //                              .underflow
        .alt_vip_itc_0_clocked_video_vid_datavalid (<connected-to-alt_vip_itc_0_clocked_video_vid_datavalid>), //                              .vid_datavalid
        .alt_vip_itc_0_clocked_video_vid_v_sync    (<connected-to-alt_vip_itc_0_clocked_video_vid_v_sync>),    //                              .vid_v_sync
        .alt_vip_itc_0_clocked_video_vid_h_sync    (<connected-to-alt_vip_itc_0_clocked_video_vid_h_sync>),    //                              .vid_h_sync
        .alt_vip_itc_0_clocked_video_vid_f         (<connected-to-alt_vip_itc_0_clocked_video_vid_f>),         //                              .vid_f
        .alt_vip_itc_0_clocked_video_vid_h         (<connected-to-alt_vip_itc_0_clocked_video_vid_h>),         //                              .vid_h
        .alt_vip_itc_0_clocked_video_vid_v         (<connected-to-alt_vip_itc_0_clocked_video_vid_v>),         //                              .vid_v
        .clk_65_clk                                (<connected-to-clk_65_clk>),                                //                        clk_65.clk
        .dipsw_pio_external_connection_export      (<connected-to-dipsw_pio_external_connection_export>),      // dipsw_pio_external_connection.export
        .hps_0_h2f_reset_reset_n                   (<connected-to-hps_0_h2f_reset_reset_n>),                   //               hps_0_h2f_reset.reset_n
        .hps_0_hps_io_hps_io_sdio_inst_CMD         (<connected-to-hps_0_hps_io_hps_io_sdio_inst_CMD>),         //                  hps_0_hps_io.hps_io_sdio_inst_CMD
        .hps_0_hps_io_hps_io_sdio_inst_D0          (<connected-to-hps_0_hps_io_hps_io_sdio_inst_D0>),          //                              .hps_io_sdio_inst_D0
        .hps_0_hps_io_hps_io_sdio_inst_D1          (<connected-to-hps_0_hps_io_hps_io_sdio_inst_D1>),          //                              .hps_io_sdio_inst_D1
        .hps_0_hps_io_hps_io_sdio_inst_CLK         (<connected-to-hps_0_hps_io_hps_io_sdio_inst_CLK>),         //                              .hps_io_sdio_inst_CLK
        .hps_0_hps_io_hps_io_sdio_inst_D2          (<connected-to-hps_0_hps_io_hps_io_sdio_inst_D2>),          //                              .hps_io_sdio_inst_D2
        .hps_0_hps_io_hps_io_sdio_inst_D3          (<connected-to-hps_0_hps_io_hps_io_sdio_inst_D3>),          //                              .hps_io_sdio_inst_D3
        .hps_0_hps_io_hps_io_usb1_inst_D0          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D0>),          //                              .hps_io_usb1_inst_D0
        .hps_0_hps_io_hps_io_usb1_inst_D1          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D1>),          //                              .hps_io_usb1_inst_D1
        .hps_0_hps_io_hps_io_usb1_inst_D2          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D2>),          //                              .hps_io_usb1_inst_D2
        .hps_0_hps_io_hps_io_usb1_inst_D3          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D3>),          //                              .hps_io_usb1_inst_D3
        .hps_0_hps_io_hps_io_usb1_inst_D4          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D4>),          //                              .hps_io_usb1_inst_D4
        .hps_0_hps_io_hps_io_usb1_inst_D5          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D5>),          //                              .hps_io_usb1_inst_D5
        .hps_0_hps_io_hps_io_usb1_inst_D6          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D6>),          //                              .hps_io_usb1_inst_D6
        .hps_0_hps_io_hps_io_usb1_inst_D7          (<connected-to-hps_0_hps_io_hps_io_usb1_inst_D7>),          //                              .hps_io_usb1_inst_D7
        .hps_0_hps_io_hps_io_usb1_inst_CLK         (<connected-to-hps_0_hps_io_hps_io_usb1_inst_CLK>),         //                              .hps_io_usb1_inst_CLK
        .hps_0_hps_io_hps_io_usb1_inst_STP         (<connected-to-hps_0_hps_io_hps_io_usb1_inst_STP>),         //                              .hps_io_usb1_inst_STP
        .hps_0_hps_io_hps_io_usb1_inst_DIR         (<connected-to-hps_0_hps_io_hps_io_usb1_inst_DIR>),         //                              .hps_io_usb1_inst_DIR
        .hps_0_hps_io_hps_io_usb1_inst_NXT         (<connected-to-hps_0_hps_io_hps_io_usb1_inst_NXT>),         //                              .hps_io_usb1_inst_NXT
        .hps_0_hps_io_hps_io_uart0_inst_RX         (<connected-to-hps_0_hps_io_hps_io_uart0_inst_RX>),         //                              .hps_io_uart0_inst_RX
        .hps_0_hps_io_hps_io_uart0_inst_TX         (<connected-to-hps_0_hps_io_hps_io_uart0_inst_TX>),         //                              .hps_io_uart0_inst_TX
        .led_pio_external_connection_export        (<connected-to-led_pio_external_connection_export>),        //   led_pio_external_connection.export
        .memory_mem_a                              (<connected-to-memory_mem_a>),                              //                        memory.mem_a
        .memory_mem_ba                             (<connected-to-memory_mem_ba>),                             //                              .mem_ba
        .memory_mem_ck                             (<connected-to-memory_mem_ck>),                             //                              .mem_ck
        .memory_mem_ck_n                           (<connected-to-memory_mem_ck_n>),                           //                              .mem_ck_n
        .memory_mem_cke                            (<connected-to-memory_mem_cke>),                            //                              .mem_cke
        .memory_mem_cs_n                           (<connected-to-memory_mem_cs_n>),                           //                              .mem_cs_n
        .memory_mem_ras_n                          (<connected-to-memory_mem_ras_n>),                          //                              .mem_ras_n
        .memory_mem_cas_n                          (<connected-to-memory_mem_cas_n>),                          //                              .mem_cas_n
        .memory_mem_we_n                           (<connected-to-memory_mem_we_n>),                           //                              .mem_we_n
        .memory_mem_reset_n                        (<connected-to-memory_mem_reset_n>),                        //                              .mem_reset_n
        .memory_mem_dq                             (<connected-to-memory_mem_dq>),                             //                              .mem_dq
        .memory_mem_dqs                            (<connected-to-memory_mem_dqs>),                            //                              .mem_dqs
        .memory_mem_dqs_n                          (<connected-to-memory_mem_dqs_n>),                          //                              .mem_dqs_n
        .memory_mem_odt                            (<connected-to-memory_mem_odt>),                            //                              .mem_odt
        .memory_mem_dm                             (<connected-to-memory_mem_dm>),                             //                              .mem_dm
        .memory_oct_rzqin                          (<connected-to-memory_oct_rzqin>),                          //                              .oct_rzqin
        .sdram_wire_addr                           (<connected-to-sdram_wire_addr>),                           //                    sdram_wire.addr
        .sdram_wire_ba                             (<connected-to-sdram_wire_ba>),                             //                              .ba
        .sdram_wire_cas_n                          (<connected-to-sdram_wire_cas_n>),                          //                              .cas_n
        .sdram_wire_cke                            (<connected-to-sdram_wire_cke>),                            //                              .cke
        .sdram_wire_cs_n                           (<connected-to-sdram_wire_cs_n>),                           //                              .cs_n
        .sdram_wire_dq                             (<connected-to-sdram_wire_dq>),                             //                              .dq
        .sdram_wire_dqm                            (<connected-to-sdram_wire_dqm>),                            //                              .dqm
        .sdram_wire_ras_n                          (<connected-to-sdram_wire_ras_n>),                          //                              .ras_n
        .sdram_wire_we_n                           (<connected-to-sdram_wire_we_n>),                           //                              .we_n
        .clk_clk                                   (<connected-to-clk_clk>),                                   //                           clk.clk
        .reset_reset                               (<connected-to-reset_reset>),                               //                         reset.reset
        .sdram_clk_clk                             (<connected-to-sdram_clk_clk>)                              //                     sdram_clk.clk
    );



*/