
-- ZX Spectrum Next Issue 2 FPGA Top Level
-- Copyright 2020 Alvin Albrecht and Fabio Belavenuto
--
-- TBBLUE Issue 2 Top - Fabio Belavenuto
-- ZXNext Refactor - Alvin Albrecht
-- Ported to ZXDOS by AvlixA, joystick implementation by Fernando Mosquera

--
-- This file is part of the ZX Spectrum Next Project
-- <https://gitlab.com/SpectrumNext/ZX_Spectrum_Next_FPGA/tree/master/cores>
--
-- The ZX Spectrum Next FPGA source code is free software: you can 
-- redistribute it and/or modify it under the terms of the GNU General 
-- Public License as published by the Free Software Foundation, either 
-- version 3 of the License, or (at your option) any later version.
--
-- The ZX Spectrum Next FPGA source code is distributed in the hope 
-- that it will be useful, but WITHOUT ANY WARRANTY; without even the 
-- implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
-- PURPOSE.  See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with the ZX Spectrum Next FPGA source code.  If not, see 
-- <https://www.gnu.org/licenses/>.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
--use UNISIM.VComponents.all;

entity ZXNEXT_Cyclone_V is
   generic (
      g_machine_id      : unsigned(7 downto 0)  := X"EA";   -- EA = ZXDOS
      g_version         : unsigned(7 downto 0)  := X"31";   -- 3.01
      g_sub_version     : unsigned(7 downto 0)  := X"05"    -- .05
   );
   port (
      -- Clocks
      CLOCK_50_I        : in    std_logic;

      -- SRAM (AS7C34096)
    RAM_CLK            : out   std_logic                      := '1';
    RAM_ADDR_O         : out   std_logic_vector(18 downto 0)  := (others => '0');
    RAM_OE_N_O         : out   std_logic                      := '1';
    RAM_WE_ALL_N_O     : out   std_logic                      := '1';
    RAM_WE_BYTE_N_O    : out   std_logic_vector(3 downto 0)  := (others => '1');
    RAMA_DATA_IO_ZXDOS : inout std_logic_vector(7 downto 0)  := (others => 'Z');
    RAMB_DATA_IO_ZXDOS : inout std_logic_vector(7 downto 0)  := (others => 'Z');
    RAMC_DATA_IO_ZXDOS : inout std_logic_vector(7 downto 0)  := (others => 'Z');
    RAMD_DATA_IO_ZXDOS : inout std_logic_vector(7 downto 0)  := (others => 'Z');
    RAM1_WE_N_O        : out   std_logic                      := '1';

      -- SRAM2
     ram2_addr_o        : out   std_logic_vector(18 downto 0)  := (others => '0');
     RAM2_WE_N_O        : out   std_logic                      := '1';            

		-- SDRAM	(H57V256 = 16Mx16 = 32MB)
--		sdram_clk_o			: out   std_logic								:= '0';
--		sdram_cke_o			: out   std_logic								:= '0';
--		sdram_ad_o			: out   std_logic_vector(12 downto 0)	:= (others => '0');
--		sdram_da_io			: inout std_logic_vector(15 downto 0)	:= (others => 'Z');
--		sdram_ba_o			: out   std_logic_vector( 1 downto 0)	:= (others => '0');
--		sdram_dqm_o			: out   std_logic_vector( 1 downto 0)	:= (others => '1');
--		sdram_ras_o			: out   std_logic								:= '1';
--		sdram_cas_o			: out   std_logic								:= '1';
--		sdram_cs_o			: out   std_logic								:= '1';
--		sdram_we_o			: out   std_logic								:= '1';


      -- PS2
      ps2_clk_io        : inout std_logic                      := 'Z';
      ps2_data_io       : inout std_logic                      := 'Z';
      ps2_pin6_io       : inout std_logic                      := 'Z';  -- Mouse clock
      ps2_pin2_io       : inout std_logic                      := 'Z';  -- Mouse data

      -- SD Card
      sd_cs0_n_o        : out   std_logic                      := '1';
--      sd_cs1_n_o        : out   std_logic                      := '1';
      sd_sclk_o         : out   std_logic                      := '0';
      sd_mosi_o         : out   std_logic                      := '0';
      sd_miso_i         : in    std_logic;

      -- Flash
--      flash_cs_n_o      : out   std_logic                      := '1';
--      flash_sclk_o      : out   std_logic                      := '0';
--      flash_mosi_o      : out   std_logic                      := '0';
--      flash_miso_i      : in    std_logic;
--      flash_wp_o        : out   std_logic                      := '0';
--      flash_hold_o      : out   std_logic                      := '1';

      -- Joystick
--      joyp1_i           : in    std_logic;
--      joyp2_i           : in    std_logic;
--      joyp3_i           : in    std_logic;
--      joyp4_i           : in    std_logic;
--      joyp6_i           : in    std_logic;
--      joyp7_o           : out   std_logic                      := '1';
--      joyp9_i           : in    std_logic;
--      joysel_o          : out   std_logic                      := '0';
      
      -- Joystick zxdos
      joy_clk           : out   std_logic;
      joy_load          : out   std_logic;
      joy_data          : in    std_logic;

      -- Audio
      audioext_l_o      : out   std_logic                      := '0';
      audioext_r_o      : out   std_logic                      := '0';
--      audioint_o        : out   std_logic                      := '0';

      -- K7
      ear_port_i        : in    std_logic;
--      mic_port_o        : out   std_logic                      := '0';

      -- Buttons
      btn_divmmc_n_i    : in    std_logic;
      btn_multiface_n_i : in    std_logic;
--      btn_reset_n_i     : in    std_logic;

--      -- Matrix keyboard
      keyb_row_o        : out   std_logic_vector( 7 downto 0)  := (others => 'Z');
      keyb_col_i        : in    std_logic_vector( 6 downto 0);
--
--      -- Bus
--      bus_rst_n_io      : inout std_logic                      := 'Z';
--      bus_clk35_o       : out   std_logic                      := 'Z';
--      bus_addr_o        : out   std_logic_vector(15 downto 0)  := (others => 'Z');
--      bus_data_io       : inout std_logic_vector( 7 downto 0)  := (others => 'Z');
--      bus_int_n_io      : inout std_logic                      := 'Z';
--      bus_nmi_n_i       : in    std_logic;
--      bus_ramcs_i       : in    std_logic;
--      bus_romcs_i       : in    std_logic;
--      bus_wait_n_i      : in    std_logic;
--      bus_halt_n_o      : out   std_logic                      := 'Z';
--      bus_iorq_n_o      : out   std_logic                      := 'Z';
--      bus_m1_n_o        : out   std_logic                      := 'Z';
--      bus_mreq_n_o      : out   std_logic                      := 'Z';
--      bus_rd_n_o        : out   std_logic                      := 'Z';
--      bus_wr_n_o        : out   std_logic                      := 'Z';
--      bus_rfsh_n_o      : out   std_logic                      := 'Z';
--      bus_busreq_n_i    : in    std_logic;
--      bus_busack_n_o    : out   std_logic                      := 'Z';
--      bus_iorqula_n_i   : in    std_logic;

      -- VGA
      rgb_r_o           : out   std_logic_vector( 2 downto 0)  := (others => '0');
      rgb_g_o           : out   std_logic_vector( 2 downto 0)  := (others => '0');
      rgb_b_o           : out   std_logic_vector( 2 downto 0)  := (others => '0');
      hsync_o           : out   std_logic                      := '1';
      vsync_o           : out   std_logic                      := '1';
      csync_o           : out   std_logic                      := 'Z'

      -- HDMI
--      hdmi_p_o          : out   std_logic_vector(3 downto 0);
--      hdmi_n_o          : out   std_logic_vector(3 downto 0);

--      -- I2C (RTC and HDMI)
--      i2c_scl_io        : inout std_logic                      := 'Z';
--      i2c_sda_io        : inout std_logic                      := 'Z';

--      -- ESP
--      esp_gpio0_io      : inout std_logic                      := 'Z';
--      esp_gpio2_io      : inout std_logic                      := 'Z';
--      esp_rx_i          : in    std_logic;
--      esp_tx_o          : out   std_logic                      := '1';
--
--      -- PI GPIO
--      accel_io          : inout std_logic_vector(27 downto 0)  := (others => 'Z');
--
--      -- Vacant pins
--      extras_io         : inout std_logic := 'Z'
   );
end entity;

architecture rtl of ZXNEXT_Cyclone_V is

--   component pll_top
--   port
--   (
--      SSTEP       : in std_logic;
--      STATE       : in std_logic_vector(2 downto 0);
--      RST         : in std_logic;
--      CLKIN       : in std_logic;
--      SRDY        : out std_logic;
--  
--      CLK0OUT     : out std_logic;
--      CLK1OUT     : out std_logic;
--      CLK2OUT     : out std_logic;
--      CLK3OUT     : out std_logic;
--      CLK4OUT     : out std_logic;
--      CLK5OUT     : out std_logic
--   );
--   end component;
   
	
--	 component clocks 
--	 port 
--	 (
--		
--		refclk   : in  std_logic := '0'; --  refclk.clk
--		rst      : in  std_logic := '0'; --   reset.reset
--		outclk_0 : out std_logic;        -- outclk0.clk
--		outclk_1 : out std_logic;        -- outclk1.clk
--		outclk_2 : out std_logic;        -- outclk2.clk
--		outclk_3 : out std_logic;        -- outclk3.clk
--		outclk_4 : out std_logic;        -- outclk4.clk
--		outclk_5 : out std_logic;        -- outclk5.clk
----		outclk_6 : out std_logic;        -- outclk6.clk
--		locked   : out std_logic         -- locked.export 
--	);
--	end component;
   component clocks
      PORT
      (
         areset		: IN STD_LOGIC  := '0';
         inclk0		: IN STD_LOGIC  := '0';
         c0		: OUT STD_LOGIC ;
         c1		: OUT STD_LOGIC ;
         c2		: OUT STD_LOGIC ;
         c3		: OUT STD_LOGIC ;
         c4		: OUT STD_LOGIC ;
         locked		: OUT STD_LOGIC 
      );
   end component;
	
	--	 component next_clocks
--		port (-- Clock in ports
--		CLK_IN1           : in     std_logic;
--		-- Clock out ports
--		CLK_OUT1          : out    std_logic;
--		CLK_OUT2          : out    std_logic;
--		CLK_OUT3          : out    std_logic;
--		CLK_OUT4          : out    std_logic;
--		CLK_OUT5          : out    std_logic;
--		CLK_OUT6          : out    std_logic;
--		-- Status and control signals
--		RESET             : in     std_logic
--	);
--	end component;

--   component sdram
--	port
--	(
--	-- interface to the MT48LC16M16 chip
--	sd_data 				: inout std_logic_vector(15 downto 0);
--	sd_addr				: out std_logic_vector(12 downto 0);
--	sd_dqm				: out std_logic_vector(1 downto 0);
--	sd_ba					: out std_logic_vector(1 downto 0);
--	sd_cs					: out std_logic;
--	sd_we					: out std_logic;
--	sd_ras				: out std_logic;
--	sd_cas				: out std_logic;
--
--	-- cpu/chipset interface
--	init					: in std_logic;
--	clk					: in std_logic;
--	clkref				: in std_logic;
--	
--	addrA					: in  std_logic_vector(24 downto 0);
--	weA					: in  std_logic;
--	dinA					: in  std_logic_vector(7 downto 0);
--	oeA					: in  std_logic;
--   doutA					: out std_logic_vector(7 downto 0);
--
--	addrB					: in  std_logic_vector(24 downto 0);
--	weB					: in  std_logic;
--	dinB					: in  std_logic_vector(7 downto 0);
--	oeB					: in  std_logic;
--	doutB					: out std_logic_vector(7 downto 0)
--   
--	); 
--	end component;

   component ps2_mouse
   port
   (
      reset       : in std_logic;
      clk         : in std_logic;
      
      ps2mdat_i   : in std_logic;
      ps2mclk_i   : in std_logic;
      
      ps2mdat_o   : out std_logic;
      ps2mclk_o   : out std_logic;
      
      control_i   : in  std_logic_vector(2 downto 0);
      
      xcount      : out std_logic_vector(7 downto 0);
      ycount      : out std_logic_vector(7 downto 0);
      zcount      : out std_logic_vector(7 downto 0);
      
      mleft       : out std_logic;
      mright      : out std_logic;
      mthird      : out std_logic
   );
   end component;




   -- input synchronization
   
--   signal joyp1_i_0              : std_logic;
--   signal joyp2_i_0              : std_logic;
--   signal joyp3_i_0              : std_logic;
--   signal joyp4_i_0              : std_logic;
--   signal joyp6_i_0              : std_logic;
--   signal joyp9_i_0              : std_logic;
--   
--   signal joyp1_i_q              : std_logic;
--   signal joyp2_i_q              : std_logic;
--   signal joyp3_i_q              : std_logic;
--   signal joyp4_i_q              : std_logic;
--   signal joyp6_i_q              : std_logic;
--   signal joyp9_i_q              : std_logic;
   
  
 

   signal joyA                   : unsigned(6 downto 0) := "0000000";  -- For ZXDOS JOY
   signal joyB                   : unsigned(6 downto 0) := "0000000";  -- For ZXDOS JOY
   signal joy_renew              : std_logic := '1';                   -- For ZXDOS JOY 
   signal joy_count              : unsigned(7 downto 0) := X"00";      -- For ZXDOS JOY 
 
   -- using SDRAM
--   signal ram_addr_o             :std_logic_vector(18 downto 0) := (others => '0'); 
--   signal ram_data_io_zxdos      :std_logic_vector(7 downto 0)  := (others => 'Z');
--   signal ram1_we_n_o				: std_logic;
	
--	signal ram2_addr_o        : std_logic_vector(18 downto 0)  := (others => '0');
--   signal ram2_data_io_zxdos : std_logic_vector(7 downto 0)  := (others => 'Z');
--   signal ram2_we_n_o        : std_logic;            
	
	signal ram_ce_zxdos				:std_logic                      := '1';
   signal ram_we_n_o_zxdos       :std_logic                      := '1';
	
   signal ram_data_input_zxdos   :std_logic_vector(7 downto 0)  := (others => 'Z');
	signal ram_data_output_zxdos  :std_logic_vector(7 downto 0)  := (others => 'Z');
 
   signal ear_port_i_q           : std_logic;
   
   signal btn_divmmc_n_i_q       : std_logic;
   signal btn_multiface_n_i_q    : std_logic;
   signal btn_reset_n_i_q        : std_logic;
   
   signal keyb_col_i_0           : std_logic_vector(6 downto 0);
   signal keyb_col_i_q           : std_logic_vector(6 downto 0);
   
   signal bus_data_i_0           : std_logic_vector(7 downto 0);
   signal bus_int_n_i_0          : std_logic := '1';
   signal bus_nmi_n_i_0          : std_logic := '1';
-- signal bus_ramcs_i_0          : std_logic;
   signal bus_romcs_i_0          : std_logic;
   signal bus_wait_n_i_0         : std_logic;
   signal bus_busreq_n_i_0       : std_logic;
   signal bus_iorqula_n_i_0      : std_logic;

   signal bus_data_i_q           : std_logic_vector(7 downto 0);
   signal bus_int_n_i_q          : std_logic := '1';
   signal bus_nmi_n_i_q          : std_logic := '1';
-- signal bus_ramcs_i_q          : std_logic;
   signal bus_romcs_i_q          : std_logic;
   signal bus_wait_n_i_q         : std_logic;
   signal bus_busreq_n_i_q       : std_logic;
   signal bus_iorqula_n_i_q      : std_logic;
   
   signal esp_gpio0_i_0          : std_logic;
   signal esp_gpio2_i_0          : std_logic;
   signal esp_rx_i_0             : std_logic;

   signal esp_gpio0_i_q          : std_logic;
   signal esp_gpio2_i_q          : std_logic;
   signal esp_rx_i_q             : std_logic;

   signal accel_i_0              : std_logic_vector(27 downto 0);
   signal accel_i_q              : std_logic_vector(27 downto 0);
   
   -- resets
   
   signal video_timing_change    : std_logic;
   signal actual_video_mode      : std_logic_vector(2 downto 0)   := "000";
   signal poweron_counter        : std_logic_vector(4 downto 0)   := (others => '1');
   signal reset_poweron          : std_logic;
   
   type reset_state_t            is (S_RESET_IDLE, S_RESET_HARD_0, S_RESET_HARD_1, S_RESET_SOFT_0, S_RESET_SOFT_1);
   signal reset_state            : reset_state_t := S_RESET_HARD_0;
   signal reset_state_next       : reset_state_t;
   
   signal reset_counter_start    : std_logic;
   signal reset_counter_en       : std_logic;
   signal reset_counter          : std_logic_vector(9 downto 0);
   signal reset_counter_eb       : std_logic;
   signal reset_counter_done     : std_logic;
   
   signal reset_hard             : std_logic;
   signal reset_soft             : std_logic;
   signal reset                  : std_logic;
   
   signal bus_reset_n_q          : std_logic;
   signal bus_reset_noise_n      : std_logic;
   signal bus_reset_db_n         : std_logic;
   signal bus_reset_db_n_d       : std_logic := '1';
   signal expbus_reset           : std_logic;
   
   signal zxn_video_mode         : std_logic_vector(2 downto 0);
   signal zxn_reset_hard         : std_logic;
   signal zxn_reset_soft         : std_logic;
   signal zxn_reset_peripheral   : std_logic;
   
   -- clocks
   
   signal CLK_28                 : std_logic;
   signal CLK_28_n               : std_logic;
   signal CLK_14                 : std_logic;
   signal CLK_7                  : std_logic;
   signal CLK_HDMI               : std_logic;
   signal CLK_HDMI_n             : std_logic;
	signal CLK_56						: std_logic;
   signal clock_sdram_s          : std_logic;
	signal pll_locked					: std_logic;
	
   signal CLK_3M5_CONT           : std_logic;
   signal CLK_i0                 : std_logic;
   signal CLK_i1                 : std_logic;
   signal CLK_CPU                : std_logic;
   
   signal clk_28_div             : std_logic_vector(17 downto 0);
   
   signal CLK_28_PSG_EN          : std_logic;
   signal CLK_28_DEBOUNCE_EN     : std_logic;
   signal CLK_28_MOUSE_109KHZ    : std_logic;
   signal CLK_28_PS2_218KHZ      : std_logic;
   signal CLK_28_MEMBRANE_EN     : std_logic;
   
   signal zxn_clock_contend      : std_logic;
   signal zxn_clock_lsb          : std_logic;
   signal zxn_cpu_speed          : std_logic_vector(1 downto 0);
   
   signal clk01                  : std_logic;  -- For ZXDOS JOY
	signal rst							: std_logic;
	signal locked						: std_logic;
	
   -- sram interface
   
   signal sram_port_b_req        : std_logic;
   signal zxn_ram_b_req          : std_logic;
   signal sram_addr              : std_logic_vector(20 downto 0);
   signal sram_cs_n              : std_logic_vector(3 downto 0);
   signal sram_data_H            : std_logic;
   signal sram_rd                : std_logic;
   
   signal sram_cs_n_active       : std_logic_vector(3 downto 0)   := (others => '1');
   signal sram_oe_n_active       : std_logic                      := '0';
   signal sram_oe2_n_active       : std_logic                      := '0';
   signal sram_addr_active       : std_logic_vector(20 downto 0)  := (others => '0');
   signal sram_data_active       : std_logic_vector(7 downto 0)  := (others => '0');
   signal sram_port_a_active     : std_logic                      := '0';
   signal sram_port_b_active     : std_logic                      := '0';
   signal sram_data_H_active     : std_logic                      := '0';
   
   signal sram_data_in           : std_logic_vector(15 downto 0);
   signal sram_port_a_read       : std_logic;
   signal sram_port_b_read       : std_logic;
   signal sram_data_H_read       : std_logic;
   signal sram_data_in_byte      : std_logic_vector(7 downto 0);
   
   signal sram_port_a_dat        : std_logic_vector(7 downto 0);
   signal sram_port_b_dat        : std_logic_vector(7 downto 0);
   signal sram_port_a_do         : std_logic_vector(7 downto 0);
   signal sram_port_b_do         : std_logic_vector(7 downto 0);
   
   signal sram_we_line           : std_logic_vector(3 downto 0)   := (others => '0');
   --zxdos signal adaptation:
   
   signal ram_data_io            : std_logic_vector(15 downto 0)  := (others => 'Z');
   --signal ram_oe_n_o             : std_logic                      := '1';
   signal ram_ce_n_o             : std_logic_vector( 3 downto 0)  := (others => '1');
   signal ram_we_n_o             : std_logic                      := '1';
   signal sram_addr_active_goma2 : std_logic_vector(20 downto 0)  := (others => '0');
	
   -- audio
   
   signal audioint               : std_logic;
   signal mic_port               : std_logic;
   signal audioext_m             : std_logic;
   signal audioext_l             : std_logic;
   signal audioext_r             : std_logic;
   
   signal zxn_hdmi_audio         : std_logic;
   signal zxn_speaker_en         : std_logic;
   signal zxn_speaker_beep       : std_logic;
   signal zxn_tape_mic           : std_logic;

   signal zxn_audio_ear          : std_logic;
   signal zxn_audio_mic          : std_logic;
   
   signal zxn_audio_L_pre        : std_logic_vector(12 downto 0);
   signal zxn_audio_R_pre        : std_logic_vector(12 downto 0);
   
   signal zxn_audio_L            : std_logic_vector(11 downto 0);
   signal zxn_audio_R            : std_logic_vector(11 downto 0);

   signal zxn_audio_M_s          : std_logic_vector(13 downto 0);
   signal zxn_audio_M            : std_logic_vector(14 downto 0);

   --zxdos audio adaptation
   signal audioint_o             : std_logic       := '0';
   signal mic_port_o             : std_logic       := '0';
   
   -- video : vga
   
   signal ha_value               : integer range 0 to 2047;
   
   signal rgb_15                 : std_logic_vector(8 downto 0);
   signal rgb_31                 : std_logic_vector(8 downto 0);
   
   signal hsync_out              : std_logic;
   signal vsync_out              : std_logic;
   signal blank_out              : std_logic;
   
   signal zxn_rgb                : std_logic_vector(8 downto 0);
   signal zxn_rgb_cs_n           : std_logic;
   signal zxn_rgb_hs_n           : std_logic;
   signal zxn_rgb_vs_n           : std_logic;
   signal zxn_video_scanlines    : std_logic_vector(1 downto 0);
   signal zxn_rgb_vb_n           : std_logic;
   signal zxn_rgb_hb_n           : std_logic;
   signal zxn_machine_timing     : std_logic_vector(2 downto 0);
   signal zxn_video_scandouble_en   : std_logic;
   
   -- video : hdmi

   signal zxn_hdmi_reset         : std_logic;
   
   signal h_visible_s            : integer;
   signal hsync_start_s          : integer;
   signal hsync_end_s            : integer;
   signal hcnt_end_s             : integer;
   signal v_visible_s            : integer;
   signal vsync_start_s          : integer;
   signal vsync_end_s            : integer;
   signal vcnt_end_s             : integer;
   
   signal toHDMI_rgb             : std_logic_vector(8 downto 0);
   signal toHDMI_hsync           : std_logic;
   signal toHDMI_vsync           : std_logic;
   signal toHDMI_blank           : std_logic;
   
   signal tdms_r                 : std_logic_vector(9 downto 0);
   signal tdms_g                 : std_logic_vector(9 downto 0);
   signal tdms_b                 : std_logic_vector(9 downto 0);
   
   signal zxn_video_50_60        : std_logic;
   
   -- buttons, joystick, mouse, keyboard
   
   signal btn_reset_db_n            : std_logic;
   signal btn_reset_noise_n         : std_logic;
   signal btn_m1_multiface_db_n     : std_logic;
   signal btn_m1_multiface_noise_n  : std_logic;
   signal btn_drive_divmmc_db_n     : std_logic;
   signal btn_drive_divmmc_noise_n  : std_logic;

   signal zxn_buttons            : std_logic_vector(1 downto 0);
   
   signal rgb_hs_n_dly           : std_logic_vector(1 downto 0);
   signal CLK_28_HSYNC_EN        : std_logic;
   
   signal io_mode_pin_7          : std_logic;
   
   signal zxn_joy_left           : std_logic_vector(10 downto 0);
   signal zxn_joy_right          : std_logic_vector(10 downto 0);
   
   signal zxn_joy_io_mode_en     : std_logic_vector(1 downto 0);
   signal zxn_joy_io_mode_lr     : std_logic;
   signal zxn_joy_io_mode_pin_7  : std_logic;

   signal ps2_mouse_data_in      : std_logic;
   signal ps2_mouse_clock_in     : std_logic;
   signal m_reset                : std_logic_vector(1 downto 0);
   signal ps2_mouse_data_out     : std_logic;
   signal ps2_mouse_clock_out    : std_logic;

   signal zxn_ps2_mode           : std_logic;
   signal zxn_mouse_control      : std_logic_vector(2 downto 0);
   signal zxn_mouse_x            : std_logic_vector(7 downto 0);
   signal zxn_mouse_y            : std_logic_vector(7 downto 0);
   signal zxn_mouse_wheel        : std_logic_vector(7 downto 0);
   signal zxn_mouse_button       : std_logic_vector(2 downto 0);
   
   signal ps2_kbd_data_in        : std_logic;
   signal ps2_kbd_clock_in       : std_logic;
   signal ps2_kbd_clock_out      : std_logic;
   signal ps2_kbd_data_out       : std_logic;
   signal ps2_kbd_data_out_en    : std_logic;
   signal ps2_kbd_clock_out_en   : std_logic;
   signal ps2_kbd_col            : std_logic_vector(4 downto 0);
   signal ps2_kbd_function_keys  : std_logic_vector(12 downto 1);
   
   signal zxn_keymap_addr        : std_logic_vector(8 downto 0);
   signal zxn_keymap_dat         : std_logic_vector(8 downto 0);
   signal zxn_keymap_we          : std_logic;
   
   signal zxn_key_row            : std_logic_vector(7 downto 0);
   signal key_row_filtered       : std_logic_vector(7 downto 0);
   signal zxn_key_col            : std_logic_vector(4 downto 0);
   signal membrane_function_keys : std_logic_vector(10 downto 1);
   
   signal zxn_cancel_extended_entries  : std_logic;
   signal zxn_extended_keys      : std_logic_vector(15 downto 0);
   
   signal membrane_col           : std_logic_vector(4 downto 0);
   signal membrane_rows          : std_logic_vector(7 downto 0);
   
   --zxdos adaptation
   signal sd_cs1_n_o        : std_logic                      := '1';
   signal btn_reset_n_i     : std_logic;
	
   -- zxdos spi flash adaptation
   -- Flash disconected to avoid ZXDOS core updates from ZXNEXT
   signal flash_cs_n_o      : std_logic                      := '1';
   signal flash_sclk_o      : std_logic                      := '0';
   signal flash_mosi_o      : std_logic                      := '0';
   signal flash_miso_i      : std_logic;
   signal flash_wp_o        : std_logic                      := '0';
   signal flash_hold_o      : std_logic                      := '1';
	
   -- zxdos Joystick adaptation
   signal joyp1_i           : std_logic;
   signal joyp2_i           : std_logic;
   signal joyp3_i           : std_logic;
   signal joyp4_i           : std_logic;
   signal joyp6_i           : std_logic;
   signal joyp7_o           : std_logic                      := '1';
   signal joyp9_i           : std_logic;
   signal joysel_o          : std_logic                      := '0';

--   -- zxdos Matrix keyboard adaptation
--   signal keyb_row_o        : std_logic_vector( 7 downto 0)  := (others => 'Z');
--   signal keyb_col_i        : std_logic_vector( 6 downto 0);

   -- serial communication
   
   signal zxn_i2c_scl_n_o        : std_logic;
   signal zxn_i2c_sda_n_o        : std_logic;
   signal zxn_i2c_scl_n_i        : std_logic;
   signal zxn_i2c_sda_n_i        : std_logic;
   
   signal zxn_spi_ss_sd0_n       : std_logic;
   signal zxn_spi_ss_sd1_n       : std_logic;
   signal zxn_spi_sck            : std_logic;
   signal zxn_spi_mosi           : std_logic;
   
   signal zxn_spi_ss_flash_n     : std_logic;
   
   signal zxn_uart0_tx           : std_logic;
   signal zxn_uart0_rx           : std_logic;
   
   signal zxn_clk_wait_n         : std_logic;

   -- expansion bus
   
   signal zxn_bus_di             : std_logic_vector(7 downto 0);
   signal zxn_bus_int_n          : std_logic;
   signal zxn_bus_nmi_n          : std_logic;
   signal zxn_bus_romcs_n        : std_logic;
   signal zxn_bus_wait_n         : std_logic;
   signal zxn_bus_busreq_n       : std_logic;
   signal zxn_bus_iorqula_n      : std_logic;
   
   signal zxn_cpu_a              : std_logic_vector(15 downto 0);
   signal zxn_cpu_do             : std_logic_vector(7 downto 0);
   signal zxn_cpu_mreq_n         : std_logic;
   signal zxn_cpu_iorq_n         : std_logic;
   signal zxn_cpu_rd_n           : std_logic;
   signal zxn_cpu_wr_n           : std_logic;
   signal zxn_cpu_m1_n           : std_logic;
   signal zxn_cpu_int_n          : std_logic;
   signal zxn_cpu_busak_n        : std_logic;
   signal zxn_cpu_halt_n         : std_logic;
   signal zxn_cpu_rfsh_n         : std_logic;
   
   signal o_zxn_cpu_a            : std_logic_vector(15 downto 0) := (others => '0');
   signal o_zxn_cpu_do           : std_logic_vector(7 downto 0) := (others => '0');
   signal o_zxn_cpu_mreq_n       : std_logic := '1';
   signal o_zxn_cpu_iorq_n       : std_logic := '1';
   signal o_zxn_cpu_rd_n         : std_logic := '1';
   signal o_zxn_cpu_wr_n         : std_logic := '1';
   signal o_zxn_cpu_m1_n         : std_logic := '1';
   signal o_zxn_cpu_int_n        : std_logic := '1';
   signal o_zxn_cpu_busak_n      : std_logic := '1';
   signal o_zxn_cpu_halt_n       : std_logic := '1';
   signal o_zxn_cpu_rfsh_n       : std_logic := '1';
   
   signal zxn_bus_en             : std_logic;
   signal zxn_bus_clken          : std_logic;
   signal zxn_bus_clk            : std_logic;
   
   signal bus_clk_cpu            : std_logic;
   signal bus_clk_cpu_en_n       : std_logic;
   
 -- zxdos Bus adaptation
   signal bus_rst_n_io      : std_logic                      := 'Z';
   signal bus_clk35_o       : std_logic                      := 'Z';
   signal bus_addr_o        : std_logic_vector(15 downto 0)  := (others => 'Z');
   signal bus_data_io       : std_logic_vector( 7 downto 0)  := (others => 'Z');
   signal bus_int_n_io      : std_logic                      := 'Z';
   signal bus_nmi_n_i       : std_logic;
   signal bus_ramcs_i       : std_logic;
   signal bus_romcs_i       : std_logic;
   signal bus_wait_n_i      : std_logic;
   signal    bus_halt_n_o      : std_logic                      := 'Z';
   signal    bus_iorq_n_o      : std_logic                      := 'Z';
   signal    bus_m1_n_o        : std_logic                      := 'Z';
   signal    bus_mreq_n_o      : std_logic                      := 'Z';
   signal    bus_rd_n_o        : std_logic                      := 'Z';
   signal    bus_wr_n_o        : std_logic                      := 'Z';
   signal    bus_rfsh_n_o      : std_logic                      := 'Z';
   signal    bus_busreq_n_i    : std_logic;
   signal    bus_busack_n_o    : std_logic                      := 'Z';
   signal    bus_iorqula_n_i   : std_logic;

   -- esp gpio
   
   signal zxn_esp_gpio20_i       : std_logic_vector(2 downto 0);
   
   signal zxn_esp_gpio0_o        : std_logic;
   signal zxn_esp_gpio0_en_o     : std_logic;
   
   signal esp_gpio0_o            : std_logic := '1';
   signal esp_gpio0_en           : std_logic := '0';
   
   -- pi gpio
   
   signal zxn_pi_gpio_i          : std_logic_vector(27 downto 0);
   signal zxn_gpio_o             : std_logic_vector(27 downto 0);
   signal zxn_gpio_en            : std_logic_vector(27 downto 0);
   
   signal pi_gpio_o              : std_logic_vector(27 downto 0);
   signal pi_gpio_en             : std_logic_vector(27 downto 0) := (others => '0');
   
   -- zx next
   
   signal zxn_function_keys      : std_logic_vector(10 downto 1);
   
   signal zxn_flashboot          : std_logic;
   signal zxn_coreid             : std_logic_vector(4 downto 0);

   signal zxn_ram_a_addr         : std_logic_vector(20 downto 0);
   signal zxn_ram_a_req          : std_logic;
   signal zxn_ram_a_rd           : std_logic;
   signal zxn_ram_a_di           : std_logic_vector(7 downto 0);
   signal zxn_ram_a_do           : std_logic_vector(7 downto 0);
   
   signal zxn_ram_b_addr         : std_logic_vector(20 downto 0);
   signal zxn_ram_b_req_t        : std_logic;
   signal zxn_ram_b_di           : std_logic_vector(7 downto 0);
		  
     --zxdos HDMI
   signal    hdmi_p_o          : std_logic_vector(3 downto 0);
   signal    hdmi_n_o          : std_logic_vector(3 downto 0);

      --zxdos I2C (RTC and HDMI)
   signal    i2c_scl_io        : std_logic                      := 'Z';
   signal    i2c_sda_io        : std_logic                      := 'Z';

      --zxdos ESP
   signal    esp_gpio0_io      : std_logic                      := 'Z';
   signal    esp_gpio2_io      : std_logic                      := 'Z';
   signal    esp_rx_i          : std_logic;
   signal    esp_tx_o          : std_logic                      := '1';

      --zxdos PI GPIO
   signal    accel_io          : std_logic_vector(27 downto 0)  := (others => 'Z');

      --zxdos Vacant pins
   signal    extras_io         : std_logic := 'Z';


begin

   extras_io <= 'Z';

   ------------------------------------------------------------
   -- SYNCHRONIZE ASYNCHRONOUS INPUTS
   ------------------------------------------------------------

   -- Joystick
--   
--   process (CLK_28)
--   begin
--      if falling_edge(CLK_28) then
--         joyp1_i_0 <= joyp1_i;
--         joyp2_i_0 <= joyp2_i;
--         joyp3_i_0 <= joyp3_i;
--         joyp4_i_0 <= joyp4_i;
--         joyp6_i_0 <= joyp6_i;
--         joyp9_i_0 <= joyp9_i;
--      end if;
--   end process;
   
--   process (CLK_28)
--   begin
--      if rising_edge(CLK_28) then
--         joyp1_i_q <= joyp1_i_0;
--         joyp2_i_q <= joyp2_i_0;
--         joyp3_i_q <= joyp3_i_0;
--         joyp4_i_q <= joyp4_i_0;
--         joyp6_i_q <= joyp6_i_0;
--         joyp9_i_q <= joyp9_i_0;
--      end if;
--   end process;

   -- K7

   ear_sync : entity work.synchronize
   port map
   (
      i_CLK    => CLK_28,
      i_signal => ear_port_i,
      o_signal => ear_port_i_q
   );
   
   -- Buttons
   
   btn_div_sync : entity work.synchronize
   port map
   (
      i_CLK    => CLK_28,
      i_signal => btn_divmmc_n_i,
      o_signal => btn_divmmc_n_i_q
   );

   btn_mf_sync : entity work.synchronize
   port map
   (
      i_CLK    => CLK_28,
      i_signal => btn_multiface_n_i,
      o_signal => btn_multiface_n_i_q
   );
   
   btn_reset_sync : entity work.synchronize
   port map
   (
      i_CLK    => CLK_28,
      i_signal => btn_reset_n_i,
      o_signal => btn_reset_n_i_q
   );

   -- Matrix keyboard
   
   process (CLK_28)
   begin
      if falling_edge(CLK_28) then
         keyb_col_i_0 <= keyb_col_i;
      end if;
   end process;
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         keyb_col_i_q <= keyb_col_i_0;
      end if;
   end process;
   
   --zdos matrix keyboard
--   keyb_col_i <= "1111111";
   -- Bus

   process (CLK_28)
   begin
      if falling_edge(CLK_28) then
         bus_data_i_0      <= bus_data_io;
         bus_int_n_i_0     <= bus_int_n_io;
         bus_nmi_n_i_0     <= bus_nmi_n_i or reset;
--       bus_ramcs_i_0     <= bus_ramcs_i;
         bus_romcs_i_0     <= bus_romcs_i;
         bus_wait_n_i_0    <= bus_wait_n_i;
         bus_busreq_n_i_0  <= bus_busreq_n_i;
         bus_iorqula_n_i_0 <= bus_iorqula_n_i;
      end if;
   end process;
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         bus_data_i_q      <= bus_data_i_0;
         bus_int_n_i_q     <= bus_int_n_i_0;
         bus_nmi_n_i_q     <= bus_nmi_n_i_0 or reset;
--       bus_ramcs_i_q     <= bus_ramcs_i_0;
         bus_romcs_i_q     <= bus_romcs_i_0;
         bus_wait_n_i_q    <= bus_wait_n_i_0;
         bus_busreq_n_i_q  <= bus_busreq_n_i_0;
         bus_iorqula_n_i_q <= bus_iorqula_n_i_0;
      end if;
   end process;

      --zxdos bus
      bus_nmi_n_i <= '1';
      bus_ramcs_i <= '1';
      bus_romcs_i <= '1';
      bus_wait_n_i <= '1';
      bus_busreq_n_i <= '1';
      bus_iorqula_n_i <= '1';
   -- ESP
   
   process (CLK_28)
   begin
      if falling_edge(CLK_28) then
         esp_gpio0_i_0 <= esp_gpio0_io;
         esp_gpio2_i_0 <= esp_gpio2_io;
         esp_rx_i_0 <= esp_rx_i;
      end if;
   end process;
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         esp_gpio0_i_q <= esp_gpio0_i_0;
         esp_gpio2_i_q <= esp_gpio2_i_0;
         esp_rx_i_q <= esp_rx_i_0;
      end if;
   end process;

   --zxdos ESP
   esp_rx_i <= '1';
   -- PI GPIO

   process (CLK_28)
   begin
      if falling_edge(CLK_28) then
         accel_i_0 <= accel_io;
      end if;
   end process;
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         accel_i_q <= accel_i_0;
      end if;
   end process;

   ------------------------------------------------------------
   -- RESETS --------------------------------------------------
   ------------------------------------------------------------

   -- power on or video timing change
   
   video_timing_change <= '1' when zxn_video_mode /= actual_video_mode else '0';

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         if video_timing_change = '1' then
            actual_video_mode <= zxn_video_mode;
            poweron_counter <= (others => '1');
         elsif reset_poweron = '1' then
            poweron_counter <= poweron_counter - 1;
         end if;
      end if;
   end process;
   
   reset_poweron <= '1' when poweron_counter /= "00000" else '0';
   
   -- hard and soft reset state machine

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         reset_state <= reset_state_next;
      end if;
   end process;
   
   process (reset_poweron, zxn_reset_hard, reset_state, zxn_reset_soft, expbus_reset, reset_counter_done)
   begin
      if reset_poweron = '1' or zxn_reset_hard = '1' then
         reset_state_next <= S_RESET_HARD_0;
      else
         case reset_state is
            when S_RESET_IDLE =>
               if zxn_reset_soft = '1' or expbus_reset = '1' then
                  reset_state_next <= S_RESET_SOFT_0;
               else
                  reset_state_next <= S_RESET_IDLE;
               end if;
            when S_RESET_HARD_0 =>
               if reset_poweron = '1' then
                  reset_state_next <= S_RESET_HARD_0;
               else
                  reset_state_next <= S_RESET_HARD_1;
               end if;
            when S_RESET_HARD_1 =>
               if reset_counter_done = '1' then
                  reset_state_next <= S_RESET_IDLE;
               else
                  reset_state_next <= S_RESET_HARD_1;
               end if;
            when S_RESET_SOFT_0 =>
               reset_state_next <= S_RESET_SOFT_1;
            when S_RESET_SOFT_1 =>
               if reset_counter_done = '1' then
                  reset_state_next <= S_RESET_IDLE;
               else
                  reset_state_next <= S_RESET_SOFT_1;
               end if;
            when others =>
               reset_state_next <= S_RESET_IDLE;
         end case;
      end if;
   end process;

   reset_counter_start <= '1' when reset_state = S_RESET_HARD_0 or reset_state = S_RESET_SOFT_0 else '0';
   reset_counter_en <= '1' when bus_reset_db_n = '1' or zxn_bus_en = '0' or zxn_reset_peripheral = '1' else '0';
   
   reset_hard <= '1' when reset_state = S_RESET_HARD_0 or reset_state = S_RESET_HARD_1 else '0';
   reset_soft <= '1' when reset_state = S_RESET_SOFT_0 or reset_state = S_RESET_SOFT_1 else '0';
   
   reset <= reset_hard or reset_soft;
   
   bus_rst_n_io <= '0' when zxn_reset_peripheral = '1' or (reset_counter_eb = '1' and (reset_hard = '1' or (reset_soft = '1' and zxn_bus_en = '1'))) else 'Z';  -- makes more sense if exp bus reset and esp reset are separated
   
   -- reset counter

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         if reset_counter_start = '1' then
            reset_counter <= (others => '1');
         elsif reset_counter_eb = '1' or (reset_counter_en = '1' and reset_counter(0) = '1') then
            reset_counter <= reset_counter - 1;
         end if;
      end if;
   end process;
   
   reset_counter_eb <= '1' when reset_counter(9 downto 1) /= "000000000" else '0';
   reset_counter_done <= '1' when reset_counter_eb = '0' and reset_counter(0) = '0' else '0';
   
   -- expansion bus reset

   btn_expbus_rst : entity work.synchronize
   port map
   (
      i_CLK    => CLK_28,
      i_signal => bus_rst_n_io,
      o_signal => bus_reset_n_q
   );
   
   db_expbus_rst_noise : entity work.debounce
      generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 4      -- 16 * CLK_28 = ~571ns
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => '1',
      button_i       => bus_reset_n_q,
      button_o       => bus_reset_noise_n
   );

   db_expbus_rst : entity work.debounce
   generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 3      -- 8 * CLK_28_DEBOUNCE_EN period = ~ 74.8ms
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => CLK_28_DEBOUNCE_EN,
      button_i       => bus_reset_noise_n,
      button_o       => bus_reset_db_n
   );
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         bus_reset_db_n_d <= bus_reset_db_n;
      end if;
   end process;   
   
   expbus_reset <= '1' when bus_reset_db_n_d = '1' and bus_reset_db_n = '0' and zxn_reset_peripheral = '0' and zxn_bus_en = '1' else '0';

   --zxdos reset
   btn_reset_n_i <= '1';
   
   ------------------------------------------------------------
   -- CLOCKS --------------------------------------------------
   ------------------------------------------------------------
   
--   pll : pll_top
--   port map
--   (
--      SSTEP       => reset_poweron,      -- todo: change to single cycle assertion
--      STATE       => zxn_video_mode,     -- VGA 0-6, HDMI
--      RST         => '0',
--      CLKIN       => clock_50_i,
--      SRDY        => open,
--    
--      CLK0OUT     => CLK_28,             -- 28 MHz
--      CLK1OUT     => CLK_28_n,           -- 28 Mhz inverted
--      CLK2OUT     => CLK_14,             -- 14 MHz
--      CLK3OUT     => CLK_7,              -- 7 MHz
--      CLK4OUT     => CLK_HDMI,           -- 28 * 5
--      CLK5OUT     => CLK_HDMI_n          -- 28 * 5 inverted
--   );
   
--	clocks_ins : next_clocks
--	port map
--	(
--      CLK_IN1       => clock_50_i,
--		RESET         => '0',
--        
--      CLK_OUT1     => CLK_28,             -- 28 MHz
--      CLK_OUT2     => CLK_28_n,           -- 28 Mhz inverted
--      CLK_OUT3     => CLK_14,             -- 14 MHz
--      CLK_OUT4     => CLK_7,              -- 7 MHz
--      CLK_OUT5     => CLK_HDMI,           -- 28 * 5
--      CLK_OUT6     => CLK_HDMI_n          -- 28 * 5 inverted
--   );	

--	clocks_inst : component clocks
--	port map (
--	
--			refclk   => clock_50_i,         -- 50 Mhz
--			rst      => '0',                -- reset
--			
--			outclk_0 => CLK_28,             -- 28 MHz
--			outclk_1 => CLK_28_n,           -- 28 Mhz inverted
--			outclk_2 => CLK_14,             -- 14 MHz
--			outclk_3 => CLK_7,              -- 7 MHz
--			outclk_4 => CLK_HDMI,           -- 28 * 5
--			outclk_5 => CLK_56,             -- 28 * 4 = 112  
--			--outclk_6 => sdram_clk_o,        -- 28 * 4 = 112  -90
--			locked   => pll_locked
--			);
	clocks_inst : component clocks
	port map (
	
			inclk0   => CLOCK_50_I,         -- 50 Mhz
			areset      => '0',                -- reset
			
			c0 => CLK_28,             -- 28 MHz
			c1 => CLK_28_n,           -- 28 Mhz inverted
			c2 => CLK_14,             -- 14 MHz
			c3 => CLK_7,              -- 7 MHz
			c4 => CLK_56,             -- 56 MHz
			locked   => pll_locked
			);

	
   -- cpu clock selection

   process (CLK_7)
   begin
      if rising_edge(CLK_7) then
         if zxn_clock_lsb = '1' and zxn_clock_contend = '0' then
            CLK_3M5_CONT <= '0';
         elsif zxn_clock_lsb = '0' then
            CLK_3M5_CONT <= '1';
         end if;
      end if;
   end process;

--   BUFGMUX1_i0 : entity work.BUFGMUX1
--   port map
--   (
--      I0 => CLK_3M5_CONT,
--      I1 => CLK_7,
--      S => zxn_cpu_speed(0),
--      O => CLK_i0
--   );
--
----	CLK_i0 <= CLK_7 when zxn_cpu_speed(0) = '1' else CLK_3M5_CONT;
--
--
--   BUFGMUX1_i1 : entity work.BUFGMUX1
--   port map
--   (
--      I0 => CLK_14,
--      I1 => CLK_28,
--      S => zxn_cpu_speed(0),
--      O => CLK_i1
--   );
--   
----	CLK_i1 <= CLK_28 when zxn_cpu_speed(0) = '1' else CLK_14;
--
--	
--   BUFGMUX1_i2 : entity work.BUFGMUX1
--   port map
--   (
--      I0 => CLK_i0,
--      I1 => CLK_i1,
--      S => zxn_cpu_speed(1),
--      O => CLK_CPU
--   );
--
--	CLK_CPU <= CLK_i1 when zxn_cpu_speed(1) = '1' else CLK_i0;

   CLK_CPU <= CLK_28;

   -- zxn_clk_wait_n
   zxn_clk_wait_n <= '1';
--   process (CLK_28)
--   begin
--      if rising_edge(CLK_28) then
--         case zxn_cpu_speed(1 downto 0) is
--            when "00"   =>  zxn_clk_wait_n <= clk_28_div(3) and clk_28_div(2) and clk_28_div(1);
--            when "01"   =>  zxn_clk_wait_n <= clk_28_div(3) and clk_28_div(2);
--            when "10"   =>  zxn_clk_wait_n <= clk_28_div(3);
--            when others =>  zxn_clk_wait_n <= '1';
--         end case;
--      end if;
--   end process;
	
   -- Clock Enables
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         clk_28_div <= clk_28_div + 1;
      end if;
   end process;
   
   CLK_28_PSG_EN <= '1' when clk_28_div(3 downto 0) = "1110" else '0';                   -- AY clock enable @ 1.75MHz
   CLK_28_DEBOUNCE_EN <= '1' when clk_28_div(17 downto 0) = ("11" & X"FFFF") else '0';   -- 9.36ms period for debounce
   CLK_28_MOUSE_109KHZ <= clk_28_div(7);                                                 -- 109 kHz clock 50% duty for ps2 mouse
   CLK_28_PS2_218KHZ <= clk_28_div(6);                                                   -- 218 kHz clock 50% duty cycle for ps2 keyboard
--   CLK_28_PS2_218KHZ <= CLK_28;                                                   -- 218 kHz clock 50% duty cycle for ps2 keyboard
   CLK_28_MEMBRANE_EN <= '1' when clk_28_div(8 downto 0) = ('1' & X"FF") else '0';       -- complete scan every 2.5 scanlines (0.018ms per row)
   
   ------------------------------------------------------------
   -- FPGA MULTI-CORE CONFIGURATION ---------------------------
   ------------------------------------------------------------
   
   -- cores separated by 512k in flash
   
--   fpga_config : entity work.flashboot
--   port map
--   (
--      reset_i     => reset_poweron,
--      clock_i     => CLK_14,
--      start_i     => zxn_flashboot,
----      spiaddr_i   => "0110" & "1011" & zxn_coreid & "0000000000000000000"
--      spiaddr_i   => X"030BC000" -- 8'h03 & 24'h0BC000 default value lx16 zxdos
--   );

   ------------------------------------------------------------
   -- SRAM INTERFACE ------------------------------------------
   ------------------------------------------------------------
   
   -- https://www.alliancememory.com/wp-content/uploads/pdf/sram/fa/as7c34096a_v2.1.pdf
   -- https://www.idt.com/document/dst/71v424-data-sheet
   
   -- SRAM cycles are executed within every 28MHz cycle and are
   -- granted to one of three simultaneous requesters, with the
   -- cpu granted highest priority and layer 2 granted second
   -- priority.

   -- To ensure that a 28MHz cpu speed would be possible, the 
   -- initial design allocates the entire 28MHz period to the 
   -- sram memory cycle with the result of reads stored at the 
   -- end of the period on the next rising edge.  This has
   -- the consequence that cpu instruction fetches and DMA
   -- 2-cycle reads must have one wait state inserted at 28MHz 
   -- speed.

   -- For memory write timing, the 5 x 28MHz hdmi clock is used
   -- to time the write pulse to ensure the write address is
   -- stable before the write pulse is asserted and to ensure
   -- the write cycle is completed before the end of the 28MHz period.
   
   -- Hard and soft resets span many 28MHz cycles so the currently
   -- running sram cycle is allowed to complete before the sram
   -- is held in a neutral state during the reset.  This ensures
   -- spurious writes don't contaminate the sram during soft reset.
   
   -- In the notation below, port A is r/w and is the highest
   -- priority assigned to the cpu.  Port B is read-only and
   -- is second priority assigned to layer 2.  Layer 2 requests
   -- can be delayed by one cycle so they are fine soaking up
   -- spare sram bandwidth at second priority.

   -- PORT A (R/W) (cpu/dma):
   --
   -- zxn_ram_a_addr   : std_logic_vector(20 downto 0)
   -- zxn_ram_a_req    : '1' on rising edge indicates memory request
   -- zxn_ram_a_rd     : '1' for read, '0' for write
   -- zxn_ram_a_do     : std_logic_vector(7 downto 0) data to write to memory
   -- zxn_ram_a_di     : std_logic_vector(7 downto 0) data read from memory
   
   -- PORT B (R) (layer 2):
   --
   -- zxn_ram_b_addr   : std_logic_vector(20 downto 0)
   -- zxn_ram_b_req_t  : toggles to indicate new request
   -- zxn_ram_b_di     : std_logic_vector(7 downto 0) data read from memory
   
   -- PORT C (R/W) (dma, soaks up spare bandwidth)
   
   -- SRAM I/O PINS:
   --
   -- ram_addr_o       : std_logic_vector(18 downto 0)
   -- ram_data_io      : std_logic_vector(15 downto 0)
   -- ram_oe_n_o
   -- ram_we_n_o
   -- ram_ce_n_o       : std_logic_vector(3 downto 0)
   
   -- Determine active port and sram signals for next memory cycle
	
	
	-- RAM
--	ram: entity work.ssdram256Mb
--	generic map (
--		freq_g		=> 112
--	)
--	port map (
--		clock_i		=> CLK_56,
--		reset_i		=> rst,
--		refresh_i	=> '1',
--		-- Static RAM bus
--		addr_i		=> "0000" & sram_addr,
--		data_i		=> ram_data_io_zxdos, --ram_data_input_zxdos,
--		data_o		=> ram_data_output_zxdos,
--		cs_i			=> '1', -- not sram_cs_n_active(0), --ram_ce_zxdos,
--		oe_i			=> not sram_oe_n_active, --not ram_oe_n_o,
--		we_i			=> not ram1_we_n_o, --not ram_we_n_o_zxdos,
--		-- SD-RAM ports
--		mem_cke_o	=> sdram_cke_o,
--		mem_cs_n_o	=> sdram_cs_o,
--		mem_ras_n_o	=> sdram_ras_o,
--		mem_cas_n_o	=> sdram_cas_o,
--		mem_we_n_o	=> sdram_we_o,
--		mem_udq_o	=> sdram_dqm_o(1),
--		mem_ldq_o	=> sdram_dqm_o(0),
--		mem_ba_o		=> sdram_ba_o,
--		mem_addr_o	=> sdram_ad_o,
--		mem_data_io	=> sdram_da_io
--	);

--	sdram_clk_o <= CLK_56; 
--
--	ram: sdram
--	port map (
--	
--	sd_data   =>  sdram_da_io,
--	sd_addr   =>  sdram_ad_o,
--	sd_dqm    =>  sdram_dqm_o,
--	sd_cs     =>  sdram_cs_o,
--	sd_ba     =>  sdram_ba_o,
--	sd_we     =>  sdram_we_o,
--	sd_ras    =>  sdram_ras_o,
--	sd_cas    =>  sdram_cas_o,
--
--	-- system interface
--	clk       =>  CLK_56,
--	clkref    =>  CLK_28,
--	init      =>  not pll_locked,
--
--	--cpu/chipset interface
--	addrA    =>  "0000" & zxn_ram_a_addr,  -- 25 bit byte address 
--	weA      =>  not zxn_ram_a_rd,  -- cpu/chipset requests write
--	dinA     =>  zxn_ram_a_do,  -- data input from chipset/cpu
--	oeA      =>  sram_port_a_active,  -- cpu requests data
--	doutA    =>  zxn_ram_a_di,  -- data output to cpu 
--
--	
--	
--	addrB    =>  "0000" & zxn_ram_b_addr,  -- 25 bit byte address
--	weB      =>  '0',     -- cpu/chipset requests write
--	dinB     =>  "00000000",  -- data input from chipset/cpu
--	oeB      =>  sram_port_b_active,  -- cpu requests data
--	doutB    =>  zxn_ram_b_di   -- data output to cpu 
--	
--	
--	);

   RAM_CLK <= CLK_56;

   -- Track port B request which operates on a toggled signal
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         if zxn_ram_b_req = '1' then
            sram_port_b_req <= zxn_ram_b_req_t;
         end if;
      end if;
   end process;
   zxn_ram_b_req <= (zxn_ram_b_req_t xor sram_port_b_req) and not zxn_ram_a_req;   -- 0 = Port A (or nothing), 1 = Port B

   sram_addr <= zxn_ram_a_addr when zxn_ram_b_req = '0' else zxn_ram_b_addr;  
   --sram_addr <= (zxn_ram_a_addr(20) & zxn_ram_a_addr(0) & zxn_ram_a_addr(19 downto 1)) when zxn_ram_b_req = '0' else (zxn_ram_b_addr(20) & zxn_ram_b_addr(0) & zxn_ram_b_addr(19 downto 1));
   RAM_ADDR_O <= sram_addr(18 downto 0);
   sram_rd <= (zxn_ram_a_rd or not zxn_ram_a_req) when zxn_ram_b_req = '0' else '1';
   RAM_WE_ALL_N_O <= '1' when reset = '1' else sram_rd;

   -- Select active sram chip
   process (zxn_ram_a_req, zxn_ram_b_req, sram_addr)
   begin
      if zxn_ram_a_req = '1' or zxn_ram_b_req = '1' then
         case sram_addr(20 downto 19) is
            when "00"   =>  sram_cs_n <= "1110";
            when "01"   =>  sram_cs_n <= "1101";
            when "10"   =>  sram_cs_n <= "1011";
            when others =>  sram_cs_n <= "0111";
         end case;
      else
         sram_cs_n <= (others => '1');
      end if;
   end process;

   process (CLK_56)
   begin
      if falling_edge(CLK_56) then
         sram_oe2_n_active <= sram_oe_n_active;
      end if;
   end process;

   RAM_OE_N_O <= (not sram_rd) and sram_oe_n_active and sram_oe2_n_active;
   RAM_WE_BYTE_N_O <= sram_cs_n;
   RAMA_DATA_IO_ZXDOS <= sram_data_active(7 downto 0) when sram_oe_n_active = '1' else (others => 'Z');
   RAMB_DATA_IO_ZXDOS <= sram_data_active(7 downto 0) when sram_oe_n_active = '1' else (others => 'Z');
   RAMC_DATA_IO_ZXDOS <= sram_data_active(7 downto 0) when sram_oe_n_active = '1' else (others => 'Z');
   RAMD_DATA_IO_ZXDOS <= sram_data_active(7 downto 0) when sram_oe_n_active = '1' else (others => 'Z');

   zxn_ram_a_di <= sram_port_a_do;
   zxn_ram_b_di <= sram_port_b_do;
   -- Select active data to zx
   --process (sram_port_a_active, sram_addr_active)
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         if ((sram_port_a_active = '1') and (sram_oe_n_active = '0')) then
            case sram_addr_active(20 downto 19) is
               when "00"   =>  sram_port_a_do <= RAMA_DATA_IO_ZXDOS;-- sram_cs_n <= "1110";
               when "01"   =>  sram_port_a_do <= RAMB_DATA_IO_ZXDOS;-- sram_cs_n <= "1101";
               when "10"   =>  sram_port_a_do <= RAMC_DATA_IO_ZXDOS;-- sram_cs_n <= "1011";
               when others =>  sram_port_a_do <= RAMD_DATA_IO_ZXDOS;-- sram_cs_n <= "0111";
            end case;
--         else
--            sram_port_a_do <= (others => '1');-- sram_cs_n <= (others => '1');
         end if;
      end if;
   end process;
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         --if (sram_port_b_active = '1' and not sram_oe_n_active) then
         if ((sram_port_b_active and not sram_oe_n_active) = '1') then
            case sram_addr_active(20 downto 19) is
               when "00"   =>  sram_port_b_do <= RAMA_DATA_IO_ZXDOS;-- sram_cs_n <= "1110";
               when "01"   =>  sram_port_b_do <= RAMB_DATA_IO_ZXDOS;-- sram_cs_n <= "1101";
               when "10"   =>  sram_port_b_do <= RAMC_DATA_IO_ZXDOS;-- sram_cs_n <= "1011";
               when others =>  sram_port_b_do <= RAMD_DATA_IO_ZXDOS;-- sram_cs_n <= "0111";
            end case;
--         else
--            sram_port_b_do <= (others => '1');-- sram_cs_n <= (others => '1');
         end if;
      end if;
   end process;




   sram_data_H <= sram_addr(19);
   
   -- Memory cycle
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         if reset = '1' then
            sram_cs_n_active <= (others => '1');
            sram_oe_n_active <= '1';
            sram_addr_active <= (others => '0');
            sram_data_active <= (others => '0');
--				sram_addr_active_goma2 <= (others => '0'); --gomados
            sram_port_a_active <= '0';
            sram_port_b_active <= '0';
            sram_data_H_active <= '0';
         else
            sram_cs_n_active <= sram_cs_n;
            sram_oe_n_active <= not sram_rd;
            sram_addr_active <= sram_addr;
            sram_data_active <= zxn_ram_a_do;
--				sram_addr_active_goma2 <= sram_addr; --gomados
            sram_port_a_active <= zxn_ram_a_req;
            sram_port_b_active <= zxn_ram_b_req;
            sram_data_H_active <= sram_data_H;
         end if;
      end if;
   end process;
   
   -- Data in (R)
   
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         sram_data_in <= ram_data_io;
      end if;
   end process;
   
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         sram_port_a_read <= sram_port_a_active and not sram_oe_n_active;
         sram_port_b_read <= sram_port_b_active and not sram_oe_n_active;
         sram_data_H_read <= sram_data_H_active;
      end if;
   end process;
   
   sram_data_in_byte <= sram_data_in(7 downto 0) when sram_data_H_read = '0' else sram_data_in(15 downto 8);

   
   --
   
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         if sram_port_a_read = '1' then
            sram_port_a_dat <= sram_data_in_byte;
         end if;
      end if;
   end process;
   
   process (CLK_56)
   begin
      if rising_edge(CLK_56) then
         if sram_port_b_read = '1' then
            sram_port_b_dat <= sram_data_in_byte;
         end if;
      end if;
   end process;
   
   -- Data out (W)
   -- 28MHz cycle is partitioned into five periods some of which will carry we signal
   
--   process (CLK_HDMI)
--   begin
--      if rising_edge(CLK_HDMI) then
--         if sram_oe_n_active = '1' and sram_we_line = "0000" then
--            sram_we_line <= "1111";
--            ram_we_n_o <= '0';
--         else
--            sram_we_line <= sram_we_line(2 downto 0) & '0';
--            if sram_we_line(3 downto 1) = "111" then
--               ram_we_n_o <= '0';
--            else
--               ram_we_n_o <= '1';
--            end if;
--         end if;
--      end if;
--   end process;
   
   -- zxdos write enable 2 x 512k SRAM
   --ram1_we_n_o <= '0' when ram_ce_n_o = "1110" else '1';
   --ram2_we_n_o <= '0' when ram_ce_n_o = "1101" else '1';
   --ram1_we_n_o <= ram_ce_n_o(0) or ram_we_n_o;
   --ram2_we_n_o <= ram_ce_n_o(1) or ram_we_n_o;
   RAM1_WE_N_O <= sram_cs_n(0);
   RAM2_WE_N_O <= sram_cs_n(1);
	

   -- Connect I/O signals
   
   -- make sure xst is pushing registers into io blocks
   
--   ram_data_io <= sram_data_active when sram_oe_n_active = '1' else (others => 'Z');
   --ram_oe_n_o <= sram_oe_n_active;
   --ram_ce_n_o <= sram_cs_n_active;
   
--	ram_ce_zxdos <= '0' when  sram_cs_n_active = "1111"  else '1';

	-----------------------------------------------------------  eliminado al poner memoria SDRAM-------------------
	-----------------------------------------------------------------------

   -- zxdos memory

--	ram_addr_o <= sram_addr_active_goma2; --test memoria v4 -OK

		
   --ram2_addr_o <= sram_addr_active;
	
--	ram_data_io(7 downto 0)  <= ram_data_output_zxdos when ram_ce_n_o = "1110" else (others => 'Z');
--   ram_data_io(15 downto 8) <= ram_data_output_zxdos when ram_ce_n_o = "1101" else (others => 'Z');
	
--	ram_data_io <= ram_data_output_zxdos & ram_data_output_zxdos;
--   ram_data_input_zxdos  <= sram_data_active(7 downto 0) when sram_oe_n_active = '1' else (others => 'Z');
-- ram_we_n_o_zxdos <= ram_we_n_o; 
 	
	
	
   ------------------------------------------------------------
   -- AUDIO ---------------------------------------------------
   ------------------------------------------------------------

   -- tape save
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         mic_port <= zxn_tape_mic;
      end if;
   end process;
   
   mic_port_o <= mic_port;
   
   -- audio dac

   audio_L : entity work.dac
   generic map
   (
      msbi_g   => 11
   )
   port map
   (
      clk_i    => CLK_28,
      res_i    => reset,
      dac_i    => zxn_audio_L(11 downto 0),
      dac_o    => audioext_l
   );
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         audioext_l_o <= audioext_l;
      end if;
   end process;
   
   audio_R : entity work.dac
   generic map
   (
      msbi_g   => 11
   )
   port map
   (
      clk_i    => CLK_28,
      res_i    => reset,
      dac_i    => zxn_audio_R(11 downto 0),
      dac_o    => audioext_r
   );
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         audioext_r_o <= audioext_r;
      end if;
   end process;

   -- optional internal speaker

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         audioint <= audioext_m and zxn_speaker_en;
      end if;
   end process;
   
   audioint_o <= audioint;

   -- VBE(on) = 0.55 V
   -- VBE(max) = 0.8 V
   -- 17-bit dac = 21760 offset, signal range = 0:9929
   
   zxn_audio_M_s <= ('0' & zxn_audio_L_pre) + ('0' & zxn_audio_R_pre);
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         if zxn_speaker_beep = '1' then
            zxn_audio_M <= zxn_audio_ear & (not zxn_audio_ear) & '0' & zxn_audio_mic & "00000000000";
         else
            zxn_audio_M <= (('0' & zxn_audio_M_s(13 downto 7)) + "01010101") & zxn_audio_M_s(6 downto 0);
         end if;
      end if;
   end process;
   
   audio_M : entity work.dac
   generic map
   (
      msbi_g   => 16     -- only using a small range of 16.7% through 24.2%
   )
   port map
   (
      clk_i    => CLK_28,
      res_i    => reset,
      dac_i    => '0' & zxn_audio_M & '0',
      dac_o    => audioext_m
   );

   ------------------------------------------------------------
   -- VIDEO : VGA ---------------------------------------------
   ------------------------------------------------------------

   -- note: the values below are relative to the CLK period not standard VGA clock period
   
   sc_mod : entity work.scan_convert
   generic map
   (
      -- mark active area of input video
      
      cstart      =>  38*2,  -- composite sync start
      clength     => 352*2,  -- composite sync length
      
      -- output video timing
      
      hB          =>  32*2,   -- h sync
      hC          =>  40*2,   -- h back porch
      hD          => 352*2,   -- visible video (256 + both borders)
      hpad        =>   0*2,   -- create H black border

      vB          =>   2*2,   -- v sync
      vC          =>   5*2,   -- v back porch
      vD          => 284*2,   -- visible video
      vpad        =>   0*2    -- create V black border
   )
   port map
   (
      CLK         => CLK_14,
      CLK_x2      => CLK_28,

      hA          => ha_value,   -- h front porch
      I_VIDEO     => zxn_rgb,
      I_HSYNC     => zxn_rgb_hs_n,
      I_VSYNC     => zxn_rgb_vs_n,
      I_SCANLIN   => zxn_video_scanlines,
      I_BLANK_N   => zxn_rgb_cs_n,

      O_VIDEO_15  => rgb_15,     -- scanlines processed
      O_VIDEO_31  => rgb_31,     -- scanlines processed
      O_HSYNC     => hsync_out,
      O_VSYNC     => vsync_out,
      O_BLANK     => blank_out      
   );
   
   ha_value <= 48 when zxn_machine_timing(1) = '0' else 64;   -- 48k = 000 or 001, Pentagon = 100
   
   process (CLK_28)
   begin
      if falling_edge(CLK_28) then
      
         if zxn_video_scandouble_en = '0' then
         
            rgb_r_o <= rgb_15(8 downto 6);
            rgb_g_o <= rgb_15(5 downto 3);
            rgb_b_o <= rgb_15(2 downto 0);
            
            -- csync on hsync when the scandoubler is off
            
            hsync_o <= zxn_rgb_cs_n;
            vsync_o <= '1';
            
         else
         
            rgb_r_o <= rgb_31(8 downto 6);
            rgb_g_o <= rgb_31(5 downto 3);
            rgb_b_o <= rgb_31(2 downto 0);
            
            hsync_o <= hsync_out;
            vsync_o <= vsync_out;
         
         end if;
      end if;
   end process;

   -- csync_o is routed to the expansion bus and signals must be disabled there by default

   csync_o <= 'Z';

   ------------------------------------------------------------
   -- VIDEO : HDMI --------------------------------------------
   ------------------------------------------------------------
   
   -- Modeline "720x576 @ 50hz"  27    720   732   796   864   576   581   586   625 
   -- ModeLine "720x480 @ 60hz"  27    720   736   798   858   480   489   495   525 
   
--   process (zxn_video_50_60)
--   begin
--      if zxn_video_50_60 = '0' then
--      
--         -- 50 Hz
--         
--         h_visible_s    <= 720 - 1;
--         hsync_start_s  <= 732 - 1;
--         hsync_end_s    <= 796 - 1;
--         hcnt_end_s     <= 864 - 1;
--
--         v_visible_s    <= 576 - 1;
--         vsync_start_s  <= 581 - 1;
--         vsync_end_s    <= 586 - 1;
--         vcnt_end_s     <= 625 - 2;
--      
--      else
--      
--         -- 60 Hz
--      
--         h_visible_s    <= 720 - 1;
--         hsync_start_s  <= 736 - 1;
--         hsync_end_s    <= 798 - 1;
--         hcnt_end_s     <= 858 - 1;
--         --
--         v_visible_s    <= 480 - 1;
--         vsync_start_s  <= 489 - 1;
--         vsync_end_s    <= 495 - 1;
--         vcnt_end_s     <= 525 - 2;
--      
--      end if;
--   end process;
   
   -- HDMI
   
--   hdmi_frame: entity work.hdmi_frame 
--   port map (
--   
--      clock_i     => CLK_14,
--      clock2x_i   => CLK_28,
--      reset_i     => zxn_hdmi_reset,
--      scanlines_i => zxn_video_scanlines,
--      rgb_i       => zxn_rgb,
--      hsync_i     => zxn_rgb_hs_n,
--      vsync_i     => zxn_rgb_vs_n,
--      hblank_n_i  => zxn_rgb_hb_n,
--      vblank_n_i  => zxn_rgb_vb_n,
--      timing_i    => zxn_video_mode,
--      
--      --outputs
--      rgb_o       => toHDMI_rgb,
--      hsync_o     => toHDMI_hsync,
--      vsync_o     => toHDMI_vsync,
--      blank_o     => toHDMI_blank,
--      
--      -- config values 
--      h_visible   => h_visible_s,
--      hsync_start => hsync_start_s,
--      hsync_end   => hsync_end_s,
--      hcnt_end    => hcnt_end_s,
--      --
--      v_visible   => v_visible_s,
--      vsync_start => vsync_start_s,
--      vsync_end   => vsync_end_s,
--      vcnt_end    => vcnt_end_s
--   );
    
--   hdmi: entity work.hdmi
--   generic map
--   (
--      FREQ           => 27000000,   -- pixel clock frequency
--      FS             => 48000,      -- audio sample rate - should be 32000, 41000 or 48000 = 48KHz
--      CTS            => 27000,      -- CTS = Freq(pixclk) * N / (128 * Fs)
--      N              => 6144        -- N = 128 * Fs /1000,  128 * Fs /1500 <= N <= 128 * Fs /300 (Check HDMI spec 7.2 for details)
--   )
--   port map
--   (
--      I_CLK_PIXEL    => CLK_28,
--      I_R            => toHDMI_rgb(8 downto 6) & toHDMI_rgb(8 downto 6) & toHDMI_rgb(8 downto 7),
--      I_G            => toHDMI_rgb(5 downto 3) & toHDMI_rgb(5 downto 3) & toHDMI_rgb(5 downto 4),
--      I_B            => toHDMI_rgb(2 downto 0) & toHDMI_rgb(2 downto 0) & toHDMI_rgb(2 downto 1),
--      I_BLANK        => toHDMI_blank,
--      I_HSYNC        => toHDMI_hsync,
--      I_VSYNC        => toHDMI_vsync,
--      
--      -- PCM audio
--      
--      I_AUDIO_ENABLE => zxn_hdmi_audio,
--      I_AUDIO_PCM_L  => (not zxn_audio_L_pre(12)) & zxn_audio_L_pre(11 downto 0) & "000",
--      I_AUDIO_PCM_R  => (not zxn_audio_R_pre(12)) & zxn_audio_R_pre(11 downto 0) & "000",
--      
--      -- TMDS parallel pixel synchronous outputs (serialize LSB first)
--      
--      O_RED          => tdms_r,
--      O_GREEN        => tdms_g,
--      O_BLUE         => tdms_b
--   );

--   hdmio: entity work.hdmi_out_xilinx
--   port map (
--      clock_pixel_i     => CLK_28,
--      clock_tdms_i      => CLK_HDMI,
--      clock_tdms_n_i    => CLK_HDMI_n,
--      red_i             => tdms_r,
--      green_i           => tdms_g,
--      blue_i            => tdms_b,
--      tmds_out_p        => hdmi_p_o,
--      tmds_out_n        => hdmi_n_o
--   );

   ------------------------------------------------------------
   -- BUTTONS, JOYSTICKS, MOUSE, KEYBOARD ---------------------
   ------------------------------------------------------------

   -- reset button
   
   db_0_noise : entity work.debounce
      generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 4      -- 16 * CLK_28 = ~571ns
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => '1',
      button_i       => btn_reset_n_i_q,
      button_o       => btn_reset_noise_n
   );
   
   db_0_bounce : entity work.debounce
   generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 3      -- 8 * CLK_28_DEBOUNCE_EN period = ~ 74.8ms
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => CLK_28_DEBOUNCE_EN,
      button_i       => btn_reset_noise_n,
      button_o       => btn_reset_db_n
   );

   -- multiface nmi button (nmi)
   
   db_1_noise : entity work.debounce
      generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 4      -- 16 * CLK_28 = ~571ns
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => '1',
      button_i       => btn_multiface_n_i_q,
      button_o       => btn_m1_multiface_noise_n
   ); 

   db_1_bounce : entity work.debounce
   generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 3      -- 8 * CLK_28_DEBOUNCE_EN period = ~ 74.8ms
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => CLK_28_DEBOUNCE_EN,
      button_i       => btn_m1_multiface_noise_n,
      button_o       => btn_m1_multiface_db_n
   );
   
   -- divmmc nmi button (drive)

   db_2_noise : entity work.debounce
      generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 4      -- 16 * CLK_28 = ~571ns
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => '1',
      button_i       => btn_divmmc_n_i_q,
      button_o       => btn_drive_divmmc_noise_n
   );

   db_2_bounce : entity work.debounce
   generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 3      -- 8 * CLK_28_DEBOUNCE_EN period = ~ 74.8ms
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => CLK_28_DEBOUNCE_EN,
      button_i       => btn_drive_divmmc_noise_n,
      button_o       => btn_drive_divmmc_db_n
   );
   
   zxn_buttons <= not (btn_drive_divmmc_db_n & btn_m1_multiface_db_n);
   
   -- joysticks
   -- md controller reads all joystick types
   
--   process (CLK_28)
--   begin
--      if rising_edge(CLK_28) then
--         rgb_hs_n_dly <= rgb_hs_n_dly(0) & zxn_rgb_hs_n;
--      end if;
--   end process;
--   
--   CLK_28_HSYNC_EN <= rgb_hs_n_dly(1) and not rgb_hs_n_dly(0);
--   
--   jc_2 : entity work.md6_joystick_connector_x2
--   port map
--   (
--      i_reset        => reset,
--      
--      i_CLK_28       => CLK_28,
--      i_CLK_EN       => CLK_28_HSYNC_EN,  -- approximately 15kHz enable
--      
--      i_joy_1_n      => joyp1_i_q,
--      i_joy_2_n      => joyp2_i_q,
--      i_joy_3_n      => joyp3_i_q,
--      i_joy_4_n      => joyp4_i_q,
--      i_joy_6_n      => joyp6_i_q,
--      i_joy_9_n      => joyp9_i_q,
--      
--      i_io_mode_en      => zxn_joy_io_mode_en(0),
--      i_io_mode_lr      => zxn_joy_io_mode_lr,
--      i_io_mode_pin_7   => io_mode_pin_7,
--
--      o_joy_7        => joyp7_o,          -- md protocol
--      o_joy_select   => joysel_o,         -- joystick selection mux (0 = left, 1 = right)
--
--      o_joy_left     => zxn_joy_left,     -- active high  X Z Y START A C B U D L R
--      o_joy_right    => zxn_joy_right     -- active high  X Z Y START A C B U D L R
--   );
   
--   io_mode_pin_7 <= zxn_joy_io_mode_pin_7 when zxn_joy_io_mode_en(1) = '0' else clk_28_div(2) when zxn_joy_io_mode_pin_7 = '1' else clk_28_div(10);
   
   -- ps2 mouse
   
   -- todo: add sensitivity adjustment for old ps2 mice
   -- todo: look at driving a 1 when mouse outputs a 1
   
   ps2_mouse_data_in <= ps2_pin2_io when zxn_ps2_mode = '0' else ps2_data_io;
   ps2_mouse_clock_in <= ps2_pin6_io when zxn_ps2_mode = '0' else ps2_clk_io;

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         if reset = '1' then
            m_reset <= "01";
         else
            case m_reset is
               when "01"   =>
                  if CLK_28_MOUSE_109KHZ = '0' then
                     m_reset <= "10";
                  end if;
               when "10"   =>
                  if CLK_28_MOUSE_109KHZ = '1' then
                     m_reset <= "00";
                  end if;
               when others =>
                  m_reset <= "00";
            end case;
         end if;
      end if;
   end process;
   
   ps2_mouse_mod : ps2_mouse
   port map
   (
      reset       => m_reset(1) or m_reset(0),   -- removed F12 reset (only available from ps2 kbd)
      clk         => CLK_28_MOUSE_109KHZ,
      
      ps2mdat_i   => ps2_mouse_data_in,
      ps2mclk_i   => ps2_mouse_clock_in,
      
      ps2mdat_o   => ps2_mouse_data_out,
      ps2mclk_o   => ps2_mouse_clock_out,
      
      control_i   => zxn_mouse_control,
      
      xcount      => zxn_mouse_x,
      ycount      => zxn_mouse_y,
      zcount      => zxn_mouse_wheel,
      
      mleft       => zxn_mouse_button(0),
      mright      => zxn_mouse_button(1),
      mthird      => zxn_mouse_button(2)
   );
   
   ps2_data_io <= ps2_kbd_data_out when (ps2_kbd_data_out_en = '1' and zxn_ps2_mode = '0') else '0' when (ps2_mouse_data_out = '0' and zxn_ps2_mode = '1') else 'Z';
   ps2_clk_io <= ps2_kbd_clock_out when (ps2_kbd_clock_out_en = '1' and zxn_ps2_mode = '0') else '0' when (ps2_mouse_clock_out = '0' and zxn_ps2_mode = '1') else 'Z';
   
   ps2_pin2_io <= '0' when (ps2_mouse_data_out = '0' and zxn_ps2_mode = '0') else ps2_kbd_data_out when (ps2_kbd_data_out_en = '1' and zxn_ps2_mode = '1') else 'Z';
   ps2_pin6_io <= '0' when (ps2_mouse_clock_out = '0' and zxn_ps2_mode = '0') else ps2_kbd_clock_out when (ps2_kbd_clock_out_en = '1' and zxn_ps2_mode = '1') else 'Z';
   
   -- ps2 keyboard
   
   ps2_kbd_data_in <= ps2_data_io when zxn_ps2_mode = '0' else ps2_pin2_io;
   ps2_kbd_clock_in <= ps2_clk_io when zxn_ps2_mode = '0' else ps2_pin6_io;
   
   ps2_kbd_mod : entity work.ps2_keyb
   generic map
   (
      CLK_KHZ        => 218
   )
   port map
   (
      enable_i       => '1',
      clock_i        => CLK_28,
      clock_180o_i   => CLK_28_n,
      clock_ps2_i    => CLK_28_PS2_218KHZ,      -- ps2 module cannot handle 28MHz clock
      reset_i        => reset_poweron,
      --
      ps2_clk_i      => ps2_kbd_clock_in,
      ps2_data_i     => ps2_kbd_data_in,
      ps2_clk_o      => ps2_kbd_clock_out,
      ps2_data_o     => ps2_kbd_data_out,
      ps2_data_out   => ps2_kbd_data_out_en,    -- actively driving highs to keep transitions sharp
      ps2_clk_out    => ps2_kbd_clock_out_en,   -- actively driving highs to keep transitions sharp
      --
      rows_i         => key_row_filtered,
      cols_o         => ps2_kbd_col,
      functionkeys_o => ps2_kbd_function_keys,  -- F12:F1
      core_reload_o  => open,
      keymap_addr_i  => zxn_keymap_addr,
      keymap_data_i  => zxn_keymap_dat,
      keymap_we_i    => zxn_keymap_we
   );

   -- function keys via membrane keyboard
   
   -- mf button held turns keys 0-9 into function keys
   -- mf button held for < ~1000ms indicates multiface nmi

   emu_fnkeys_mod : entity work.emu_fnkeys
   generic map
   (
      CLOCK_EN_PERIOD_MS   => 10,   -- debounce period is 9.6ms
      BUTTON_PERIOD_MS     => 1000  -- button held for less than 1s constitutes a short press
   )
   port map
   (
      i_CLK             => CLK_28,
      i_CLK_EN          => CLK_28_DEBOUNCE_EN,
      
      i_reset           => reset_poweron,
      
      i_rows            => zxn_key_row,
      o_rows_filtered   => key_row_filtered,
      
      i_cols            => ps2_kbd_col and membrane_col,
      o_cols_filtered   => zxn_key_col,
      
      i_button_m1_n     => btn_m1_multiface_db_n,   -- F9 = multiface nmi
      i_button_reset_n  => btn_reset_db_n,          -- F1 = hard reset, F4 = soft reset
      
      o_fnkeys          => membrane_function_keys   -- F10:F1 out
   );
      
   -- membrane keyboard
   
   membrane_mod : entity work.membrane
   port map
   (
      i_CLK             => CLK_28,
      i_CLK_EN          => CLK_28_MEMBRANE_EN,
      
      i_reset           => reset_poweron,
      
      i_rows            => key_row_filtered,
      o_cols            => membrane_col,
      
      o_membrane_rows   => membrane_rows,   -- 0 = active, 1 = Z
      i_membrane_cols   => keyb_col_i_q,
      
      i_cancel_extended_entries => zxn_cancel_extended_entries,
      o_extended_keys => zxn_extended_keys
   );
   
   keyb_row_o(0) <= '0' when membrane_rows(0) = '0' else 'Z';
   keyb_row_o(1) <= '0' when membrane_rows(1) = '0' else 'Z';
   keyb_row_o(2) <= '0' when membrane_rows(2) = '0' else 'Z';
   keyb_row_o(3) <= '0' when membrane_rows(3) = '0' else 'Z';
   keyb_row_o(4) <= '0' when membrane_rows(4) = '0' else 'Z';
   keyb_row_o(5) <= '0' when membrane_rows(5) = '0' else 'Z';
   keyb_row_o(6) <= '0' when membrane_rows(6) = '0' else 'Z';
   keyb_row_o(7) <= '0' when membrane_rows(7) = '0' else 'Z';

   ------------------------------------------------------------
   -- SERIAL COMMUNICATION ------------------------------------
   ------------------------------------------------------------

   -- i2c
   
   i2c_scl_io <= '0' when zxn_i2c_scl_n_o = '0' else 'Z';
   i2c_sda_io <= '0' when zxn_i2c_sda_n_o = '0' else 'Z';

   zxn_i2c_scl_n_i <= i2c_scl_io;
   zxn_i2c_sda_n_i <= i2c_sda_io;

   -- spi sd card
   
   sd_cs0_n_o <= zxn_spi_ss_sd0_n;
   sd_cs1_n_o <= zxn_spi_ss_sd1_n;

   sd_sclk_o  <= zxn_spi_sck;
   sd_mosi_o  <= zxn_spi_mosi;

   -- spi flash
   
   flash_cs_n_o <= zxn_spi_ss_flash_n;

   flash_sclk_o <= zxn_spi_sck;
   flash_mosi_o <= zxn_spi_mosi;

   flash_wp_o   <= '0';
   flash_hold_o <= '1';
   
   -- uart (esp)

   esp_tx_o <= zxn_uart0_tx;
   zxn_uart0_rx <= esp_rx_i_q;
   
   ------------------------------------------------------------
   -- EXPANSION BUS -------------------------------------------
   ------------------------------------------------------------
   
   -- zxn_bus_en changes on rising edge of cpu clock
   -- bus cpu clock is held/floated high while the bus is disabled
   -- assumes cpu clock freq << CLK_28
   
   -- input

   zxn_bus_di <= bus_data_i_q;
   zxn_bus_int_n <= bus_int_n_i_q;
-- zxn_bus_nmi_n <= bus_nmi_n_i_q;
   zxn_bus_romcs_n <= bus_romcs_i_q;
   zxn_bus_wait_n <= bus_wait_n_i_q;
   zxn_bus_busreq_n <= bus_busreq_n_i_q;
   zxn_bus_iorqula_n <= bus_iorqula_n_i_q;
   
   db_expbus_nmi : entity work.asymmetrical_debounce
   generic map
   (
      INITIAL_STATE  => '1',
      COUNTER_SIZE   => 3      -- 8 * CLK_28_DEBOUNCE_EN period = ~ 74.8ms
   )
   port map
   (
      clk_i          => CLK_28,
      clk_en_i       => CLK_28_DEBOUNCE_EN,
      reset_i        => reset,
      button_i       => bus_nmi_n_i_q,
      button_o       => zxn_bus_nmi_n
   );
   
   -- output
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         o_zxn_cpu_a <= zxn_cpu_a;
         o_zxn_cpu_do <= zxn_cpu_do;
         o_zxn_cpu_mreq_n <= zxn_cpu_mreq_n;
         o_zxn_cpu_iorq_n <= zxn_cpu_iorq_n;
         o_zxn_cpu_rd_n <= zxn_cpu_rd_n;
         o_zxn_cpu_wr_n <= zxn_cpu_wr_n;
         o_zxn_cpu_m1_n <= zxn_cpu_m1_n;
         o_zxn_cpu_int_n <= zxn_cpu_int_n;
         o_zxn_cpu_busak_n <= zxn_cpu_busak_n;
         o_zxn_cpu_halt_n <= zxn_cpu_halt_n;
         o_zxn_cpu_rfsh_n <= zxn_cpu_rfsh_n;
      end if;
   end process;
   
   bus_addr_o <= (others => 'Z') when zxn_bus_en = '0' else o_zxn_cpu_a;
   bus_data_io <= (others => 'Z') when zxn_bus_en = '0' or o_zxn_cpu_rd_n = '0' or o_zxn_cpu_m1_n = '0' or o_zxn_cpu_rfsh_n = '0' else o_zxn_cpu_do;
   bus_mreq_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_mreq_n;
   bus_iorq_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_iorq_n;
   bus_rd_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_rd_n;
   bus_wr_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_wr_n;
   bus_m1_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_m1_n;
   bus_int_n_io <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_int_n;
   bus_busack_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_busak_n;
   bus_halt_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_halt_n;
   bus_rfsh_n_o <= 'Z' when zxn_bus_en = '0' else o_zxn_cpu_rfsh_n;
   
   -- clock to expansion bus

   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         bus_clk_cpu <= CLK_3M5_CONT;
      end if;
   end process;
   
   bus_clk35_o <= 'Z' when zxn_bus_en = '0' and zxn_bus_clken = '0' else bus_clk_cpu;
   
-- OBUFT_i0 : OBUFT
-- port map
-- (
--    I => CLK_3M5_CONT,
--    O => bus_clk35_o,
--    T => not (zxn_bus_en or zxn_bus_clken)
-- );

-- BUFGMUX1_i3 : BUFGMUX_1
-- generic map
-- (
--    CLK_SEL_TYPE => "ASYNC"
-- )
-- port map
-- (
--    I0 => CLK_3M5_CONT,
--    I1 => CLK_CPU,
--    S => zxn_bus_en,
--    O => zxn_bus_clk
-- );
--
-- ODDR2_i0 : ODDR2
-- generic map
-- (
--    DDR_ALIGNMENT => "NONE",
--    INIT => '1',
--    SRTYPE => "SYNC"
-- )
-- port map
-- (
--    Q => bus_clk_cpu,
--    C0 => zxn_bus_clk,
--    C1 => not zxn_bus_clk,
--    CE => '1',
--    D0 => '1',
--    D1 => '0',
--    R => '0',
--    S => '0'
-- );
-- 
-- ODDR2_i1 : ODDR2
-- generic map
-- (
--    DDR_ALIGNMENT => "NONE",
--    INIT => '1',
--    SRTYPE => "SYNC"
-- )
-- port map
-- (
--    Q => bus_clk_cpu_en_n,
--    C0 => zxn_bus_clk,
--    C1 => not zxn_bus_clk,
--    CE => '1',
--    D0 => not (zxn_bus_en or zxn_bus_clken),
--    D1 => not (zxn_bus_en or zxn_bus_clken),
--    R => '0',
--    S => '0'
-- );
--
-- OBUFT_i0 : OBUFT
-- port map
-- (
--    I => bus_clk_cpu,
--    O => bus_clk35_o,
--    T => bus_clk_cpu_en_n
-- );

   ------------------------------------------------------------
   -- ESP GPIO ------------------------------------------------
   ------------------------------------------------------------
   
   -- input
   
   zxn_esp_gpio20_i <= esp_gpio2_i_q & '0' & esp_gpio0_i_q;
   
   -- output
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         esp_gpio0_o <= zxn_esp_gpio0_o;
         esp_gpio0_en <= zxn_esp_gpio0_en_o;
      end if;
   end process;
   
   esp_gpio2_io <= 'Z';
   esp_gpio0_io <= 'Z' when esp_gpio0_en = '0' else esp_gpio0_o;

   ------------------------------------------------------------
   -- PI GPIO -------------------------------------------------
   ------------------------------------------------------------
   
   -- input

   zxn_pi_gpio_i <= accel_i_q;
   
   -- output
   
   process (CLK_28)
   begin
      if rising_edge(CLK_28) then
         pi_gpio_o <= zxn_gpio_o;
         pi_gpio_en <= zxn_gpio_en;
      end if;
   end process;
   
   accel_io(27) <= 'Z' when pi_gpio_en(27) = '0' else pi_gpio_o(27);
   accel_io(26) <= 'Z' when pi_gpio_en(26) = '0' else pi_gpio_o(26);
   accel_io(25) <= 'Z' when pi_gpio_en(25) = '0' else pi_gpio_o(25);
   accel_io(24) <= 'Z' when pi_gpio_en(24) = '0' else pi_gpio_o(24);
   accel_io(23) <= 'Z' when pi_gpio_en(23) = '0' else pi_gpio_o(23);
   accel_io(22) <= 'Z' when pi_gpio_en(22) = '0' else pi_gpio_o(22);
   accel_io(21) <= 'Z' when pi_gpio_en(21) = '0' else pi_gpio_o(21);
   accel_io(20) <= 'Z' when pi_gpio_en(20) = '0' else pi_gpio_o(20);
   accel_io(19) <= 'Z' when pi_gpio_en(19) = '0' else pi_gpio_o(19);
   accel_io(18) <= 'Z' when pi_gpio_en(18) = '0' else pi_gpio_o(18);
   accel_io(17) <= 'Z' when pi_gpio_en(17) = '0' else pi_gpio_o(17);
   accel_io(16) <= 'Z' when pi_gpio_en(16) = '0' else pi_gpio_o(16);
   accel_io(15) <= 'Z' when pi_gpio_en(15) = '0' else pi_gpio_o(15);
   accel_io(14) <= 'Z' when pi_gpio_en(14) = '0' else pi_gpio_o(14);
   accel_io(13) <= 'Z' when pi_gpio_en(13) = '0' else pi_gpio_o(13);
   accel_io(12) <= 'Z' when pi_gpio_en(12) = '0' else pi_gpio_o(12);
   accel_io(11) <= 'Z' when pi_gpio_en(11) = '0' else pi_gpio_o(11);
   accel_io(10) <= 'Z' when pi_gpio_en(10) = '0' else pi_gpio_o(10);
   accel_io(9)  <= 'Z' when pi_gpio_en(9)  = '0' else pi_gpio_o(9);
   accel_io(8)  <= 'Z' when pi_gpio_en(8)  = '0' else pi_gpio_o(8);
   accel_io(7)  <= 'Z' when pi_gpio_en(7)  = '0' else pi_gpio_o(7);
   accel_io(6)  <= 'Z' when pi_gpio_en(6)  = '0' else pi_gpio_o(6);
   accel_io(5)  <= 'Z' when pi_gpio_en(5)  = '0' else pi_gpio_o(5);
   accel_io(4)  <= 'Z' when pi_gpio_en(4)  = '0' else pi_gpio_o(4);
   accel_io(3)  <= 'Z' when pi_gpio_en(3)  = '0' else pi_gpio_o(3);
   accel_io(2)  <= 'Z' when pi_gpio_en(2)  = '0' else pi_gpio_o(2);
   accel_io(1)  <= 'Z' when pi_gpio_en(1)  = '0' else pi_gpio_o(1);
   accel_io(0)  <= 'Z' when pi_gpio_en(0)  = '0' else pi_gpio_o(0);

   ------------------------------------------------------------
   -- TBBLUE / ZXNEXT -----------------------------------------
   ------------------------------------------------------------

   --  F1 = hard reset
   --  F2 = toggle scandoubler, hdmi reset
   --  F3 = toggle 50Hz / 60Hz display
   --  F4 = soft reset
   --  F7 = change scanline weight
   --  F8 = change cpu speed
   --  F9 = m1 button (multiface nmi)
   -- F10 = drive button (divmmc nmi)

   zxn_function_keys <= (ps2_kbd_function_keys(10) or membrane_function_keys(10) or not btn_drive_divmmc_db_n) & (ps2_kbd_function_keys(9 downto 1) or membrane_function_keys(9 downto 1));
      
   zxnext : entity work.zxnext
   generic map
   (
      g_machine_id         => g_machine_id,
      g_version            => g_version,
      g_sub_version        => g_sub_version
   )
   port map
   (
      -- CLOCK
      
      i_CLK_28             => CLK_28,
      i_CLK_28_n           => CLK_28_n,
      i_CLK_14             => CLK_14,
      i_CLK_7              => CLK_7,
      i_CLK_CPU            => CLK_CPU,
      i_CLK_PSG_EN         => CLK_28_PSG_EN,
      
      o_CPU_SPEED          => zxn_cpu_speed,
      o_CPU_CONTEND        => zxn_clock_contend,
      o_CPU_CLK_LSB        => zxn_clock_lsb,
      
      -- RESET

      i_RESET_HARD         => reset_hard,
      i_RESET_SOFT         => reset_soft,
      
      o_RESET_SOFT         => zxn_reset_soft,
      o_RESET_HARD         => zxn_reset_hard,
      o_RESET_PERIPHERAL   => zxn_reset_peripheral,
      
      -- FLASH BOOT
      
      o_FLASH_BOOT         => zxn_flashboot,
      o_CORE_ID            => zxn_coreid,
      
      -- SPECIAL KEYS

      i_SPKEY_FUNCTION     => zxn_function_keys,
      i_SPKEY_BUTTONS      => zxn_buttons,
      
      -- MEMBRANE KEYBOARD
      
      o_KBD_CANCEL         => zxn_cancel_extended_entries,
      
      o_KBD_ROW            => zxn_key_row,
      i_KBD_COL            => zxn_key_col,
      
      i_KBD_EXTENDED_KEYS  => zxn_extended_keys,
      
      -- PS/2 KEYBOARD SETUP
      
      o_KEYMAP_ADDR        => zxn_keymap_addr,
      o_KEYMAP_DATA        => zxn_keymap_dat,
      o_KEYMAP_WE          => zxn_keymap_we,
      
      -- JOYSTICK
      
      i_JOY_LEFT           => zxn_joy_left,
      i_JOY_RIGHT          => zxn_joy_right,

      o_JOY_IO_MODE        => zxn_joy_io_mode_en,
      o_JOY_IO_MODE_LR     => zxn_joy_io_mode_lr,
      o_JOY_IO_MODE_PIN_7  => zxn_joy_io_mode_pin_7,
      
      -- MOUSE
      
      i_MOUSE_X            => zxn_mouse_x,
      i_MOUSE_Y            => zxn_mouse_y,
      i_MOUSE_BUTTON       => zxn_mouse_button,
      i_MOUSE_WHEEL        => zxn_mouse_wheel(3 downto 0),
      
      o_PS2_MODE           => zxn_ps2_mode,
      o_MOUSE_CONTROL      => zxn_mouse_control,
      
      -- I2C
      
      i_I2C_SCL_n          => zxn_i2c_scl_n_i,
      i_I2C_SDA_n          => zxn_i2c_sda_n_i,
      
      o_I2C_SCL_n          => zxn_i2c_scl_n_o,
      o_I2C_SDA_n          => zxn_i2c_sda_n_o,
      
      -- SPI

      o_SPI_SS_FLASH_n     => zxn_spi_ss_flash_n,
      o_SPI_SS_SD1_n       => zxn_spi_ss_sd1_n,
      o_SPI_SS_SD0_n       => zxn_spi_ss_sd0_n,

      o_SPI_SCK            => zxn_spi_sck,
      o_SPI_MOSI           => zxn_spi_mosi,
      
      i_SPI_SD_MISO        => sd_miso_i,
      i_SPI_FLASH_MISO     => flash_miso_i,
      
      -- UART
      
      i_UART0_RX           => zxn_uart0_rx,
      o_UART0_TX           => zxn_uart0_tx,
      
      -- VIDEO
      -- synchronized to i_CLK_14
      
      o_RGB                => zxn_rgb,
      o_RGB_CS_n           => zxn_rgb_cs_n,
      o_RGB_VS_n           => zxn_rgb_vs_n,
      o_RGB_HS_n           => zxn_rgb_hs_n,
      o_RGB_VB_n           => zxn_rgb_vb_n,
      o_RGB_HB_n           => zxn_rgb_hb_n,
      
      o_VIDEO_50_60        => zxn_video_50_60,
      o_VIDEO_SCANLINES    => zxn_video_scanlines,
      o_VIDEO_SCANDOUBLE   => zxn_video_scandouble_en,
      
      o_VIDEO_MODE         => zxn_video_mode,                     -- VGA 0-6, HDMI
      o_MACHINE_TIMING     => zxn_machine_timing,                 -- video timing: 00X = 48k, 010 = 128k, 011 = +3, 100 = pentagon
      
      o_HDMI_RESET         => zxn_hdmi_reset,
      
      -- AUDIO
      
      o_AUDIO_HDMI_AUDIO_EN => zxn_hdmi_audio,

      o_AUDIO_SPEAKER_EN   => zxn_speaker_en,
      o_AUDIO_SPEAKER_BEEP => zxn_speaker_beep,
      
      i_AUDIO_EAR          => ear_port_i_q,
      o_AUDIO_MIC          => zxn_tape_mic,

      o_AUDIO_SPEAKER_EAR  => zxn_audio_ear,
      o_AUDIO_SPEAKER_MIC  => zxn_audio_mic,
      
      o_AUDIO_L            => zxn_audio_L_pre,
      o_AUDIO_R            => zxn_audio_R_pre,

      -- EXTERNAL SRAM (synchronized to i_CLK_28)
      -- memory transactions complete in one cycle, data read is registered but available asap
      
      -- Port A is read/write and highest priority (CPU)
      
      o_RAM_A_ADDR         => zxn_ram_a_addr,
      o_RAM_A_REQ          => zxn_ram_a_req,
      o_RAM_A_RD           => zxn_ram_a_rd,
      i_RAM_A_DI           => zxn_ram_a_di,
      o_RAM_A_DO           => zxn_ram_a_do,
      
      -- Port B is read only (LAYER 2)
      
      o_RAM_B_ADDR         => zxn_ram_b_addr,
      o_RAM_B_REQ_T        => zxn_ram_b_req_t,
      i_RAM_B_DI           => zxn_ram_b_di,
      
      -- CLK 3.5 and 7 MHz hack
      i_CLK_WAIT_n         => zxn_clk_wait_n,
      
      -- EXPANSION BUS
      
      o_BUS_ADDR           => zxn_cpu_a,
      i_BUS_DI             => zxn_bus_di,
      o_BUS_DO             => zxn_cpu_do,
      o_BUS_MREQ_n         => zxn_cpu_mreq_n,
      o_BUS_IORQ_n         => zxn_cpu_iorq_n,
      o_BUS_RD_n           => zxn_cpu_rd_n,
      o_BUS_WR_n           => zxn_cpu_wr_n,
      o_BUS_M1_n           => zxn_cpu_m1_n,
      i_BUS_WAIT_n         => zxn_bus_wait_n,
      i_BUS_NMI_n          => zxn_bus_nmi_n,
      i_BUS_INT_n          => zxn_bus_int_n,
      o_BUS_INT_n          => zxn_cpu_int_n,
      i_BUS_BUSREQ_n       => zxn_bus_busreq_n,
      o_BUS_BUSAK_n        => zxn_cpu_busak_n,
      o_BUS_HALT_n         => zxn_cpu_halt_n,
      o_BUS_RFSH_n         => zxn_cpu_rfsh_n,
      
      i_BUS_ROMCS_n        => zxn_bus_romcs_n,
      i_BUS_IORQULA_n      => zxn_bus_iorqula_n,
      
      o_BUS_EN             => zxn_bus_en,
      o_BUS_CLKEN          => zxn_bus_clken,

      -- ESP GPIO
      
      i_ESP_GPIO_20        => zxn_esp_gpio20_i,
      
      o_ESP_GPIO_0         => zxn_esp_gpio0_o,
      o_ESP_GPIO_0_EN      => zxn_esp_gpio0_en_o,

      -- PI GPIO
      
      i_GPIO               => zxn_pi_gpio_i,
      
      o_GPIO               => zxn_gpio_o,
      o_GPIO_EN            => zxn_gpio_en
   );

   -- process audio signal
   -- hdmi seems to suffer on beeper audio so may need a lp filter as well

   zxn_audio_L <= (others => '1') when zxn_audio_L_pre(12) = '1' else zxn_audio_L_pre(11 downto 0);
   zxn_audio_R <= (others => '1') when zxn_audio_R_pre(12) = '1' else zxn_audio_R_pre(11 downto 0);
   
 -- zxdos - Joysticks
	clk01 <= clk_28_div(4);  -- 28 MHz /32 = 875 Khz  /18  =>  48 Khz read the 2 joy

	joy_clk  <= clk01;
	joy_load <= joy_renew;

	process(clk01)	begin
			if rising_edge(clk01) then
				if (joy_count = X"00") then joy_renew <= '0';   else joy_renew <= '1'; end if;
				if (joy_count = X"0e") then joy_count <= X"00"; else joy_count <= joy_count + 1; end if;
			end if;
	end process;

	process(clk01) begin
		if rising_edge(clk01) then
       case joy_count is
         when X"02" => joyA(5) <= joy_data;  -- 1p fire2
			when X"03" => joyA(4) <= joy_data;  -- 1p fire1
       	when X"04" => joyA(3) <= joy_data;  -- 1p right
       	when X"05" => joyA(2) <= joy_data;  -- 1p left
       	when X"06" => joyA(1) <= joy_data;  -- 1p down
       	when X"07" => joyA(0) <= joy_data;  -- 1p up
       	when X"08" => joyA(5) <= joy_data;  -- 2p fire2
			when X"09" => joyB(4) <= joy_data;  -- 2p fire1
         when X"0a" => joyB(3) <= joy_data;  -- 2p right
         when X"0b" => joyB(2) <= joy_data;  -- 2p left 
         when X"0c" => joyB(1) <= joy_data;  -- 2p down
         when X"0d" => joyB(0) <= joy_data;  -- 2p up
       when others => null;
       end case;
		end if;
	end process;
    	 
   -- active high START/MODE A/X B/Y/F2 C/Z/F1 U D L R   (oficially -  active high =  X Z Y START A C B U D L R )
	zxn_joy_left 	<=  "000" & not (joyA(6) & "1" & joyA(5) & joyA(4) & joyA(0) & joyA(1) & joyA(2) & joyA(3));
	zxn_joy_right	<=  "000" & not (joyB(6) & "1" & joyB(5) & joyB(4) & joyB(0) & joyB(1) & joyB(2) & joyB(3)); 

end architecture;
