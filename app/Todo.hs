{-# LANGUAGE OverloadedStrings #-}

module Todo where

import Data.Text (Text)
import qualified Data.Text as T
import Data.Void
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

data Todo = Todo
  { prefix :: Text,
    keyword :: Text,
    title :: Text,
    body :: Text,
    filename :: Text,
    line :: Int
  }
  deriving (Show)

type Parser = Parsec Void Text

todoParser :: Parser Todo
todoParser = do
  prefix <- parsePrefix
  keyword <- parseKeyword
  title <- parseTitle
  body <- parseBody prefix
  pure $ Todo prefix keyword title body "" 0

parsePrefix :: Parser Text
parsePrefix = do
  prefix <- manyTill printChar (lookAhead parseKeyword)
  return . T.strip . T.pack $ prefix

-- TODO: Consider moving these to a common Parser module?
--       actually, we may not want to use this...
sc :: Parser ()
sc = L.space space1 empty empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: Text -> Parser Text
symbol = L.symbol sc

keywords :: [Text]
keywords = ["TODO"]

parseKeyword :: Parser Text
parseKeyword = do
  keyword <- choice $ map chunk keywords
  char ':'
  pure keyword

parseTitle :: Parser Text
parseTitle = T.strip <$> T.pack <$> manyTill printChar eol

parseBody :: Text -> Parser Text
parseBody prefix = ""
