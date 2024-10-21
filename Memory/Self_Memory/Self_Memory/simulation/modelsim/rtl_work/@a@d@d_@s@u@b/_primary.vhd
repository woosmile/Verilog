library verilog;
use verilog.vl_types.all;
entity ADD_SUB is
    port(
        aclr            : in     vl_logic;
        add_sub         : in     vl_logic;
        clock           : in     vl_logic;
        dataa           : in     vl_logic_vector(7 downto 0);
        datab           : in     vl_logic_vector(7 downto 0);
        overflow        : out    vl_logic;
        result          : out    vl_logic_vector(7 downto 0)
    );
end ADD_SUB;
