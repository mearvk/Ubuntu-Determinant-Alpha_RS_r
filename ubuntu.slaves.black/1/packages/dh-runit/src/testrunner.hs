{-# LANGUAGE LambdaCase #-}
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import System.Directory
import Text.Printf

-- Overlays and detecting removal
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
-- Test directories are created from files in base directory and overlay. The
-- goal it to make as little copying as possible, without sacrificing
-- correctness.
--
-- Since it can't be assumed, that test directory could be re-used, pristing
-- test directory as tar archive, and re-unpacked on every test invocation.
-- Having pristing test directory in unpacked state would require even less
-- copying, but making Shake detect file removal in base directory and/or
-- overlay is rather complicated: it would require saving list of files during
-- previous invocation, and Shake does not like files being both read and
-- written by same rule.
--
-- This way, change of any source file for pristing tar archive causes whole
-- archive recreation. This is quite unfortunate.

-- Add dependency on dh_runit.
needSources :: Action ()
needSources = do
  need ["dh_runit"]
  dataFiles <- getDirectoryFiles "data" ["//*"]
  need $ map ("data" </>) dataFiles

main :: IO ()
main = shakeArgs shakeOptions $ do
  action $ do
    let checklog t = printf "t/out/%s.log" t
    checks <- getDirectoryDirs "t/checks"
    need $ map checklog checks

  -- See note [Overlays and detecting removal]
  "t/out/*.tar" %> \out -> do
    let check = takeBaseName out
        base = "t/base/default"
        overlay = "t/checks" </> check
    baseFiles    <- getDirectoryFiles base ["//*"]
    overlayFiles <- getDirectoryFiles overlay ["//*"]

    -- FIXME: hard links instead of copyFile' would save copying.
    withTempDir $ \tmpdir -> do
      let doCopy from f = copyFile' (from </> f) (tmpdir </> f)
      forP baseFiles    $ doCopy base
      forP overlayFiles $ doCopy overlay
      cmd_ (Cwd tmpdir) "tar cf ../archive.tar ."
      cmd_ "mv" (tmpdir </> "../archive.tar") out

  "t/out/*.log" %> \out -> do
    let check = takeBaseName out
        tar   = printf "t/out/%s.tar" check
        checkdir  = printf "t/out/%s" check
    need [tar]
    needSources
    cwd <- liftIO getCurrentDirectory

    cmd_ "rm -fr"   checkdir
    cmd_ "mkdir -p" checkdir -- FIXME: avoid external process,
    cmd_ (Cwd checkdir) "tar xf" (".." </> check <.> "tar")
    cmd_ (Cwd checkdir) "chmod +x check"
    opts <- getEnv "AUTOPKGTEST" >>= \case
      Just _  -> pure []
      Nothing -> pure $
                 [ AddEnv "DH_AUTOSCRIPTDIR" cwd
                 , AddEnv "DH_RUNIT_DATADIR" $ cwd </> "data"
                 , AddPath [cwd] []
                 ] {- local test -}
    command_ (Cwd checkdir : opts) "dh_runit" []
    cmd_ (Cwd checkdir) (FileStdout out) "prove ./check"
