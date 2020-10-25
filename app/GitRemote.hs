module GitRemote where

import System.Directory (doesPathExist, makeAbsolute)
import System.FilePath ((</>), joinPath, splitPath)

-- | maxDepth is the maximum number of directories we will search up for the .git directory
maxDepth :: Int
maxDepth = 128

gitDir :: FilePath
gitDir = ".git"

findGitDir :: FilePath -> IO (Maybe FilePath)
findGitDir path = do
  absolutePath <- makeAbsolute path
  go absolutePath 0
  where
    go "" _ = return Nothing
    go p depth
      | depth > maxDepth = return Nothing
      | otherwise = do
        exists <- doesPathExist $ (p </> gitDir)
        if exists then (return . Just $ p </> gitDir) else go (joinPath . init . splitPath $ p) (depth + 1)
