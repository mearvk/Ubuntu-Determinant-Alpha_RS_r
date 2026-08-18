#!/usr/bin/python3
import sys
import re

# File 'gitlab-doc.md' is expected to contain all markdown files of api
# documentation concatenated. Something like
#
# $ find gitlab-ce/doc/api/ -name '*.md' | xargs cat > gitlab-doc.md
#
# will do.
gitlab_doc = list(open('gitlab-doc.md'))

def make_mapping(f):
    """
    Parse source of GitLab::API::v4 and return mapping between perl
    function name and API method signature, as spelled in GitLab
    documentation.

    This function assumes very specific format of input. Assumptions are
    true as of libghitlab-api-v4-perl=0.15; there is no stability
    warranties.
    """
    res = {}

    (ix, lines) = (0, list(f))
    while ix < len(lines):
        if not lines[ix].startswith('Sends a C'):
            ix += 1
            continue
        parts = re.split('[<>]', lines[ix])
        (method, endpoint) = (parts[1], parts[3])
        endpoint = re.sub(r':[a-z_]+_id/', ':[a-z_]+/', endpoint)
        sstring = "%s /%s" % (method, endpoint)
        while not lines[ix].startswith('sub '):
            ix += 1
        funcname = lines[ix].split()[1].replace('_', '-')

        res[funcname] = sstring
        ix += 1
    return res

# Our new purpose is to find names of all parameters, associated with
# given perl function name. To do so, we locate string like
#
# GET /groups/:id/badges/render
#
# in documentation, and take all words till next section in form `foo`
# as parameter name.
def get_parameters_names(sstring):
    names = set()
    ix = 0
    while ix < len(gitlab_doc):
        if re.match(sstring, gitlab_doc[ix]):
            break
        ix += 1
    if ix == len(gitlab_doc):
        return []
    signature = gitlab_doc[ix]
    while not gitlab_doc[ix].startswith('##'):
        for name in re.findall(r'`[a-z_]+`', gitlab_doc[ix]):
            names.add(name[1:-1])
        ix += 1
        if ix == len(gitlab_doc):
            break
    return [n for n in sorted(names) if not (':%s' % n) in signature]

m = make_mapping(sys.stdin)
functions = " ".join(m.keys())
print("""
_gitlab_api_v4 () {
  COMPREPLY=()
  _get_comp_words_by_ref cur
  if [[ "${COMP_CWORD}" = 1 ]] ; then
    COMPREPLY=( $(compgen -W "%s" -- "${cur}") )
    return 0
  fi
  case "${COMP_WORDS[1]}" in
""" % functions)
for fn in m.keys():
    names = " ".join(n + ":" for n in get_parameters_names(m[fn]))
    if names != "":
        print("""
        (%s)
            COMPREPLY=( $(compgen -o nospace -W "%s" -- "${cur}") )
            return 0
            ;;
        """ % (fn, names))
print("""
  esac
}
complete -F _gitlab_api_v4 gitlab-api-v4
""")
