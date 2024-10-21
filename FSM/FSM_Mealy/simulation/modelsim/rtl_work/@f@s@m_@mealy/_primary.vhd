library verilog;
use verilog.vl_types.all;
entity FSM_Mealy is
    generic(
        A               : integer := 0;
        B               : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        w               : in     vl_logic;
        z               : out    vl_logic
    );
end FSM_Mealy;
