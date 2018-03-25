{-# LANGUAGE PatternSynonyms #-}
module Moi
  ( fizzBuzzMoi
  ) where

import           Data.Semigroup ((<>))

import           EitherS        (EitherS (unS), pattern LeftS, pattern RightS)

rule :: Int -> String -> Int -> EitherS Int String
rule d s i
  | i `mod` d == 0 = RightS s
  | otherwise      = LeftS i

fizz, buzz, moi :: Int -> EitherS Int String
fizz = rule 3 "Fizz"
buzz = rule 5 "Buzz"
moi  = rule 7 "Moi"

fizzBuzzMoi :: Int -> String
fizzBuzzMoi = either show id . unS . (fizz <> buzz <> moi)
