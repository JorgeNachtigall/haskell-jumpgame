{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_trabalhoPF (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/bin"
libdir     = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/lib/x86_64-osx-ghc-8.6.5/trabalhoPF-0.1.0.0-OPryFs1uDDDHx33oJzSsb-trabalhoPF"
dynlibdir  = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/share/x86_64-osx-ghc-8.6.5/trabalhoPF-0.1.0.0"
libexecdir = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/libexec/x86_64-osx-ghc-8.6.5/trabalhoPF-0.1.0.0"
sysconfdir = "/Users/jorge/Documents/haskell/trabalhoPF/.cabal-sandbox/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "trabalhoPF_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "trabalhoPF_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "trabalhoPF_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "trabalhoPF_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "trabalhoPF_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "trabalhoPF_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
