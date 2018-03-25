{-# LANGUAGE DeriveGeneric #-}
module Types
  ( Question(number, previous)
  , Result(signal, result, score, message)
  ) where

import           Data.Aeson   (FromJSON)
import           GHC.Generics (Generic)

data Question =
  Question { number :: Int, previous :: Maybe String }
  deriving (Show, Generic)

instance FromJSON Question

data Result =
  Result { signal :: String, result :: String, score :: Int, message :: String }
  deriving (Show, Generic)

instance FromJSON Result
