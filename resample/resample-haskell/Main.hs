{-# LANGUAGE OverloadedStrings #-}

module Main where
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector.Unboxed as VU
import qualified Data.Vector as V
import Statistics.Distribution
import Statistics.Distribution.Normal
import Statistics.Distribution.StudentT
import Statistics.Sample as S;
import Statistics.Types
import Statistics.Resampling (resample)
import Statistics.Resampling.Bootstrap (bootstrapBCA)
import System.Random.MWC
import Text.Printf
import Control.Monad.ST
import Control.Applicative
import Data.Csv
import Data.Time

data SecurityStats = SS { tdate :: !String,
                          stype :: !String,
                          ticker :: !String }


instance FromNamedRecord SecurityStats where
    parseNamedRecord r = SS <$> r .: "tdate" <*> r .: "stype"  <*> r .: "ticker"


makeInteger :: [String] -> [Double]
makeInteger = map read


readSample :: IO Sample
readSample = do
  s <- readFile "/home/mikem/Development/projects/Data/litvol.csv"
  return $ VU.fromList (makeInteger (lines s))

readSecurityData :: IO (V.Vector SecurityStats)
readSecurityData = do
    csvData <- BL.readFile "/home/mikem/Development/projects/Data/q4_2014_small.csv"
    case decodeByName csvData of
        Left err -> return V.empty
        Right (_, v) -> return v


main :: IO ()
main = do
  v <- readSample
  g <- createSystemRandom
  resamples <- resample g [Mean, Variance] 10000 v
  print $ bootstrapBCA 0.95 v [Mean, Variance] resamples

