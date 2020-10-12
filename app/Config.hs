{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where

import qualified Data.Text as T
import Debug.Trace
import Dhall
import System.Directory (XdgDirectory (XdgConfig), doesPathExist, getXdgDirectory)
import System.Environment (lookupEnv)
import System.FilePath

opeDir :: FilePath
opeDir = "ope"

tokenFilePath :: FilePath
tokenFilePath = "token.dhall"

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
