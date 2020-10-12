{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where

import qualified Data.Text as T
import Control.Monad (liftM2)
import Control.Applicative ((<|>))
import Dhall
import System.Directory (XdgDirectory (XdgConfig), doesPathExist, getXdgDirectory)
import System.Environment (lookupEnv)
import System.FilePath

opeDir :: FilePath
opeDir = "ope"

tokenFilePath :: FilePath
tokenFilePath = "token.dhall"

token :: IO (Maybe T.Text)
token = liftM2 (<|>) envToken fileToken

data Token = Token {githubToken :: Text}
  deriving (Generic, Show)

instance FromDhall Token

-- | Read token from env var GITHUB_TOKEN
envToken :: IO (Maybe T.Text)
envToken = (fmap . fmap) T.pack $ lookupEnv "GITHUB_TOKEN"

-- | Read token from ~/.config/ope/token.dhall
fileToken :: IO (Maybe T.Text)
fileToken = do
  configFile <- (</> tokenFilePath) <$> getXdgDirectory XdgConfig opeDir
  exists <- doesPathExist configFile
  if exists
    then return . githubToken <$> input auto (T.pack configFile)
    else return Nothing
