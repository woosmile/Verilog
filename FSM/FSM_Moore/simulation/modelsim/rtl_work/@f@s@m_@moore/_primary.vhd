library verilog;
use verilog.vl_types.all;
entity FSM_Moore is
    generic(
        st0             : integer := 0;
        st1             : integer := 1;
        st2             : integer := 2;
        st3             : integer := 3
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        control         : in     vl_logic;
        y               : out    vl_logic_vector(2 downto 0)
    );
end FSM_Moore;
