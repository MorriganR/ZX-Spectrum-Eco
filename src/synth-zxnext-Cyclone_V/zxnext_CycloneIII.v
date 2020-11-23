
module zxnext_CycloneIII(
  input CLK25,
  output [4:0] LEDG,
  input DATA0,
  input DCLK,
  input DCLK_A,
  input DCLK_B,

  output SRAM_CLK,
  output SRAM_CLKENn,
  output SRAM_CE1n,
  output SRAM_OEn,
  output SRAM_ADRLOADn,
  output SRAM_WEn,
  output SRAM_BWEAn,
  output SRAM_BWEBn,
  output SRAM_BWECn,
  output SRAM_BWEDn,
  output [20:0] SRAM_A,
  inout [8:0] SRAM_DQA,
  inout [8:0] SRAM_DQB,
  inout [8:0] SRAM_DQC,
  inout [8:0] SRAM_DQD,

  output PMODA_1,
  output PMODA_2,
  output PMODA_3,
  output PMODA_4,
  output PMODA_7,
  output PMODA_8,
  output PMODA_9,
  output PMODA_10,

  inout PMODB_1,
  inout PMODB_2,
  inout PMODB_3,
  inout PMODB_4,
  inout PMODB_7,
  inout PMODB_8,
  inout PMODB_9,
  inout PMODB_10,

  inout PMODC_1,
  //output PMODC_2,
  //output PMODC_3,
  //output PMODC_4,
  inout PMODC_7,
  inout PMODC_8,
  inout PMODC_9,
  //output PMODC_10,

  input PMODD_1
  //input PMODD_2 => PMODA_7

);
// TEST
  reg [32:0] counter;
  always @ (posedge CLK25) begin
    counter <= counter + 1;
  end
  assign LEDG[4:0] = ~counter[26:22];

// VGA
  wire [2:0] rgb_r_o;
  wire [2:0] rgb_g_o;
  wire [2:0] rgb_b_o;
  wire [1:0] vga_r;
  wire [1:0] vga_g;
  wire [1:0] vga_b;
  wire hsync_o;
  wire vsync_o;
  assign vga_r[1:0] = PMODD_1 ? rgb_r_o[2:1] : rgb_r_o[1:0];
  assign vga_g[1:0] = PMODD_1 ? rgb_g_o[2:1] : rgb_g_o[1:0];
  assign vga_b[1:0] = PMODD_1 ? rgb_b_o[2:1] : rgb_b_o[1:0];
  assign PMODA_1 = vga_r[0];
  assign PMODA_7 = vga_r[1];
  assign PMODA_2 = vga_g[0];
  assign PMODA_8 = vga_g[1];
  assign PMODA_3 = vga_b[0];
  assign PMODA_9 = vga_b[1];
  assign PMODA_4 = hsync_o;
  assign PMODA_10 = vsync_o;

// SRAM
  //wire [18:0] ram_addr_o;
  //wire [7:0] ram_data_io_zxdos;
  wire ram1_we_n_o;
  //wire [18:0] ram2_addr_o;
  //wire [7:0] ram2_data_io_zxdos;
  wire ram2_we_n_o;
  //assign SRAM_WEn = (ram1_we_n_o && ram2_we_n_o);
  //assign SRAM_BWEAn = ram1_we_n_o;
  //assign SRAM_BWEBn = ram2_we_n_o;
  assign SRAM_CLKENn = 1'b0;
  assign SRAM_CE1n = 1'b0;
  //assign SRAM_OEn = 1'b0;
  assign SRAM_ADRLOADn = 1'b0;

//-- Matrix keyboard
  wire [7:0] keyb_row_o;
  wire [6:0] keyb_col_i;
  assign keyb_col_i[6:1] = 6'b111111;
  assign keyb_col_i[0] = PMODB_1;
  assign PMODB_2 = keyb_row_o[7];


ZXNEXT_Cyclone_V ZXNEXT_Cyclone_V(
//-- Clocks
  .CLOCK_50_I  (CLK25), //        : in    std_logic;
//-- Sync SRAM
  .RAM_CLK  (SRAM_CLK), //        : out   std_logic_vector(18 downto 0)  := (others => '0');
  .RAM_ADDR_O  (SRAM_A[18:0]), //        : out   std_logic_vector(18 downto 0)  := (others => '0');
  .RAM_OE_N_O  (SRAM_OEn), //        : out   std_logic                      := '1';
  .RAM_WE_ALL_N_O  (SRAM_WEn), //        : out   std_logic                      := '1';
  .RAM_WE_BYTE_N_O  ({SRAM_BWEDn, SRAM_BWECn, SRAM_BWEBn, SRAM_BWEAn}), //        : out   std_logic_vector(3 downto 0)  := (others => '1');
   //-- SRAM1
  .RAMA_DATA_IO_ZXDOS  (SRAM_DQA[7:0]), // : inout std_logic_vector(7 downto 0)  := (others => 'Z');
  .RAMB_DATA_IO_ZXDOS  (SRAM_DQB[7:0]), // : inout std_logic_vector(7 downto 0)  := (others => 'Z');
  .RAMC_DATA_IO_ZXDOS  (SRAM_DQC[7:0]), // : inout std_logic_vector(7 downto 0)  := (others => 'Z');
  .RAMD_DATA_IO_ZXDOS  (SRAM_DQD[7:0]), // : inout std_logic_vector(7 downto 0)  := (others => 'Z');
//-- PS2
  .ps2_clk_io  (PMODC_9), //        : inout std_logic                      := 'Z';
  .ps2_data_io  (PMODC_1), //       : inout std_logic                      := 'Z';
  .ps2_pin6_io  (PMODC_7), //       : inout std_logic                      := 'Z';  -- Mouse clock
  .ps2_pin2_io  (PMODC_8), //       : inout std_logic                      := 'Z';  -- Mouse data
//  .ps2_clk_io  (PMODB_7), //        : inout std_logic                      := 'Z';
//  .ps2_data_io  (PMODB_8), //       : inout std_logic                      := 'Z';
//  .ps2_pin6_io  (PMODB_9), //       : inout std_logic                      := 'Z';  -- Mouse clock
//  .ps2_pin2_io  (PMODB_10), //       : inout std_logic                      := 'Z';  -- Mouse data
//-- SD Card
  .sd_cs0_n_o  (PMODB_7), //        : out   std_logic                      := '1';
    //--      sd_cs1_n_o        : out   std_logic                      := '1';
  .sd_mosi_o  (PMODB_8), //         : out   std_logic                      := '0';
  .sd_sclk_o  (PMODB_9), //         : out   std_logic                      := '0';
  .sd_miso_i  (PMODB_10), //         : in    std_logic;
//  .sd_cs0_n_o  (PMODC_7), //        : out   std_logic                      := '1';
//    //--      sd_cs1_n_o        : out   std_logic                      := '1';
//  .sd_mosi_o  (PMODC_8), //         : out   std_logic                      := '0';
//  .sd_sclk_o  (PMODC_9), //         : out   std_logic                      := '0';
//  .sd_miso_i  (PMODC_1), //         : in    std_logic;
//-- Joystick zxdos
  .joy_clk  (joy_clk), //           : out   std_logic;
  .joy_load  (joy_load), //          : out   std_logic;
  .joy_data  (1'b1), //          : in    std_logic;
//-- Audio
  .audioext_l_o  (PMODB_3), //      : out   std_logic                      := '0';
  .audioext_r_o  (PMODB_4), //      : out   std_logic                      := '0';
    //--      audioint_o        : out   std_logic                      := '0';
//-- K7
  .ear_port_i  (DATA0), //        : in    std_logic;
    //--      mic_port_o        : out   std_logic                      := '0';
//-- Buttons
  .btn_divmmc_n_i  (1'b1), //    : in    std_logic;
  .btn_multiface_n_i  (1'b1), // : in    std_logic;
    //--      btn_reset_n_i     : in    std_logic;
//-- Matrix keyboard
  .keyb_row_o (keyb_row_o), //        : out   std_logic_vector( 7 downto 0)  := (others => 'Z');
  .keyb_col_i (keyb_col_i), //        : in    std_logic_vector( 6 downto 0);
//-- VGA
  .rgb_r_o  (rgb_r_o), //           : out   std_logic_vector( 2 downto 0)  := (others => '0');
  .rgb_g_o  (rgb_g_o), //           : out   std_logic_vector( 2 downto 0)  := (others => '0');
  .rgb_b_o  (rgb_b_o), //           : out   std_logic_vector( 2 downto 0)  := (others => '0');
  .hsync_o  (hsync_o), //           : out   std_logic                      := '1';
  .vsync_o  (vsync_o) //           : out   std_logic                      := '1';
    //csync_o           : out   std_logic                      := 'Z'
);

endmodule
