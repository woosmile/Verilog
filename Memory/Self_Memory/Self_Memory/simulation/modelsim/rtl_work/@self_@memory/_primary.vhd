library verilog;
use verilog.vl_types.all;
entity Self_Memory is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        add_sub         : in     vl_logic;
        a               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(7 downto 0);
        ovf             : out    vl_logic
    );
end Self_Memory;
