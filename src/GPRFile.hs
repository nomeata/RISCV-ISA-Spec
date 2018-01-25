module GPRFile (GPRFile, print_GPRFile, mkGPRFile, get_gpr, set_gpr) where

-- ================================================================
-- This module defines an abstraction for
-- a RISC-V GPR (General Purpose Register) register file.

-- ================================================================
-- Standard Haskell imports

import Data.Maybe
import Data.Word
import qualified Data.Map as Data_Map
import Numeric (showHex, readHex)

-- Project imports

import ArchDefs64

-- ================================================================
-- The GPR file is represented as Data.Map.Map from GPR addresses (0..31) to values
-- This is a private internal representation that can be changed at
-- will; only the exported API can be used by clients.

newtype GPRFile = GPRFile (Data_Map.Map  Register  MachineWord)
  deriving (Show)

-- print_GPRFile prints four regs per line, in hex, with given indent
print_GPRFile :: String -> GPRFile -> IO ()
print_GPRFile  indent  gprfile = do
  print_n  0   3
  print_n  4   7
  print_n  8  11
  print_n 12  15
  print_n 16  19
  print_n 20  23
  print_n 24  27
  print_n 28  31
  where
    print_n :: Register -> Register -> IO ()
    print_n  r1 r2 = do
      putStr (indent ++ show r1 ++ ":")
      mapM_  (\j -> putStr ("  " ++ showHex (get_gpr gprfile j) ""))
             [r1..r2]
      putStrLn ""

mkGPRFile :: GPRFile
mkGPRFile = GPRFile (Data_Map.fromList (take 31 (repeat (fromIntegral 0, fromIntegral 0))))

get_gpr :: GPRFile -> Register -> MachineWord
get_gpr  (GPRFile gprfile)  reg = fromMaybe 0 (Data_Map.lookup  reg  gprfile)

set_gpr :: GPRFile -> Register -> MachineWord -> GPRFile
set_gpr  (GPRFile gprfile)  reg  val = GPRFile (Data_Map.insert  reg  val'  gprfile)
  where
    val' = if (reg == 0) then 0 else val

-- ================================================================