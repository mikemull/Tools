{-# LANGUAGE ScopedTypeVariables #-}

import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.UTF8 as BLU
import Data.Csv
import qualified Data.Vector as V
import Data.Binary as B
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    csvData <- BL.readFile $ head args
    case Data.Csv.decode HasHeader csvData of
        Left err -> putStrLn err
        Right v -> V.forM_ v $ \ (date :: BL.ByteString, advisor :: BL.ByteString, firm :: BL.ByteString, crd :: Maybe Int) ->
            BL.putStrLn (BL.concat [advisor, firm, BLU.fromString (show crd) ])
