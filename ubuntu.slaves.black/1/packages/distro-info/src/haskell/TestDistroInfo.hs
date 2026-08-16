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

module TestDistroInfo (main) where

import Data.List
import Data.Time
import System.Exit

import Test.HUnit
import Text.CSV

import DistroInfo

date1 :: Day
date1 = fromGregorian 2011 01 10
date2 :: Day
date2 = fromGregorian 2016 02 28
date3 :: Day
date3 = fromGregorian 2020 06 29

------------------
-- Debian tests --
------------------

testDebianAll :: [DebianEntry] -> Test
testDebianAll d = TestCase (assertEqual "Debian all" [] (expected \\ result))
  where
    expected = ["buzz", "rex", "bo", "hamm", "slink", "potato", "woody",
                "sarge", "etch", "lenny", "squeeze", "sid", "experimental"]
    result = map debSeries $ debianAll date1 d

testDebianDevel :: [DebianEntry] -> Test
testDebianDevel d = TestCase (assertEqual "Debian devel" expected result)
  where
    expected = ["sid"]
    result = map debSeries $ debianDevel date1 d

testDebianOldstable :: [DebianEntry] -> Test
testDebianOldstable d = TestCase (assertEqual "Debian oldstable" expected result)
  where
    expected = ["etch"]
    result = map debSeries $ debianOldstable date1 d

testDebianStable :: [DebianEntry] -> Test
testDebianStable d = TestCase (assertEqual "Debian stable" expected result)
  where
    expected = ["lenny"]
    result = map debSeries $ debianStable date1 d

testDebianSupported :: [DebianEntry] -> Test
testDebianSupported d = TestCase (assertEqual "Debian supported" expected result)
  where
    expected = ["lenny", "squeeze", "sid", "experimental"]
    result = map debSeries $ debianSupported date1 d

testDebianSupportedLTS :: [DebianEntry] -> Test
testDebianSupportedLTS d = TestCase (assertEqual "Debian LTS" expected result)
  where
    expected = ["squeeze"]
    result = map debSeries $ debianSupportedLTS date2 d

testDebianSupportedELTS :: [DebianEntry] -> Test
testDebianSupportedELTS d = TestCase (assertEqual "Debian ELTS" expected result)
  where
    expected = ["wheezy"]
    result = map debSeries $ debianSupportedELTS date3 d

testDebianTesting :: [DebianEntry] -> Test
testDebianTesting d = TestCase (assertEqual "Debian testing" expected result)
  where
    expected = ["squeeze"]
    result = map debSeries $ debianTesting date1 d

testDebianUnsupported :: [DebianEntry] -> Test
testDebianUnsupported d = TestCase (assertEqual "Debian unsupported" expected result)
  where
    expected = ["buzz", "rex", "bo", "hamm", "slink", "potato", "woody",
                "sarge", "etch"]
    result = map debSeries $ debianUnsupported date1 d

------------------
-- Ubuntu tests --
------------------

testUbuntuAll :: [UbuntuEntry] -> Test
testUbuntuAll u = TestCase (assertEqual "Ubuntu all" [] (expected \\ result))
  where
    expected = ["warty", "hoary", "breezy", "dapper", "edgy", "feisty",
                "gutsy", "hardy", "intrepid", "jaunty", "karmic", "lucid",
                "maverick", "natty"]
    result = map ubuSeries $ ubuntuAll date1 u

testUbuntuDevel :: [UbuntuEntry] -> Test
testUbuntuDevel u = TestCase (assertEqual "Ubuntu devel" expected result)
  where
    expected = ["natty"]
    result = map ubuSeries $ ubuntuDevel date1 u

testUbuntuLTS :: [UbuntuEntry] -> Test
testUbuntuLTS u = TestCase (assertEqual "Ubuntu LTS" expected result)
  where
    expected = ["lucid"]
    result = map ubuSeries $ ubuntuLTS date1 u

testUbuntuStable :: [UbuntuEntry] -> Test
testUbuntuStable u = TestCase (assertEqual "Ubuntu stable" expected result)
  where
    expected = ["maverick"]
    result = map ubuSeries $ ubuntuStable date1 u

testUbuntuSupported :: [UbuntuEntry] -> Test
testUbuntuSupported u = TestCase (assertEqual "Ubuntu supported" expected result)
  where
    expected = ["dapper", "hardy", "karmic", "lucid", "maverick", "natty"]
    result = map ubuSeries $ ubuntuSupported date1 u

testUbuntuSupportedESM :: [UbuntuEntry] -> Test
testUbuntuSupportedESM u = TestCase (assertEqual "Ubuntu ESM" expected result)
  where
    expected = ["precise", "trusty", "xenial"]
    result = map ubuSeries $ ubuntuSupportedESM date2 u

testUbuntuUnsupported :: [UbuntuEntry] -> Test
testUbuntuUnsupported u = TestCase (assertEqual "Ubuntu unsupported" expected result)
  where
    expected = ["warty", "hoary", "breezy", "edgy", "feisty", "gutsy",
                "intrepid", "jaunty"]
    result = map ubuSeries $ ubuntuUnsupported date1 u

-----------
-- Tests --
-----------

tests :: [DebianEntry] -> [UbuntuEntry] -> Test
tests d u = TestList [
    testDebianAll d,
    testDebianDevel d,
    testDebianSupportedLTS d,
    testDebianSupportedELTS d,
    testDebianOldstable d,
    testDebianStable d,
    testDebianSupported d,
    testDebianTesting d,
    testDebianUnsupported d,
    testUbuntuAll u,
    testUbuntuDevel u,
    testUbuntuLTS u,
    testUbuntuStable u,
    testUbuntuSupported u,
    testUbuntuSupportedESM u,
    testUbuntuUnsupported u
  ]

main :: IO ()
main = do
  maybeDebianCsv <- parseCSVFromFile "/usr/share/distro-info/debian.csv"
  maybeUbuntuCsv <- parseCSVFromFile "/usr/share/distro-info/ubuntu.csv"
  case maybeDebianCsv of
    Left errorMsg -> error $ show errorMsg
    Right csvDebianData ->
      case maybeUbuntuCsv of
        Left errorMsg -> error $ show errorMsg
        Right csvUbuntuData -> do
          count <- runTestTT $ tests (debianEntry csvDebianData)
                                     (ubuntuEntry csvUbuntuData)
          case count of
            Counts _ _ 0 0 -> exitWith ExitSuccess
            _ -> exitWith $ ExitFailure 1
