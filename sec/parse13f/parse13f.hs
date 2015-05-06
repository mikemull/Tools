{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<*>),(*>),(<$>),(<|>),pure)
import qualified Data.Attoparsec.Text as A
import Data.Attoparsec.Text (Parser)
import Data.Text (Text)

data Holding = 
  Holding {
    holdingName :: Text,
    holdingTitle :: Text,
    cusip :: Text,
    holdingValue :: Int
    } deriving Show

pCname :: Parser Text
pCname = A.take 29

pTitle :: Parser Text
pTitle = A.take 20

pCusip :: Parser Text
pCusip = A.take 16

pHolding = do
  name <- pCname 
  title <- pTitle
  cusip <- pCusip
  val <- A.decimal
  return $ Holding name title cusip val

main :: IO ()
main = do
  print $ A.parseOnly pHolding "ACCENTIA BIOPHARMACEUTICALS  COM                 00430L103       26    10050       SH        SOLE               10050"
