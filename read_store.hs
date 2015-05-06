{-# LANGUAGE ScopedTypeVariables #-}

import Control.Monad
import Database.HDBC
import Database.HDBC.MySQL

import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.UTF8 as BLU
import Data.Csv
import qualified Data.Vector as V
import Data.Binary as B
import Data.Time
import System.Locale
import System.Environment

makeDate d = parseTime defaultTimeLocale "%-m/%-d/%Y" d :: Maybe Day

store_csv :: [String] -> (V.Vector (BL.ByteString, BL.ByteString, BL.ByteString, Maybe Int)) -> IO()
store_csv [user, password, table] v = do
    conn <- connectMySQL defaultMySQLConnectInfo {
              mysqlUser     = user,
              mysqlPassword = password
            }
    stmt <- prepare conn $ "INSERT INTO " ++ table ++ " (call_date, advisor_name, firm_name, crd) VALUES (?, ?, ?, ?)"
    V.forM_ v $ \ (date :: BL.ByteString, advisor :: BL.ByteString, firm :: BL.ByteString, crd :: Maybe Int) ->
      execute stmt [toSql (makeDate (BLU.toString date)), toSql advisor, toSql firm, toSql crd]
    commit conn
                 
main :: IO ()
main = do
    (filename:dbargs) <- getArgs
    csvData <- BL.readFile $ filename
    case Data.Csv.decode HasHeader csvData of
        Left err -> putStrLn err
        Right v -> store_csv dbargs (v :: V.Vector(BL.ByteString, BL.ByteString, BL.ByteString, Maybe Int))
