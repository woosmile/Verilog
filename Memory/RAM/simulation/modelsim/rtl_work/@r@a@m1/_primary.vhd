library verilog;
use verilog.vl_types.all;
entity RAM1 is
    port(
        clk             : in     vl_logic;
        wr              : in     vl_logic;
        rd              : in     vl_logic;
        addr            : in     vl_logic_vector(3 downto 0);
        data_in         : in     vl_logic_vector(3 downto 0);
        q               : out    vl_logic_vector(3 downto 0)
    );
end RAM1;
