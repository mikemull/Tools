{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Environment
import qualified Data.ByteString.Lazy as BL
import qualified Data.List as L

import Data.Text
import Data.Text.Read (decimal)
import Data.Maybe
import Text.XML.Cursor
import Text.HTML.DOM (parseLBS)
import Text.ParserCombinators.Parsec


type Shares = Int
type InvestmentName = Text
type Balance = Int
data Holding = Holding InvestmentName Balance Shares deriving (Show)

amount :: GenParser Text st Int
amount = do
         ntext <- item
         case decimal (Data.Text.filter (/= ',') ntext) of
                       Left _ ->  fail "not int"
                       Right (n,_)  -> return n

holdingRow :: GenParser Text st Holding
holdingRow = balanceRowFootNote <|> balanceRow

balanceRow :: GenParser Text st Holding
balanceRow = try $ do
             invName <- item
             shares <- amount
             balance <- amount
             return $ Holding invName shares balance

balanceRowFootNote :: GenParser Text st Holding
balanceRowFootNote = try $ do
             invName <- item
             _ <- item
             shares <- amount
             balance <- amount
             return $ Holding invName shares balance

parseHoldingRow :: [Text] -> Maybe Holding
parseHoldingRow row = case parse holdingRow "" row  of
                       Left _ -> Nothing
                       Right h -> Just h
                       
item = tokenPrim show updatePos getItem where
  getItem x = Just x
  getItem _ = Nothing

updatePos :: SourcePos -> Text -> [Text] -> SourcePos
updatePos pos _ (_:_) = incSourceColumn pos 1
updatePos pos _ [] = pos

extractRows :: Cursor -> [Text]
extractRows rowCursor = L.filter (\x -> strip x /= Data.Text.empty) (rowCursor $// content)

nqRows :: BL.ByteString -> [[Text]]
nqRows nqcontents = L.map extractRows ((fromDocument (parseLBS nqcontents)) $// laxElement "tr")

holdings :: [[Text]] -> [Holding]
holdings rows = catMaybes $ fmap parseHoldingRow rows

main :: IO ()
main = do
  args <- getArgs
  nqcontents <- BL.readFile $ L.head args
  mapM_ print (L.take 100 (holdings (nqRows nqcontents)))
