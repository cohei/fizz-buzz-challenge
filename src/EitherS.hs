{-# LANGUAGE PatternSynonyms #-}
module EitherS
  ( EitherS(S, unS)
  , pattern LeftS, pattern RightS
  ) where

import           Data.Semigroup (Semigroup ((<>)))

newtype EitherS a b = S { unS :: Either a b }
  deriving (Show)

pattern LeftS x = S (Left x)
pattern RightS x = S (Right x)

instance Semigroup b => Semigroup (EitherS a b) where
  RightS x <> RightS y = RightS (x <> y)
  S x      <> S y      = S (x <> y)
