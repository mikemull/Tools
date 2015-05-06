{-# LANGUAGE OverloadedStrings #-}

module Nq where

import System.Environment
import qualified Data.ByteString.Lazy as BL
import qualified Data.List as L

import Data.Text
import Data.Text.Read (decimal)

import Control.Monad
import Control.Applicative

type Shares = Int
type InvestmentName = Text
type Balance = Int
data Holding = Holding InvestmentName Balance Shares deriving (Show)

data NqParser a = NqParser ([Text] -> Maybe (a,[Text]))

pmap :: (a -> b) -> ([Text] -> (a,[Text])) -> ([Text] -> (b,[Text]))
pmap f p = \ss -> let (a,ss') = p ss 
                  in (f a,ss')

instance Monad NqParser where
  NqParser c1 >>= fc2   =  NqParser (\s0 -> let Just (r,s1) = c1 s0
                                                NqParser c2 = fc2 r in c2 s1)
  return k              =  NqParser (\s -> Just (k,s))


instance Functor NqParser where
    fmap = liftM

instance Applicative NqParser where
    pure = return
    (<*>) = ap


instance MonadPlus NqParser where
  mzero      = NqParser (\cs -> Nothing)
  mplus p q  = NqParser (\cs -> case nqparse p cs of
                            Just (a,cs') -> Just (a,cs')
                            Nothing      -> nqparse q cs)

instance Alternative NqParser where
    empty = mzero
    (<|>) = mplus

item :: NqParser Text
item = NqParser (\cs -> case cs of
                         []     -> Nothing
                         (c:cs) -> Just (c,cs) )
                       
amount :: NqParser Int
amount = do
         ntext <- item
         case decimal (Data.Text.filter (/= ',') ntext) of
                       Left _ -> NqParser (\_ -> Nothing)
                       Right (n,_)  -> return n

holdingRow :: NqParser Holding
holdingRow = balanceRowFootNote <|> balanceRow

balanceRow :: NqParser Holding
balanceRow = do
             invName <- item
             shares <- amount
             balance <- amount
             return $ Holding invName shares balance

balanceRowFootNote :: NqParser Holding
balanceRowFootNote = do
             invName <- item
             _ <- item
             shares <- amount
             balance <- amount
             return $ Holding invName shares balance


nqparse (NqParser p) = p

apply :: NqParser a -> [Text] -> Maybe (a,[Text])
apply p = nqparse (do {p})
