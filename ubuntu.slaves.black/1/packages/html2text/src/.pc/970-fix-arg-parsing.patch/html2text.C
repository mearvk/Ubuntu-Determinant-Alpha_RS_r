
 /***************************************************************************/

/*
 * Portions Copyright (c) 1999 GMRS Software GmbH
 * Carl-von-Linde-Str. 38, D-85716 Unterschleissheim, http://www.gmrs.de
 * All rights reserved.
 *
 * Author: Arno Unkrig <arno@unkrig.de>
 */
 
/* This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License in the file COPYING for more details.
 */

 /***************************************************************************/

/*
 * Changes to version 1.2.2 were made by Martin Bayer <mbayer@zedat.fu-berlin.de>
 * Dates and reasons of modifications:
 * Fre Jun  8 19:00:26 CEST 2001: new image handling
 * Thu Oct  4 21:42:24 CEST 2001: ported to g++ 3.0, bugfix for '-' as synonym for STDIN
 * Mon Jul 22 13:48:26 CEST 2002: Made finaly reading from STDIN work.
 * Sat Sep 14 15:04:09 CEST 2002: Added plain ASCII output patch by Bela Lubkin
 * Wed Jul  2 22:08:45 CEST 2003: ported to g++ 3.3
 */
  
 /***************************************************************************/


#include <iostream>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <string.h>
#include <stdlib.h>

#include <iconv.h>
#include <errno.h>
#include <unistd.h>
#include <langinfo.h>

#include "html.h"
#include "HTMLControl.h"
//#include "urlistream.h"
#include "format.h"

#define stringify(x) stringify2(x)
#define stringify2(x) #x

/* ------------------------------------------------------------------------- */
using std::ifstream;
using std::stringstream;
using std::istream_iterator;
using std::ostream_iterator;
using std::noskipws;

class MyParser : public HTMLControl {

public:
  enum { PRINT_AS_ASCII, UNPARSE, SYNTAX_CHECK };
  string meta_encoding;

  MyParser(
    istream &is_,
    bool       debug_scanner_,
    bool       debug_parser_,
    ostream    &os_,
    int        mode_,
    int        width_,
    const char *file_name_
  ) :
    HTMLControl(is_, debug_scanner_, debug_parser_),
    os(os_),
    mode(mode_),
    width(width_),
    file_name(file_name_)
  {}

private:
  /*virtual*/ void yyerror(const char *);
  /*virtual*/ void process(const Document &);

  ostream &os;
  int     mode;
  int     width;
  string  file_name;
};

/*virtual*/ void
MyParser::yyerror(const char *p)
{

  /*
   * Swallow parse error messages if not in "syntax check" mode.
   */
  if (mode != SYNTAX_CHECK && !strcmp(p, "parse error")) return;

  std::cerr
    << "File \""
    << file_name
    << "\", line "
    << current_line
    << ", column "
    << current_column
    << ": "
    << p
    << std::endl;
}

/*virtual*/ void
MyParser::process(const Document &document)
{
  list<auto_ptr<Meta> >::const_iterator i;
  for(i = document.head.metas.begin(); i != document.head.metas.end(); ++i) {
    bool exists = false;
    get_attribute(i->get()->attributes.get(), "http-equiv", &exists);
    if (exists) {
      string content = get_attribute(i->get()->attributes.get(), "content", "");
	  char to_find[] = "charset=";
	  string::size_type found_pos = content.find(to_find);
	  if (found_pos != string::npos)
	  {
        this->meta_encoding = content.substr(found_pos + sizeof(to_find) - 1);
	    //std::cerr << this->meta_encoding << std::endl;
	  }
      break;
    }
  }

  switch (mode) {

  case PRINT_AS_ASCII:
    document.format(/*indent_left*/ 0, width, Area::LEFT, os);
    break;

  case UNPARSE:
    document.unparse(os, std::endl);
    break;

  case SYNTAX_CHECK:
    break;

  default:
    std::cerr << "??? Invalid mode " << mode << " ??? " << std::endl;
    exit(1);
    break;
  }
}

bool recode(stringstream& stream, const char* to_encoding, const char* from_encoding)
{
	iconv_t iconv_handle = iconv_open(to_encoding, from_encoding);
	if (iconv_handle != iconv_t(-1))
	{
		stream.seekg(0);
		string input_string = stream.str();
		size_t input_size = input_string.size();
		char* raw_input = new char[input_size+1];
		char* const orig_raw_input = raw_input;
		strcpy(raw_input, input_string.data());
		size_t max_output_size = input_size * 4; // maximum possible overhead
		char* raw_output = new char[max_output_size+1];
		char* const orig_raw_output = raw_output;
		size_t iconv_value =
			iconv(iconv_handle, &raw_input, &input_size, &raw_output, &max_output_size);

		if (iconv_value != (size_t)-1)
		{
			*raw_output = '\0';
			stream.str(string(orig_raw_output));
			/* debug */
			//std::copy(istream_iterator<char>(input_stream), istream_iterator<char>(), ostream_iterator<char>(std::cerr));
		}
		else
		{
			std::cerr << "Input recoding failed due to ";
			if (errno == EILSEQ)
			{
				std::cerr << "invalid input sequence. Unconverted part of text follows." << std::endl;
				std::cerr << raw_input;
			}
			else
			{
				std::cerr << "unknown reason.";
			}
			std::cerr << std::endl;
		}

		delete [] orig_raw_input;
		delete [] orig_raw_output;
		iconv_close(iconv_handle);

		if (iconv_value == (size_t)-1)
		{
			return false;
		}
	}
	else
	{
		if (errno == EINVAL)
		{
			std::cerr << "Recoding from '" << from_encoding
				<< "' to '" << to_encoding << "' is not available." << std::endl;
			std::cerr << "Check that '" << from_encoding
				<< "' is a valid encoding." << std::endl;
		}
		else
		{
			std::cerr << "Error: cannot setup recoding." << std::endl;
		}
		return false;
	}
	return true;
}

/* ------------------------------------------------------------------------- */

static const char *usage = "\
Usage:\n\
  html2text -help\n\
  html2text -version\n\
  html2text [ -unparse | -check ] [ -debug-scanner ] [ -debug-parser ] \\\n\
     [ -rcfile <file> ] [ -style ( compact | pretty ) ] [ -width <w> ] \\\n\
     [ -o <file> ] [ -nobs ] [ -ascii | -utf8 ] [ <input-url> ] ...\n\
Formats HTML document(s) read from <input-url> or STDIN and generates ASCII\n\
text.\n\
  -help          Print this text and exit\n\
  -version       Print program version and copyright notice\n\
  -unparse       Generate HTML instead of ASCII output\n\
  -check         Do syntax checking only\n\
  -debug-scanner Report parsed tokens on STDERR (debugging)\n\
  -debug-parser  Report parser activity on STDERR (debugging)\n\
  -rcfile <file> Read <file> instead of \"$HOME/.html2textrc\"\n\
  -style compact Create a \"compact\" output format (default)\n\
  -style pretty  Insert some vertical space for nicer output\n\
  -width <w>     Optimize for screen widths other than 79\n\
  -o <file>      Redirect output into <file>\n\
  -nobs          Do not use backspaces for boldface and underlining\n\
  -ascii         Use plain ASCII for output instead of ISO-8859-1\n\
  -utf8          Assume both terminal and input stream are in UTF-8 mode\n\
  -nometa        Don't try to recode input using 'meta' tag\n\
";

int use_encoding = ISO8859;

int
main(int argc, char **argv)
{
  if (argc == 2 && !strcmp(argv[1], "-help")) {
    std::cout
      << "This is html2text, version " stringify(VERSION) << std::endl
      << std::endl
      << usage;
    exit(0);
  }

  if (argc == 2 && !strcmp(argv[1], "-version")) {
    std::cout
      << "This is html2text, version " stringify(VERSION) << std::endl
      << std::endl
      << "The latest version can be found at http://userpage.fu-berlin.de/~mbayer/tools/" << std::endl
      << std::endl
      << "This program is distributed in the hope that it will be useful, but WITHOUT" << std::endl
      << "ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS" << std::endl
      << "FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details." << std::endl
      << std::endl;
    exit(0);
  }

  bool       mode              = MyParser::PRINT_AS_ASCII;
  bool       debug_scanner     = false;
  bool       debug_parser      = false;
  const char *home             = getenv("HOME");
  string     rcfile            = string(home ? home : "") + "/.html2textrc";
  const char *style            = "compact";
  int        width             = 79;
  const char *output_file_name = "-";
  bool       use_backspaces    = false;
  bool       use_meta          = true;

  int i;
  for (i = 1; i < argc && argv[i][0] == '-' && argv[i][1]; i++) {
    const char *arg = argv[i];

    if (!strcmp(arg, "-unparse"      )) { mode = MyParser::UNPARSE;                       } else
    if (!strcmp(arg, "-check"        )) { mode = MyParser::SYNTAX_CHECK;                  } else
    if (!strcmp(arg, "-debug-scanner")) { debug_scanner = true;                           } else
    if (!strcmp(arg, "-debug-parser" )) { debug_parser = true;                            } else
    if (!strcmp(arg, "-rcfile"       )) { rcfile = argv[++i];                             } else
    if (!strcmp(arg, "-style"        )) { style = argv[++i];                              } else
    if (!strcmp(arg, "-width"        )) { if (atoi(argv[++i]) > 0) width = atoi(argv[i]); } else
    if (!strcmp(arg, "-o"            )) { output_file_name = argv[++i];                   } else
    if (!strcmp(arg, "-nobs"         )) { use_backspaces = false;                         } else
    if (!strcmp(arg, "-ascii"        )) { use_encoding = ASCII;                           } else
    if (!strcmp(arg, "-utf8"         )) { use_encoding = UTF8;                            } else
    if (!strcmp(arg, "-nometa"       )) { use_meta = false;                               } else
    {
      std::cerr
	<< "Unrecognized command line option \""
	<< arg
	<< "\", try \"-help\"."
	<< std::endl;
      exit(1);
    }
  }
  if (i > argc) {
    std::cerr
      << "Error: Required parameter after \""
      << argv[argc - 1]
      << "\" missing."
      << std::endl;
    exit(1);
  }

  const char *const *input_urls;
  int        number_of_input_urls;

  if (i >= argc) {
    static const char *const x = "-";
    input_urls = &x;
    number_of_input_urls = 1;
  } else {
    input_urls = argv + i;
    number_of_input_urls = argc - i;
  }

  /*
   * Set up formatting: First, set some formatting properties depending on
   * the "-style" command line option.
   */
  if (!strcmp(style, "compact")) {
    ;
  } else
  if (!strcmp(style, "pretty")) {

    /*
     * The "pretty" style was kindly supplied by diligent user Rolf Niepraschk.
     */
    static const struct {
      const char *key;
      const char *value;
    } properties[] = {
      { "OL.TYPE",                  "1" },
      { "OL.vspace.before",         "1" },
      { "OL.vspace.after",          "1" },
      { "OL.indents",               "5" },
      { "UL.vspace.before",         "1" },
      { "UL.vspace.after",          "1" },
      { "UL.indents",               "2" },
      { "DL.vspace.before",         "1" },
      { "DL.vspace.after",          "1" },
      { "DT.vspace.before",         "1" },
      { "DIR.vspace.before",        "1" },
      { "DIR.indents",              "2" },
      { "MENU.vspace.before",       "1" },
      { "MENU.vspace.after",        "1" },
      { "DT.indent",                "2" },
      { "DD.indent",                "6" },
      { "HR.marker",                "-" },
      { "H1.prefix",                ""  },
      { "H2.prefix",                ""  },
      { "H3.prefix",                ""  },
      { "H4.prefix",                ""  },
      { "H5.prefix",                ""  },
      { "H6.prefix",                ""  },
      { "H1.suffix",                ""  },
      { "H2.suffix",                ""  },
      { "H3.suffix",                ""  },
      { "H4.suffix",                ""  },
      { "H5.suffix",                ""  },
      { "H6.suffix",                ""  },
      { "H1.vspace.before",         "2" },
      { "H2.vspace.before",         "1" },
      { "H3.vspace.before",         "1" },
      { "H4.vspace.before",         "1" },
      { "H5.vspace.before",         "1" },
      { "H6.vspace.before",         "1" },
      { "H1.vspace.after",          "1" },
      { "H2.vspace.after",          "1" },
      { "H3.vspace.after",          "1" },
      { "H4.vspace.after",          "1" },
      { "H5.vspace.after",          "1" },
      { "H6.vspace.after",          "1" },
      { "TABLE.vspace.before",      "1" },
      { "TABLE.vspace.after",       "1" },
      { "CODE.vspace.before",       "0" },
      { "CODE.vspace.after",        "0" },
      { "BLOCKQUOTE.vspace.before", "1" },
      { "BLOCKQUOTE.vspace.after",  "1" },
      { "PRE.vspace.before",        "1" },
      { "PRE.vspace.after",         "1" },
      { "PRE.indent.left",          "2" },
      { "IMG.replace.noalt",        ""  },
      { "IMG.alt.prefix",           " " },
      { "IMG.alt.suffix",           " " },
      { 0, 0 }
    }, *p;
    for (p = properties; p->key; ++p) {
      Formatting::setProperty(p->key, p->value);
    }
  } else {
    std::cerr
      << "Unknown style \""
      << style
      << "\" specified -- try \"-help\"."
      << std::endl;
    ::exit(1);
  }

  {
    std::ifstream ifs(rcfile.c_str());
    if (!ifs.rdbuf()->is_open()) ifs.open("/etc/html2textrc");
    if (ifs.rdbuf()->is_open()) {
      Formatting::loadProperties(ifs);
    }
  }

  /*
   * Set up printing.
   */
  Area::use_backspaces = use_backspaces;

  ostream  *osp;
  std::ofstream ofs;

  bool output_is_tty = false;
  if (!strcmp(output_file_name, "-")) {
    osp = &std::cout;
	if (isatty(1 /* stdout */))
	{
		output_is_tty = true;
	}
  } else {
    ofs.open(output_file_name, std::ios::out);
    if (!ofs) {
      std::cerr
        << "Could not open output file \""
        << output_file_name
        << "\"."
        << std::endl;
    exit(1);
    }
    osp = &ofs;
  }

  for (i = 0; i < number_of_input_urls; ++i) {
    const char *input_url = input_urls[i];

    if (number_of_input_urls != 1) {
      *osp << "###### " << input_url << " ######" << std::endl;
    }

    istream    *isp;
    istream    *uis;
	ifstream* infile = NULL;
	stringstream input_stream;

	if (strcmp(input_url, "-") == 0)
	{
		uis = &std::cin;
	}
	else
	{
		infile = new ifstream(input_url);
		if (!infile->is_open())
		{
		  delete infile;
		  std::cerr
			<< "Cannot open input file \""
			<< input_url
			<< "\"."
			<< std::endl;
		  exit(1);
		}
		uis = infile;
    }

	*uis >> noskipws;
	std::copy(istream_iterator<char>(*uis), istream_iterator<char>(), ostream_iterator<char>(input_stream));

	if (infile)
	{
		infile->close();
		delete infile;
	}

	string from_encoding;
	if (use_meta)
	{
		std::ofstream fake_osp("/dev/null");
		// fake parsing to determine meta
		MyParser parser(
		  input_stream,
		  debug_scanner,
		  debug_parser,
		  fake_osp,
		  mode,
		  width,
		  input_url
        );
		if (parser.yyparse() != 0) exit(1);

		from_encoding = parser.meta_encoding;

		// don't need to debug twice ...
		debug_scanner = false;
		debug_parser = false;

		/*
		 * It will be good to show warning in this case. But there are too many
		 * html documents without encoding info, so this branch is commented by
		 * now.
		if (parser.meta_encoding.empty())
		{
			std::cerr << "Warning: cannot determine encoding from html file." << std::endl;
			std::cerr << "To remove this warning, use '-nometa' option with, optionally, '-utf8' or '-ascii' options" << std::endl;
			std::cerr << "to process file \"" << input_url << "\"." << std::endl;
		}
		*/
	}
	if (from_encoding.empty()) // -nometa supplied or no appropriate tag
	{
		if (use_encoding == UTF8)
		{
			from_encoding = "UTF-8";
		}
		else if (use_encoding == ASCII)
		{
			// is ASCII mode we don't need recoding at all
			from_encoding = "";
		}
		else
		{
			from_encoding = "ISO_8859-1";
		}
	}

	bool result = true;
	if (!from_encoding.empty())
	{
		// recode input
		result = recode(input_stream, "UTF-8", from_encoding.data());
	}
	if (!result)
	{
		continue;
	}

    if (number_of_input_urls != 1) {
      *osp << "###### " << input_url << " ######" << std::endl;
    }

	// real parsing now always process UTF-8 (except for ASCII mode)
	if (use_encoding != ASCII)
	{
		use_encoding = UTF8;
	}

	stringstream output_stream;

	// real parsing
	input_stream.clear();
	input_stream.seekg(0);
	MyParser parser(
	  input_stream,
	  debug_scanner,
	  debug_parser,
	  output_stream,
	  mode,
	  width,
	  input_url
	);
    if (parser.yyparse() != 0) exit(1);

	// recode output if output is terminal
	if (output_is_tty)
	{
		setlocale(LC_CTYPE,"");
		char output_encoding[64];
		strcpy(output_encoding, nl_langinfo(CODESET));
		strcat(output_encoding, "//translit");

		result = recode(output_stream, output_encoding, "UTF-8");
		if (!result)
		{
			continue;
		}
	}
	output_stream.clear();
	output_stream.seekg(0);
	output_stream >> noskipws;
	std::copy(istream_iterator<char>(output_stream), istream_iterator<char>(), ostream_iterator<char>(*osp));
  }

  return 0;
}

/* ------------------------------------------------------------------------- */
