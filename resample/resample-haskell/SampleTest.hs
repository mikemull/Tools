module Main where
import Data.Vector.Unboxed as V
import Statistics.Distribution
import Statistics.Distribution.Normal
import Statistics.Distribution.StudentT
import Statistics.Sample as S;
import Statistics.Types (Estimator)
import Statistics.Resampling (resample)
import Statistics.Resampling.Bootstrap (bootstrapBCA)
import System.Random.MWC
import Text.Printf
import Control.Monad.ST


pickSample :: IO Sample
pickSample = withSystemRandom $
              \gen -> replicateM 1000 (randomDouble gen) :: IO Sample
    where randomDouble = genContVar standard


meanRange95 :: Sample -> (Double, Double)
meanRange95 sample = (S.mean sample - base, S.mean sample + base)
    where n = fromIntegral (V.length sample) - 1 :: Double
          tQuantile95 = quantile (studentT n) 0.975
          base = tQuantile95 * S.stdDev sample / sqrt n


main :: IO ()
main = do
  sample <- pickSample
  printf "mean of sample: %.4f\n" (S.mean sample)
  printf "stddev of sample: %.4f\n" (S.stdDev sample)

  let (min, max) = meanRange95 sample
  printf "%.4f <= mean of population <= %.4f\n" min max
