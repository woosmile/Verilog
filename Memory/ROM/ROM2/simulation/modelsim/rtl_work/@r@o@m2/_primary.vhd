library verilog;
use verilog.vl_types.all;
entity ROM2 is
    port(
        addr            : in     vl_logic_vector(3 downto 0);
        inclk           : in     vl_logic;
        q               : out    vl_logic_vector(3 downto 0)
    );
end ROM2;
