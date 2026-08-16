%%
%%  Ispell interface for dictionaires-common
%%
%% This file is an adapted version of ispell.sl distributed originally
%% with Jed, for use in Debian.  It introduces a new function
%% "ispell_dictionary", that allows the user to change the ispell
%% dictionary.  It is used in conjunction with
%% /etc/jed-init.d/50dictionaries-common.sl, which initializes the
%% relevant variables as a function of the ispell dicitonary packages
%% installed in the system.
%%
%% It was modified by Rafael Laboissiere <rafael@debian.org> on
%% Tue Nov 27 14:34:40 CET 2001
%%
%% This file is part of the dictionaries-common package.
%% It is Copyright (c) 1999-2009 Rafael Laboissiere, and release under
%% the terms of the GNU General Public License (version 2 or later).


define ispell_change_dictionary()
{
  Ispell_Dictionary =
    read_with_completion (Ispell_Dicts, "Use new ispell dictionary:",
                          Ispell_Dictionary, "", 's');
}

define ispell()
{
   variable ibuf, buf, file, letters, num_win, old_buf;
   variable word, cmd, p, num, n, new_word;

#ifdef OS2
   file = make_tmp_file("jedt");
#else
   file = make_tmp_file("/tmp/jed_ispell");
#endif
   letters = Ispell_Letters [Ispell_Dictionary];

   ibuf = " *ispell*";
   buf = whatbuf();

   skip_chars(letters); bskip_chars(letters); push_mark(); % push_mark();

   n = POINT;
   skip_chars(letters);
   if (POINT == n)
     {
	pop_mark_0 (); %pop_mark_0 ();
	return;
     }

   %word = bufsubstr();
#ifdef MSDOS
   () = system(sprintf("echo %s | ispell -a > %s", bufsubstr(), file));
#else
   variable extchr = " ";
   if (Ispell_Extchar [Ispell_Dictionary] != "")
     extchr = " -T \"" + Ispell_Extchar [Ispell_Dictionary] + "\" ";
   if (pipe_region("ispell -d " + Ispell_Hash_Name [Ispell_Dictionary]
                   + extchr + Ispell_Options [Ispell_Dictionary]
                   + " -a > " + file))
     error ("ispell process returned a non-zero exit status.");
#endif

   setbuf(ibuf); erase_buffer();
   () = insert_file(file);
   () = delete_file(file);

   %%
   %% parse output
   %%
   bob();
   if (looking_at_char('@'))   % ispell header
     {
	del_through_eol ();
     }

   if (looking_at_char('*') or looking_at_char('+'))
     {
	message ("Correct");   % '+' ==> is derived from
	bury_buffer (ibuf);
	return;
     }

   if (looking_at_char('#'))
     {
      	bury_buffer (ibuf);
	return (message("No clue."));
     }

   del(); trim(); eol_trim(); bol();
   if (ffind_char (':'))
     {
	skip_chars(":\t ");
	push_mark();
	bol();
	del_region();
     }

   insert ("(0) ");
   n = 1;
   while (ffind_char (' '))
     {
	go_left_1 ();
	if (looking_at_char(',')) del(); else go_right_1 ();
	trim(); newline();
	vinsert ("(%d) ", n, 1);
	++n;
     }

   bob();
   num_win = nwindows();
   pop2buf(buf);
   old_buf = pop2buf_whatbuf(ibuf);

   ERROR_BLOCK
     {
	sw2buf(old_buf);
	pop2buf(buf);
	if (num_win == 1) onewindow();
	bury_buffer(ibuf);
     }

   set_buffer_modified_flag(0);
   num = read_mini("Enter choice. (^G to abort)", "0", Null_String);
   num = sprintf ("(%s)", num);

   if (fsearch(num))
     {
	() = ffind_char (' '); trim();
	push_mark_eol(); trim(); new_word = bufsubstr();
	set_buffer_modified_flag(0);
	sw2buf(old_buf);
	pop2buf(buf);
	bskip_chars(letters); push_mark();
	skip_chars(letters); del_region();
	insert(new_word);
     }
   else
     {
	sw2buf(old_buf);
	pop2buf(buf);
     }
   if (num_win == 1) onewindow();
   bury_buffer(ibuf);
}

