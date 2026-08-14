// This file is part of The New Aspell
//
// Copyright (C) 2005 by Brian Nelson, based on the email filter,
// Copyright (C) 2001 by Kevin Atkinson under the GNU LGPL license
// version 2.0 or 2.1.  You should have received a copy of the LGPL
// license along with this library if you did not you can find it at
// http://www.gnu.org/.

#include "settings.h"

#include "indiv_filter.hpp"
#include "convert.hpp"
#include "config.hpp"
#include "indiv_filter.hpp"

namespace {

  using namespace acommon;

  class DebctrlFilter : public IndividualFilter 
  {
    bool prev_newline;
    bool in_field;

  public:
    PosibErr<bool> setup(Config *);
    void reset();
    void process(FilterChar * &, FilterChar * &);
  };

  PosibErr<bool> DebctrlFilter::setup(Config * opts) 
  {
    name_ = "debctrl-filter";
    order_num_ = 0.90;
    reset();
    return true;
  }
  
  void DebctrlFilter::reset() 
  {
    prev_newline = true;
    in_field = false;
  }

  void DebctrlFilter::process(FilterChar * & str, FilterChar * & end)
  {
    FilterChar * line_begin = str;
    FilterChar * cur = str;

    while (cur < end) {
      if (prev_newline && *cur != ' ')
        in_field = true;

      if (*cur == '\n') {
	if (in_field) {
	  for (FilterChar * i = line_begin; i != cur; ++i)
	    *i = ' ';
	}
	line_begin = cur;
	in_field = false;
	prev_newline = true;
      } else {
	prev_newline = false;
      }
      ++cur;
    }
    if (in_field)
      for (FilterChar * i = line_begin; i != cur; ++i)
	*i = ' ';
  }
}

C_EXPORT 
IndividualFilter * new_aspell_debctrl_filter() {
  return new DebctrlFilter;                                
}
