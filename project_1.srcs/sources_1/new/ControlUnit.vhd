library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ControlUnit is
    Port ( instr : in STD_LOGIC_VECTOR(2 downto 0);
           regDst : out STD_LOGIC;
           extOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           branchEqual : out STD_LOGIC;
           branchNotEqual : out STD_LOGIC;
           branchGreater : out STD_LOGIC;
           jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           regWrite : out STD_LOGIC );
end ControlUnit;

architecture Behavioral of ControlUnit is
begin
    process(instr)
    begin
        regDst <= '0';
        extOp <= '0';
        ALUSrc <= '0';
        branchEqual <= '0';
        branchNotEqual <= '0';
        branchGreater <= '0';
        jump <= '0';
        ALUOp <= b"00";
        memWrite <= '0';
        memToReg <= '0';
        regWrite <= '0';
        case instr is
            when "000" =>
                regDst <= '1';
                regWrite <= '1';
                ALUOp(1) <= '1';
            when "001" =>
                regWrite <= '1';
                ALUSrc <= '1';
                extOp <= '1';
            when "010" =>
                regWrite <= '1';
                ALUSrc <= '1';
                extOp <= '1';
                memToReg <= '1';
            when "011" =>
                ALUSrc <= '1';
                extOp <= '1';
                memWrite <= '1';
            when "100" =>
                extOp <= '1';
                ALUOp(0) <= '1';
                branchEqual <= '1';
            when "101" =>
                extOp <= '1';
                ALUOp(0) <= '1';
                branchNotEqual <= '1';
            when "110" =>
                extOp <= '1';
                ALUOp(0) <= '1';
                branchGreater <= '1';
            when others =>
                jump <= '1'; 
        end case;
    end process;
end Behavioral;
