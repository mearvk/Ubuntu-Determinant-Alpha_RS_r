/* Filter for DDTP-emails (Debian Description Translation Project).
 *
 * Copyright (C) 2007, Christer Andersson <klamm@comhem.se>
 *
 * This filter is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 2.0 of the License, or
 * (at your option) any later version.
 *
 * This filter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "settings.h"
#include "indiv_filter.hpp"
#include "key_info.hpp"

using namespace acommon;

namespace {
  class DDTPFilter : public IndividualFilter
  {
  public:
    DDTPFilter() : IndividualFilter() {}
    virtual ~DDTPFilter() {}

    virtual PosibErr<bool> setup(Config *);
    virtual void reset();
    virtual void process(FilterChar * & start, FilterChar * & stop);
    
  protected:
    enum po_filter_state {
      STATE_COMMENT,      // state: comment (don't check)
      STATE_ORIGINAL,     // state: original text (don't check)
      STATE_TRANSLATED    // state: translated text (do check)
    } state;

    // Set to true when the last character read is a line-break.
    // States only change at the beginning of lines.
    bool prev_char_newline;
  };


  PosibErr<bool> 
  DDTPFilter::setup(Config *config)
  {
    name_ = "ddtp-filter";
    order_num_ = 0.90;
    reset();
    return true;
  }

  void 
  DDTPFilter::reset() 
  {
    prev_char_newline=true;
    state = STATE_TRANSLATED;
  }

  void 
  DDTPFilter::process(FilterChar * & start, FilterChar * & stop)
  {
    FilterChar *i = start;   // Current position in text
    FilterChar *eol;         // Next end-of-line or end of text

    // Identify end-of-line if the previous text chunk did not include one.
    for ( eol = i ; eol != stop && *eol != '\n' ; eol++ );

    while ( i != stop ) {
      // Iterate over entire text chunk.

      if ( prev_char_newline ) {
        // Handle beginning of new lines.
        prev_char_newline = false;

        // Swallow leading whitespace. With the current formatting of
        // DDTP-emails this isn't really necessary.
        while ( i != stop 
                && ( *i == ' ' || *i == '\t' || *i == '\r' 
                     || *i == '\f' || *i == '\v' ) )
          ++i;

        // Determine end of this line.
        for ( eol = i ; eol != stop && *eol != '\n' ; eol++ );

        // Check for literals:
        //  '#'                     Comments
        //  'Description:'          Begin original message
        //  'Description-LANG.ENC:' Begin translated message
        if ( *i == '#' ) {
          state = STATE_COMMENT;
        }
        else if ( eol-i >= 12 
             && i[0] == 'D' && i[1] == 'e' && i[2] == 's' && i[3] == 'c'
             && i[4] == 'r' && i[5] == 'i' && i[6] == 'p' && i[7] == 't' 
             && i[8] == 'i' && i[9] == 'o' && i[10] == 'n' 
             && (i[11] == ':' || i[11] == '-') ) {
          if (i[11] == ':')
            state = STATE_ORIGINAL;
          else
            state = STATE_TRANSLATED;

          // Blank out keyword.
          for ( ; i != eol && *i != ':' ; i++)
            *i = ' ';
          if ( i != eol ) 
            *i = ' '; // Colon
        }
      }

      // Process current line.
      if (state == STATE_TRANSLATED) {
        i = eol;
      }
      else {
        for ( ; i != eol ; i++ )
          *i = ' ';
      }

      if (eol != stop) {
        // More text to process. Move to next line and continue.
        i++;
        prev_char_newline = true;
      }
    }
  }
}

C_EXPORT 
IndividualFilter* new_aspell_ddtp_filter() {
  return new DDTPFilter;                       
}
