library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_de2_115_top is
end entity;

architecture sim of tb_de2_115_top is

  -- ======================
  -- Clock and inputs
  -- ======================
  signal CLOCK_50  : std_logic := '0';
  signal CLOCK2_50 : std_logic := '0';
  signal CLOCK3_50 : std_logic := '0';
  signal SMA_CLKIN : std_logic := '0';

  signal KEY : std_logic_vector(3 downto 0)  := (others => '1');
  signal SW  : std_logic_vector(17 downto 0) := (others => '0');

  -- ======================
  -- Outputs we observe
  -- ======================
  signal LEDG : std_logic_vector(8 downto 0);
  signal LEDR : std_logic_vector(17 downto 0);

  signal HEX0 : std_logic_vector(6 downto 0);
  signal HEX1 : std_logic_vector(6 downto 0);
  signal HEX2 : std_logic_vector(6 downto 0);
  signal HEX3 : std_logic_vector(6 downto 0);
  signal HEX4 : std_logic_vector(6 downto 0);
  signal HEX5 : std_logic_vector(6 downto 0);
  signal HEX6 : std_logic_vector(6 downto 0);
  signal HEX7 : std_logic_vector(6 downto 0);

  -- ======================
  -- Unused but required ports
  -- ======================
  signal SMA_CLKOUT : std_logic;

  signal UART_CTS : std_logic;
  signal UART_RTS : std_logic := '0';
  signal UART_RXD : std_logic := '0';
  signal UART_TXD : std_logic;

  signal LCD_BLON, LCD_EN, LCD_ON, LCD_RS, LCD_RW : std_logic;
  signal LCD_DATA : std_logic_vector(7 downto 0);

  signal PS2_CLK, PS2_DAT, PS2_CLK2, PS2_DAT2 : std_logic;

  signal VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS : std_logic;
  signal VGA_R, VGA_G, VGA_B : unsigned(7 downto 0);

  signal SRAM_ADDR : unsigned(19 downto 0);
  signal SRAM_DQ   : unsigned(15 downto 0);
  signal SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N : std_logic;

  signal AUD_ADCDAT : std_logic := '0';
  signal AUD_ADCLRCK, AUD_BCLK : std_logic;
  signal AUD_DACDAT : std_logic;
  signal AUD_DACLRCK : std_logic;
  signal AUD_XCK : std_logic;

begin


  ------------------------------------------------------------------
  -- DUT instantiation
  -- Override generic for fast simulation (Problem 4)
  ------------------------------------------------------------------
  dut : entity work.DE2_115_TOP
    generic map (
      TICKS_PER_SECOND => 100
    )
    port map (
      CLOCK_50  => CLOCK_50,
      CLOCK2_50 => CLOCK2_50,
      CLOCK3_50 => CLOCK3_50,
      SMA_CLKIN => SMA_CLKIN,
      SMA_CLKOUT => SMA_CLKOUT,

      KEY => KEY,
      SW  => SW,

      HEX0 => HEX0,
      HEX1 => HEX1,
      HEX2 => HEX2,
      HEX3 => HEX3,
      HEX4 => HEX4,
      HEX5 => HEX5,
      HEX6 => HEX6,
      HEX7 => HEX7,

      LEDG => LEDG,
      LEDR => LEDR,

      UART_CTS => UART_CTS,
      UART_RTS => UART_RTS,
      UART_RXD => UART_RXD,
      UART_TXD => UART_TXD,

      LCD_BLON => LCD_BLON,
      LCD_EN   => LCD_EN,
      LCD_ON   => LCD_ON,
      LCD_RS   => LCD_RS,
      LCD_RW   => LCD_RW,
      LCD_DATA => LCD_DATA,

      PS2_CLK  => PS2_CLK,
      PS2_DAT  => PS2_DAT,
      PS2_CLK2 => PS2_CLK2,
      PS2_DAT2 => PS2_DAT2,

      VGA_BLANK_N => VGA_BLANK_N,
      VGA_CLK     => VGA_CLK,
      VGA_HS      => VGA_HS,
      VGA_SYNC_N  => VGA_SYNC_N,
      VGA_VS      => VGA_VS,
      VGA_R       => VGA_R,
      VGA_G       => VGA_G,
      VGA_B       => VGA_B,

      SRAM_ADDR => SRAM_ADDR,
      SRAM_DQ   => SRAM_DQ,
      SRAM_CE_N => SRAM_CE_N,
      SRAM_LB_N => SRAM_LB_N,
      SRAM_OE_N => SRAM_OE_N,
      SRAM_UB_N => SRAM_UB_N,
      SRAM_WE_N => SRAM_WE_N,

      AUD_ADCDAT  => AUD_ADCDAT,
      AUD_ADCLRCK => AUD_ADCLRCK,
      AUD_BCLK    => AUD_BCLK,
      AUD_DACDAT  => AUD_DACDAT,
      AUD_DACLRCK => AUD_DACLRCK,
      AUD_XCK     => AUD_XCK
    );
  process
  begin
     while true loop
        CLOCK_50 <= '1';
        wait for 0.005 sec;
        CLOCK_50 <= '0';
        wait for 0.005 sec;
    end loop;
  end process;

end architecture;
