{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<*>),(*>),(<$>),(<|>),pure)
import qualified Data.Attoparsec.Text as A
import Data.Attoparsec.Text (Parser)
import Data.Text (Text)

data Fubar = Foo | Bar deriving (Show, Eq)

data Holding = 
  Holding {
    holdingName :: Text,
    holdingTitle :: Text
    } deriving Show

pCname :: Parser Text
pCname = A.take 29

pTitle :: Parser Text
pTitle = A.take 10

pHolding = do
  name <- pCname 
  title <- pTitle
  return $ Holding name title

pFoob :: Parser Fubar
pFoob =  A.stringCI "foo" *> pure Foo
         <|>  A.stringCI "bar" *> pure Bar


main :: IO ()
main = do
  print $ A.parseOnly pFoob "foo"
  print $ A.parseOnly pHolding "ACCENTIA BIOPHARMACEUTICALS  COM                 00430L103"
  
-- ACCENTIA BIOPHARMACEUTICALS  COM                 00430L103       26    10050       SH        SOLE               10050

