Contributing to Clutter
=======================

The usual workflow for contributions should be:

 1. Fork the repository
 2. Create a branch (`git checkout -b my_work`)
 3. Commit your changes (`git commit -am "Added my awesome feature"`)
 4. Push to the branch (`git push origin my_work`)
 5. Open a new merge request
 6. Sit back, relax and wait for feedback and eventual merge

General notes and rules on Clutter core hacking;

 - Follow the [CODING STYLE](./CODING_STYLE.txt) document.

 - *Really* follow the [CODING STYLE](./CODING_STYLE.txt) document.

 - All non static public API funcs should be documented in the source files
   via gtk-doc. Structures, enumerations and macros should be documented in
   the header files.

 - All non-trivial static and private API should be documented, especially
   the eventual lifetime handling of the arguments/return values or locking
   of mutexes.

 - Properties should always be in floating point (never fixed point).
   The preferred precision is double for angles, and single precision
   for size and position -- especially if they have to be passed down
   to Cogl.

 - Properties should use pixels whenever is possible. Dimensional and
   positional properties can also use `ClutterParamSpecUnits` to define
   the units-based logical values with a unit type.

 - The nick and blurb of properties in public classes should be marked for
   translation by using the `P_()` macro defined in the `clutter-private.h`
   header file.

 - Public entry points must always check their arguments with
   `g_return_if_fail()` or `g_return_val_if_fail()`.

 - Private entry points should use `g_assert()` or `g_warn_if_fail()` to
   verify internal state; do not use `g_return_if_fail()` or
   `g_return_val_if_fail()` as they might be compiled out.

 - If you need to share some state variable across source files use
   `ClutterContext` and a private accessor.

 - Private, non-static functions must begin with an underscore and
   be declared inside `clutter-private.h`.

 - Don't add direct GL calls but add API to Cogl (both GL and GL|ES
   versions if possible).

 - Use the `CLUTTER_NOTE()` macro for debug statements in Clutter. If
   necessary, add a value inside `ClutterDebugFlags` to specify
   the debug section.

 - New features should also include an exhaustive test unit under
   tests/conform and, possibly, a user-interactive test under
   tests/interactive.

 - When committing, use the standard git commit message format:

```
Short explanation of the commit

Longer explanation explaining exactly what's changed, whether any
external or private interfaces changed, what bugs were fixed (with bug
tracker reference if applicable) and so forth. Be concise but not too
brief. Don't be afraid of using UTF-8, or even ASCII art.
```

 - Always add a brief description of the commit to the **first** line of
   the commit and terminate by two newlines (it will work without the
   second newline, but that is not nice for the interfaces).

     short description          - MUST be less than 72 characters
     <newline>                  - MANDATORY empty line
     long description           - Each line MUST be less than 76 characters

 - Do NOT put the commit message on the short description line. One line
   commit messages should be avoided, unless they can be **fully** explained
   in less than 72 characters (e.g. "Fix typo in
   `clutter_actor_create_pango_context()` docs").

 - The brief description might optionally have a "tag", i.e. a word or two
   followed by a color, detailing what part of the repository the commit
   affected, e.g.:

```
      alpha: Add :mode property
      text: Emit ::cursor-event only on changes
```

 - The tag counts as part of overall character count, so try using
   a short word. Optionally, you can also use the `[tag]` form.

 - Build environment fixes should use the `build` tag.

 - Think of the commit message as an email sent to the maintainers explaining
   "what" you did and, more importantly, "why" you did it. The "how" is not
   important, since "git show" will show the patch inlined with the commit
   message.
