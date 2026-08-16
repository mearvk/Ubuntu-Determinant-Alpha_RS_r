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

module DistroInfo (DebianEntry, debVersion, debSeries, debFull,
                   debianEntry,
                   debianAll,
                   debianDevel,
                   debianOldstable,
                   debianStable,
                   debianSupported,
                   debianSupportedLTS,
                   debianSupportedELTS,
                   debianTesting,
                   debianUnsupported,
                   UbuntuEntry, ubuVersion, ubuSeries, ubuFull,
                   ubuntuEntry,
                   ubuntuAll,
                   ubuntuDevel,
                   ubuntuLTS,
                   ubuntuStable,
                   ubuntuSupported,
                   ubuntuSupportedESM,
                   ubuntuUnsupported,
                  ) where

import Data.Map hiding (map, filter, lookup)
import qualified Data.Map as Map
import Data.List
import Data.Time

import Text.CSV

-- | Represents one Debian release data set
-- (corresponds to one row of the debian.csv file).
data DebianEntry = DebianEntry { debVersion :: String,
                                 debCodename :: String,
                                 debSeries :: String,
                                 debCreated :: Day,
                                 debRelease :: Maybe Day,
                                 debEol :: Maybe Day,
                                 debEolLTS :: Maybe Day,
                                 debEolELTS :: Maybe Day
                               } deriving(Eq, Show)

-- | Represents one Ubuntu release data set
-- (corresponds to one row of the ubuntu.csv file).
data UbuntuEntry = UbuntuEntry { ubuVersion :: String,
                                 ubuCodename :: String,
                                 ubuSeries :: String,
                                 ubuCreated :: Day,
                                 ubuRelease :: Day,
                                 ubuEol :: Day,
                                 ubuEolServer :: Maybe Day,
                                 ubuEolESM :: Maybe Day
                               } deriving(Eq, Show)

-- | Splits a string by a given character (similar to the Python split function)
-- splitS '-' "2010-05-23" = ["2010", "05", "23"]
splitS :: Eq a => a -> [a] -> [[a]]
splitS _ [] = [[]]
splitS c (x : xs) =
  let
    rest = splitS c xs
  in
    if x == c
    then [] : rest
    else (x : head rest) : tail rest

-- | Convert a given date string in ISO 8601 format into a Day
convertDate :: String -> Day
convertDate date =
  case map (read :: String -> Int) (splitS '-' date) of
    year : month : day : [] -> fromGregorian (toInteger year) month day
    year : month : [] ->
      if month == 12
      then fromGregorian (toInteger year) month 31
      else addDays (-1) (fromGregorian (toInteger year) (month + 1) 1)
    _ -> error ("Date \"" ++ date ++ "\" not in ISO 8601 format.")

-- | Drop empty rows from CSV files
dropEmptyRows :: [Record] -> [Record]
dropEmptyRows = filter (\ r -> r /= [""])

-- | Converts a String into a Day if it exists
maybeDate :: Maybe String -> Maybe Day
maybeDate Nothing = Nothing
maybeDate (Just date) = Just (convertDate date)

-- | Converts a given CSV data into a list of Ubuntu entries
ubuntuEntry :: CSV -> [UbuntuEntry]
ubuntuEntry [] = error "Empty CSV file."
ubuntuEntry (heading : content) =
  map (toEntry . fromList . zip heading) $ dropEmptyRows content
  where
    toEntry :: Map String String -> UbuntuEntry
    toEntry m =
      UbuntuEntry (m ! "version") (m ! "codename") (m ! "series")
                  (convertDate $ m ! "created") (convertDate $ m ! "release")
                  (convertDate $ m ! "eol")
                  (maybeDate $ Map.lookup "eol-server" m)
                  (maybeDate $ Map.lookup "eol-esm" m)

-- | Converts a given CSV data into a list of Debian entries
debianEntry :: CSV -> [DebianEntry]
debianEntry [] = error "Empty CSV file."
debianEntry (heading : content) =
  map (toEntry . fromList . zip heading) $ dropEmptyRows content
  where
    toEntry :: Map String String -> DebianEntry
    toEntry m =
      DebianEntry (m ! "version") (m ! "codename") (m ! "series")
                  (convertDate $ m ! "created")
                  (maybeDate $ Map.lookup "release" m)
                  (maybeDate $ Map.lookup "eol" m)
                  (maybeDate $ Map.lookup "eol-lts" m)
                  (maybeDate $ Map.lookup "eol-elts" m)

-------------------
-- Debian Filter --
-------------------

-- | Return the latest entry of a given list.
latest :: Int -> [a] -> [a]
latest i m =
  if length m < i
  then error "Distribution data outdated."
  else [m !! (length m - i)]

-- | List all known Debian distributions.
debianAll :: Day -> [DebianEntry] -> [DebianEntry]
debianAll _ = id

-- | Get latest development distribution based on the given date.
debianDevel :: Day -> [DebianEntry] -> [DebianEntry]
debianDevel date = latest 2 . filter isUnreleased
  where
    isUnreleased DebianEntry { debCreated = created, debRelease = release } =
      date >= created && maybe True (date <=) release

-- | Get oldstable Debian distribution based on the given date.
debianOldstable :: Day -> [DebianEntry] -> [DebianEntry]
debianOldstable date = latest 2 . filter isReleased
  where
    isReleased DebianEntry { debRelease = release } =
      maybe False (date >=) release

-- | Get latest stable distribution based on the given date.
debianStable :: Day -> [DebianEntry] -> [DebianEntry]
debianStable date = latest 1 . filter isReleased
  where
    isReleased DebianEntry { debRelease = release, debEol = eol } =
      maybe False (date >=) release && maybe True (date <=) eol

-- | Get list of all supported distributions based on the given date.
debianSupported :: Day -> [DebianEntry] -> [DebianEntry]
debianSupported date = filter isSupported
  where
    isSupported DebianEntry { debCreated = created, debEol = eol } =
      date >= created && maybe True (date <=) eol

-- | Get list of all LTS supported distributions based on the given date.
debianSupportedLTS :: Day -> [DebianEntry] -> [DebianEntry]
debianSupportedLTS date = filter isSupportedLTS
  where
    isSupportedLTS DebianEntry { debCreated = created, debEol = eol,
                                 debEolLTS = eol_lts } =
      date >= created && maybe False (date >) eol && maybe False (date <=) eol_lts

-- | Get list of all ELTS supported distributions based on the given date.
debianSupportedELTS :: Day -> [DebianEntry] -> [DebianEntry]
debianSupportedELTS date = filter isSupportedELTS
  where
    isSupportedELTS DebianEntry { debCreated = created, debEolLTS = eol_lts,
                                  debEolELTS = eol_elts } =
      date >= created && maybe False (date >) eol_lts && maybe False (date <=) eol_elts

-- | Get latest testing Debian distribution based on the given date.
debianTesting :: Day -> [DebianEntry] -> [DebianEntry]
debianTesting date = filter isUnreleased
  where
    isUnreleased DebianEntry { debVersion = version, debCreated = created,
                               debRelease = release } =
      date >= created && maybe True (date <=) release && version /= ""

-- | Get list of all unsupported distributions based on the given date.
debianUnsupported :: Day -> [DebianEntry] -> [DebianEntry]
debianUnsupported date = filter isUnsupported
  where
    isUnsupported DebianEntry { debCreated = created, debEol = eol } =
      date >= created && maybe False (date >) eol

-------------------
-- Ubuntu Filter --
-------------------

-- | Return the newest entry (based on the release date) of a given list.
ubuntuNewest :: [UbuntuEntry] -> [UbuntuEntry]
ubuntuNewest [] = error "Distribution data outdated."
ubuntuNewest (a : []) = [a]
ubuntuNewest (a : b : rs) =
  if ubuRelease a > ubuRelease b
  then ubuntuNewest (a : rs)
  else ubuntuNewest (b : rs)

-- | Evaluates if a given Ubuntu release is already release and still supported.
ubuntuIsReleased :: Day -> UbuntuEntry -> Bool
ubuntuIsReleased date UbuntuEntry { ubuRelease = release, ubuEol = eol,
                                    ubuEolServer = eolServer } =
  date >= release && (date <= eol || maybe False (date <=) eolServer)

-- | List all known Ubuntu distributions.
ubuntuAll :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuAll _ = id

-- | Get latest development distribution based on the given date.
ubuntuDevel :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuDevel date = ubuntuNewest . filter isUnreleased
  where
    isUnreleased UbuntuEntry { ubuCreated = created, ubuRelease = release } =
      date >= created && date < release

-- | Get latest long term support (LTS) Ubuntu distribution based on the given
-- date.
ubuntuLTS :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuLTS date = ubuntuNewest . filter isLTS . filter (ubuntuIsReleased date)
  where
    isLTS UbuntuEntry { ubuVersion = version } = "LTS" `isInfixOf` version

-- | Get latest stable distribution based on the given date.
ubuntuStable :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuStable date = ubuntuNewest . filter (ubuntuIsReleased date)

-- | Get list of all supported distributions based on the given date.
ubuntuSupported :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuSupported date = filter isSupported
  where
    isSupported UbuntuEntry { ubuCreated = created, ubuEol = eol,
                              ubuEolServer = eolServer } =
      date >= created && (date <= eol || maybe False (date <=) eolServer)

-- | Get list of all ESM supported distributions based on the given date.
ubuntuSupportedESM :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuSupportedESM date = filter isSupportedESM
  where
    isSupportedESM UbuntuEntry { ubuCreated = created, ubuEolESM = eolESM } =
      date >= created && maybe False (date <=) eolESM

-- | Get list of all unsupported distributions based on the given date.
ubuntuUnsupported :: Day -> [UbuntuEntry] -> [UbuntuEntry]
ubuntuUnsupported date = filter isUnsupported
  where
    isUnsupported UbuntuEntry { ubuCreated = created, ubuEol = eol,
                                ubuEolServer = eolServer } =
      date >= created && (date > eol && maybe True (date >) eolServer)

------------
-- Output --
------------

debFull :: DebianEntry -> String
debFull DebianEntry { debVersion = version, debCodename = codename,
                      debSeries = series } =
  if version /= ""
  then "Debian " ++ version ++ " \"" ++ codename ++ "\""
  else "Debian " ++ series

ubuFull :: UbuntuEntry -> String
ubuFull UbuntuEntry { ubuVersion = version, ubuCodename = codename } =
  "Ubuntu " ++ version ++ " \"" ++ codename ++ "\""
