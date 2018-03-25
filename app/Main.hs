{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.Aeson         (Value, decode, encode, object, (.=))
import           Data.Maybe         (fromJust)
import           Data.String        (fromString)
import           Network.URI        (parseURI, uriAuthority, uriPath,
                                     uriRegName)
import           Network.WebSockets (ClientApp, Connection, WebSocketsData,
                                     receiveData, sendTextData)
import           System.Environment (getEnv)
import           Wuss               (runSecureClient)

import           Moi                (fizzBuzzMoi)
import           Types              (Question (number), Result (message))

main :: IO ()
main = do
  (hostName, path) <- connectionInfo

  runSecureClient hostName 443 path $ \connection -> do
    start connection
    result <- answering connection
    putStrLn $ message result

connectionInfo :: IO (String, String)
connectionInfo = do
  maybeUri <- parseURI <$> getEnv "FIZZBUZZ_CHALLENGE_URI"

  return $ fromJust $ do
    uri <- maybeUri
    authority <- uriAuthority uri
    return (uriRegName authority, uriPath uri)

start :: Connection -> IO ()
start connection = sendTextData connection $ encode startMessage

startMessage :: Value
startMessage = object ["signal" .= ("start" :: Value)]

answering :: Connection -> IO Result
answering = fmap (fromJust . decode) . loop (fmap (encode . answer) . decode)

answer :: Question -> Value
answer question = object ["answer" .= (fromString (fizzBuzzMoi (number question)) :: Value)]

loop :: (WebSocketsData a, WebSocketsData b) => (a -> Maybe b) -> Connection -> IO a
loop f connection = do
  message <- receiveData connection

  case f message of
    Nothing -> return message
    Just x -> do
      sendTextData connection x
      loop f connection
