{- Copyright (C) 2011, Benjamin Drung <bdrung@debian.org>

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-}

module DebianDistroInfo where

import Data.List
import Data.Time
import System.Console.GetOpt
import System.Environment
import System.Exit
import System.IO

import Text.CSV

import DistroInfo

-- | Trim whitespaces from given string (similar to Python function)
trim :: String -> String
trim = reverse . trimLeft . reverse . trimLeft
  where trimLeft = dropWhile (`elem` " \t\n\r")

data Options = Options { optDate :: Day
                       , optFilter :: Maybe (Day -> [DebianEntry] -> [DebianEntry])
                       , optFormat :: DebianEntry -> String
                       }

startOptions :: IO Options
startOptions = do
  today <- getCurrentTime
  return Options { optDate = utctDay today,
                   optFilter  = Nothing,
                   optFormat  = debSeries
                 }

onlyOneFilter :: a
onlyOneFilter = error ("You have to select exactly one of --all, " ++
                       "--devel, --elts, --lts, --oldstable, --stable, " ++
                       "--supported, --testing, --unsupported.")

options :: [OptDescr (Options -> IO Options)]
options =
  let
    debVersionOrSeries e =
      let
        version = debVersion e
      in
        if version /= ""
        then version
        else debSeries e
    readDate arg opt =
      return opt { optDate = parseTimeOrError False defaultTimeLocale "%F" arg }
    printHelp _ =
      do
        prg <- getProgName
        hPutStr stderr ("Usage: " ++ prg ++ " [options]\n\nOptions:")
        hPutStrLn stderr (usageInfo "" options)
        hPutStrLn stderr ("See " ++ prg ++ "(1) for more info.")
        exitWith ExitSuccess
    setFilter debianFilter opt =
      case optFilter opt of
        Nothing -> return opt { optFilter = Just debianFilter }
        Just _ -> onlyOneFilter
  in
    [ Option "h" ["help"] (NoArg printHelp) "show this help message and exit"
    , Option "" ["date"] (ReqArg readDate "DATE")
             "date for calculating the version (default: today)"
    , Option "a" ["all"] (NoArg (setFilter debianAll))
             "list all known versions"
    , Option "d" ["devel"] (NoArg (setFilter debianDevel))
             "latest development version"
    , Option "t" ["testing"] (NoArg (setFilter debianTesting))
             "current testing version"
    , Option "s" ["stable"] (NoArg (setFilter debianStable))
             "latest stable version"
    , Option "o" ["oldstable"] (NoArg (setFilter debianOldstable))
             "latest oldstable version"
    , Option "" ["supported"] (NoArg (setFilter debianSupported))
             "list of all supported versions (including development)"
    , Option "l" ["lts"] (NoArg (setFilter debianSupportedLTS))
             "list of all LTS supported versions"
    , Option "e" ["elts"] (NoArg (setFilter debianSupportedELTS))
             "list of all Extended LTS supported versions"
    , Option "" ["unsupported"] (NoArg (setFilter debianUnsupported))
             "list of all unsupported stable versions"
    , Option "c" ["codename"]
             (NoArg (\ opt -> return opt { optFormat = debSeries }))
             "print the codename (default)"
    , Option "r" ["release"]
             (NoArg (\ opt -> return opt { optFormat = debVersionOrSeries }))
             "print the release version"
    , Option "f" ["fullname"]
             (NoArg (\ opt -> return opt { optFormat = debFull }))
             "print the full name"
    ]

main :: IO ()
main = do
  args <- getArgs
  case getOpt RequireOrder options args of
    (actions, [], []) -> do
      Options { optDate    = date, optFilter  = maybeFilter,
                optFormat  = format } <- foldl (>>=) startOptions actions
      maybeCsv <- parseCSVFromFile "/usr/share/distro-info/debian.csv"
      case maybeFilter of
        Nothing -> onlyOneFilter
        Just debianFilter ->
          case maybeCsv of
            Left errorMsg -> error $ show errorMsg
            Right csvData ->
              let
                result = map format $ debianFilter date $ debianEntry csvData
              in
                putStrLn $ concat $ intersperse "\n" result
    (_, nonOptions, []) ->
      error $ "unrecognized arguments: " ++ unwords nonOptions
    (_, _, msgs) -> error $ trim $ concat msgs
