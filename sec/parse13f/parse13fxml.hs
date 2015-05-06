{-# LANGUAGE Arrows, NoMonomorphismRestriction #-}
module Main
where

import Text.XML.HXT.Core
{-
main :: IO ()
main
    = do
      runX ( application  "t13f.xml" )
      return ()
-}
    
main = do
  holdings <- runX (readDocument [withValidate no] "t13f.xml" 
                    >>> getInfoTable)
  print holdings
     
           
application	:: String -> IOSArrow b Int
application src
    = readDocument [] src
      >>>
      processChildren (selectAllText `when` isElem)
      >>>
      writeDocument [] "-"
      >>>
      getErrStatus
      
      
selectAllText	:: ArrowXml a => a XmlTree XmlTree
selectAllText
    = deep isText
      

getInfoTable = deep (isElem >>> hasName "infoTable") >>>
  proc x -> do
    issuer <- getText <<< getChildren <<< deep (hasName "nameOfIssuer") -< x
    cusip <- getText <<< getChildren <<< deep (hasName "cusip") -< x
    value <- getText <<< getChildren <<< deep (hasName "value") -< x
    returnA -< (issuer, cusip, value)
    
{-
	<infoTable>
		<nameOfIssuer>ACCENTURE PLC</nameOfIssuer>
		<titleOfClass>COM</titleOfClass>
		<cusip>00B4BNMY3</cusip>
		<value>57212</value>
		<shrsOrPrnAmt>
			<sshPrnamt>795046</sshPrnamt>
			<sshPrnamtType>SH</sshPrnamtType>
		</shrsOrPrnAmt>
		<investmentDiscretion>SOLE</investmentDiscretion>
		<otherManager>NONE</otherManager>
		<votingAuthority>
			<Sole>795046</Sole>
			<Shared>0</Shared>
			<None>0</None>
		</votingAuthority>
	</infoTable>
-}
