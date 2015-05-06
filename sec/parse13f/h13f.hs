
import Network.HTTP
import Data.List
import Data.List.Split

processTable :: [String] -> [[String]]
processTable y = map (splitOn "\t") (dropWhile (\x -> not (isPrefixOf "NAME OF ISSUER" x)) y)

main :: IO()
main = 
  do
    rsp <- simpleHTTP (getRequest "http://www.sec.gov/Archives/edgar/data/1134813/000113481312000055/0001134813-12-000055.txt")
    rspbody <- (getResponseBody rsp)
    mapM_ putStrLn $ concat (processTable ( lines rspbody ))
