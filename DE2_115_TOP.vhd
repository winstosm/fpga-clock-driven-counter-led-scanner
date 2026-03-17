--
-- DE2-115 top-level module (entity declaration)
--
-- William H. Robinson, Vanderbilt University University
--   william.h.robinson@vanderbilt.edu
--
-- Updated from the DE2 top-level module created by 
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE2_115_TOP is
  generic (
    TICKS_PER_SECOND : natural := 50_000_000  -- default for 50 MHz CLOCK_50
  );
  port (
    -- Clocks
    
    CLOCK_50 	: in std_logic;                     -- 50 MHz
    CLOCK2_50 	: in std_logic;                     -- 50 MHz
    CLOCK3_50 	: in std_logic;                     -- 50 MHz
    SMA_CLKIN  : in std_logic;                     -- External Clock Input
    SMA_CLKOUT : out std_logic;                    -- External Clock Output

    -- Buttons and switches
    
    KEY : in std_logic_vector(3 downto 0);         -- Push buttons
    SW  : in std_logic_vector(17 downto 0);        -- DPDT switches

    -- LED displays

    HEX0 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX1 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX2 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX3 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX4 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX5 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX6 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX7 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    LEDG : out std_logic_vector(8 downto 0);       -- Green LEDs (active high)
    LEDR : out std_logic_vector(17 downto 0);      -- Red LEDs (active high)

    -- RS-232 interface

    UART_CTS : out std_logic;                      -- UART Clear to Send   
    UART_RTS : in std_logic;                       -- UART Request to Send   
    UART_RXD : in std_logic;                       -- UART Receiver
    UART_TXD : out std_logic;                      -- UART Transmitter   

    -- 16 X 2 LCD Module
    
    LCD_BLON : out std_logic;      							-- Back Light ON/OFF
    LCD_EN   : out std_logic;      							-- Enable
    LCD_ON   : out std_logic;      							-- Power ON/OFF
    LCD_RS   : out std_logic;	   							-- Command/Data Select, 0 = Command, 1 = Data
    LCD_RW   : out std_logic; 	   						-- Read/Write Select, 0 = Write, 1 = Read
    LCD_DATA : inout std_logic_vector(7 downto 0); 	-- Data bus 8 bits

    -- PS/2 ports

    PS2_CLK : inout std_logic;     -- Clock
    PS2_DAT : inout std_logic;     -- Data

    PS2_CLK2 : inout std_logic;    -- Clock
    PS2_DAT2 : inout std_logic;    -- Data

    -- VGA output
    
    VGA_BLANK_N : out std_logic;            -- BLANK
    VGA_CLK 	 : out std_logic;            -- Clock
    VGA_HS 		 : out std_logic;            -- H_SYNC
    VGA_SYNC_N  : out std_logic;            -- SYNC
    VGA_VS 		 : out std_logic;            -- V_SYNC
    VGA_R 		 : out unsigned(7 downto 0); -- Red[9:0]
    VGA_G 		 : out unsigned(7 downto 0); -- Green[9:0]
    VGA_B 		 : out unsigned(7 downto 0); -- Blue[9:0]

    -- SRAM
    
    SRAM_ADDR : out unsigned(19 downto 0);         -- Address bus 20 Bits
    SRAM_DQ   : inout unsigned(15 downto 0);       -- Data bus 16 Bits
    SRAM_CE_N : out std_logic;                     -- Chip Enable
    SRAM_LB_N : out std_logic;                     -- Low-byte Data Mask 
    SRAM_OE_N : out std_logic;                     -- Output Enable
    SRAM_UB_N : out std_logic;                     -- High-byte Data Mask 
    SRAM_WE_N : out std_logic;                     -- Write Enable

    -- Audio CODEC
    
    AUD_ADCDAT 	: in std_logic;               -- ADC Data
    AUD_ADCLRCK 	: inout std_logic;            -- ADC LR Clock
    AUD_BCLK 		: inout std_logic;            -- Bit-Stream Clock
    AUD_DACDAT 	: out std_logic;              -- DAC Data
    AUD_DACLRCK 	: inout std_logic;            -- DAC LR Clock
    AUD_XCK 		: out std_logic               -- Chip Clock
    
    );
  
end DE2_115_TOP;


architecture rtl of DE2_115_TOP is

  -- ======================
  -- Master timing: 10 Hz tick derived from CLOCK_50
  -- ======================
  constant TICKS_PER_10HZ : natural := (TICKS_PER_SECOND / 10);

  signal cnt_10hz  : unsigned(31 downto 0) := (others => '0');
  signal tick_10hz : std_logic := '0';

  -- Divide 10 Hz tick by 10 to make 1 Hz
  signal ten_count : unsigned(3 downto 0) := (others => '0'); -- 0..9

  -- ======================
  -- Problem 1: 1 Hz blink
  -- ======================
  signal ledg_bit  : std_logic := '0';

  -- ======================
  -- Problem 2: 10 Hz scan (one-hot)
  -- ======================
  signal led_pos   : integer range 0 to 9 := 0;
  signal led_dir   : std_logic := '1'; -- '1' = right, '0' = left
  signal ledr_int  : std_logic_vector(17 downto 0) := (others => '0');

  -- ======================
  -- Problem 3: decimal counter
  -- ======================
  signal ones     : integer range 0 to 9 := 0;
  signal tens     : integer range 0 to 9 := 0;
  signal hundreds : integer range 0 to 9 := 0;

  function seven_seg(d : integer range 0 to 9) return std_logic_vector is
  begin
    case d is
      when 0 => return "1000000";
      when 1 => return "1111001";
      when 2 => return "0100100";
      when 3 => return "0110000";
      when 4 => return "0011001";
      when 5 => return "0010010";
      when 6 => return "0000010";
      when 7 => return "1111000";
      when 8 => return "0000000";
      when 9 => return "0010000";
      when others => return "1111111";
    end case;
  end function;

begin

  ------------------------------------------------------------------
  -- Single clocked process:
  --   - Generates 10 Hz tick (off-by-one fixed)
  --   - Updates scan at 10 Hz
  --   - Updates blink + decimal counter at 1 Hz (every 10 ticks)
  ------------------------------------------------------------------
  process(CLOCK_50)
  begin
    if rising_edge(CLOCK_50) then

      -- 10 Hz tick generator (compare to TICKS_PER_10HZ - 1)
      if cnt_10hz = to_unsigned(TICKS_PER_10HZ - 1, cnt_10hz'length) then
        cnt_10hz  <= (others => '0');
        tick_10hz <= '1';
      else
        cnt_10hz  <= cnt_10hz + 1;
        tick_10hz <= '0';
      end if;

      -- Advance state only on the 10 Hz tick
      if tick_10hz = '1' then

        -- Problem 2: one-hot scanning position update @ 10 Hz
        if led_dir = '1' then
          if led_pos = 9 then
            led_dir <= '0';
            led_pos <= 8;
          else
            led_pos <= led_pos + 1;
          end if;
        else
          if led_pos = 0 then
            led_dir <= '1';
            led_pos <= 1;
          else
            led_pos <= led_pos - 1;
          end if;
        end if;

        -- Problem 1/3: 1 Hz derived from 10 Hz (every 10 ticks)
        if ten_count = 9 then
          ten_count <= (others => '0');

          -- 1 Hz blink
          ledg_bit <= not ledg_bit;

          -- decimal increment
          if ones = 9 then
            ones <= 0;
            if tens = 9 then
              tens <= 0;
              if hundreds = 9 then
                hundreds <= 0;
              else
                hundreds <= hundreds + 1;
              end if;
            else
              tens <= tens + 1;
            end if;
          else
            ones <= ones + 1;
          end if;

        else
          ten_count <= ten_count + 1;
        end if;

      end if;
    end if;
  end process;

  ------------------------------------------------------------------
  -- One-hot decoder for red LEDs (combinational)
  ------------------------------------------------------------------
  process(led_pos)
  begin
    ledr_int <= (others => '0');
    ledr_int(led_pos) <= '1';
  end process;

  ------------------------------------------------------------------
  -- Outputs (only using LEDR(9 downto 0) for scan; others off)
  ------------------------------------------------------------------
  LEDG(0) <= ledg_bit;
  LEDG(8 downto 1) <= (others => '0');

  LEDR <= ledr_int;

  HEX0 <= seven_seg(ones);
  HEX1 <= seven_seg(tens);
  HEX2 <= seven_seg(hundreds);
  HEX3 <= (others => '1');
  HEX4 <= (others => '1');
  HEX5 <= (others => '1');
  HEX6 <= (others => '1');
  HEX7 <= (others => '1');

end architecture;
