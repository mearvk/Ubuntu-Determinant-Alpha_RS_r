# Put first element from _list into _carg, then remove it from _list.
macro(LIST_SHIFT _list _carg)
    list(GET ${_list} 0 ${_carg})
    list(REMOVE_AT ${_list} 0)
endmacro(LIST_SHIFT)

# Given parameter list (FILES foo bar baz DESTINATION dir [rest]),
# parse file list, destination, and rest arguments.
macro(PARSE_ARGS_INTO_FILES_DESTINATION_REST _files_O _dest_O _rest_O)
    set(_m05 PARSE_ARGS_INTO_FILES_DESTINATION_REST)

    set(_rest ${ARGN})
    if(NOT _rest)
        message(FATAL_ERROR "${_m05}: No arguments given.")
    endif(NOT _rest)

    list_shift(_rest _carg)
    if(NOT _carg STREQUAL "FILES")
        message(FATAL_ERROR "${_m05}: First argument must be keyword FILES.")
    endif(NOT _carg STREQUAL "FILES")

    if(NOT _rest)
        message(FATAL_ERROR "${_m05}: No arguments after keyword FILES.")
    endif(NOT _rest)

    # Get list of files.
    set(_files)
    list_shift(_rest _carg)
    while(_rest AND NOT _carg STREQUAL "DESTINATION")
        list(APPEND _files ${_carg})
        list_shift(_rest _carg)
    endwhile(_rest AND NOT _carg STREQUAL "DESTINATION")

    if(NOT _rest)
        message(FATAL_ERROR "${_m05}: Expected keyword DESTINATION after file list.")
    endif(NOT _rest)

    # Get destination.
    list_shift(_rest _carg)
    set(_dest ${_carg})

    # Set outputs.
    set(${_files_O} ${_files})
    set(${_dest_O} ${_dest})
    set(${_rest_O} ${_rest})

endmacro(PARSE_ARGS_INTO_FILES_DESTINATION_REST)

get_filename_component(_current_list_file_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

# Create _out file by resolving hybrid text segments from _in file,
# to clean text in dialect and script given by _dstarget.
# _dstarget is one of keywords: ec, el, ic, il.
macro(RESOLVE_HYBRID _dstarget _in _out)
    find_package(Perl)
    set(RESHYBCMD
        ${PERL_EXECUTABLE} ${_current_list_file_dir}/resolve-sr-hybrid)
    add_custom_command(OUTPUT ${_out}
                       COMMAND ${RESHYBCMD} ${_dstarget} < ${_in} > ${_out}
                       DEPENDS ${_in})
endmacro(RESOLVE_HYBRID)

# Add single derived file target.
macro(ADD_DERIVED_FILE_TARGET _file)
    get_filename_component(_base ${_file} NAME)
    string(REGEX REPLACE "[^a-zA-Z0-9]" "_" _target ${_base})
    add_custom_target(${_target}-derived ALL DEPENDS ${_file})
endmacro(ADD_DERIVED_FILE_TARGET _file)

# Install Serbian data files, appropriately making dialect/script combinations
# by modifying file names, destination path, and processing .in files.
macro(INSTALL_DATA_SR)
    set(_m10 INSTALL_DATA_SR)

    parse_args_into_files_destination_rest(_files _dest _rest ${ARGN})

    # Construct destinations.
    string(REPLACE "LL" "sr" _dest_ekcyr ${_dest})
    string(REPLACE "LL" "sr@latin" _dest_eklat ${_dest})
    string(REPLACE "LL" "sr@ijekavian" _dest_ijcyr ${_dest})
    string(REPLACE "LL" "sr@ijekavianlatin" _dest_ijlat ${_dest})

    # Handle files for both scripts.
    foreach(_file ${_files})
        # If .in extension, strip it and note that file is derived.
        set(_dext "in")
        if(${_file} MATCHES "\\.${_dext}$")
            string(REGEX REPLACE "\\.${_dext}$" "" _file ${_file})
            set(_derived 1)
        endif(${_file} MATCHES "\\.${_dext}$")

        # Construct file names.
        string(REPLACE "LL" "sr" _file_ekcyr ${_file})
        string(REPLACE "LL" "sr@latin" _file_eklat ${_file})
        string(REPLACE "LL" "sr@ijekavian" _file_ijcyr ${_file})
        string(REPLACE "LL" "sr@ijekavianlatin" _file_ijlat ${_file})

        # Assure that either destinations or file names are different.
        # (Enough to check with any two dialect/script combinations.)
        if(${_dest_ekcyr} STREQUAL ${_dest_eklat} AND ${_file_ekcyr} STREQUAL ${_file_eklat})
            message(FATAL_ERROR "${_m10}: File ${_file} must be language-coded because of same destinations.")
        endif(${_dest_ekcyr} STREQUAL ${_dest_eklat} AND ${_file_ekcyr} STREQUAL ${_file_eklat})

        # Full source and derived paths.
        set(_file_src ${CMAKE_CURRENT_SOURCE_DIR}/${_file})
        set(_file_bld_ekcyr ${CMAKE_CURRENT_BINARY_DIR}/${_file_ekcyr}-ekcyr)
        set(_file_bld_eklat ${CMAKE_CURRENT_BINARY_DIR}/${_file_eklat}-eklat)
        set(_file_bld_ijcyr ${CMAKE_CURRENT_BINARY_DIR}/${_file_ijcyr}-ijcyr)
        set(_file_bld_ijlat ${CMAKE_CURRENT_BINARY_DIR}/${_file_ijlat}-ijlat)

        # Issue derivation/installation commands per file.
        if(${_derived}) # file needs derivation
            # Ekavian Cyrillic.
            resolve_hybrid(ec ${_file_src}.in ${_file_bld_ekcyr})
            add_derived_file_target(${_file_bld_ekcyr})
            install(FILES ${_file_bld_ekcyr}
                    DESTINATION ${_dest_ekcyr} RENAME ${_file_ekcyr} ${_rest})
            # Ekavian Latin.
            resolve_hybrid(el ${_file_src}.in ${_file_bld_eklat})
            add_derived_file_target(${_file_bld_eklat})
            install(FILES ${_file_bld_eklat}
                    DESTINATION ${_dest_eklat} RENAME ${_file_eklat} ${_rest})
            # Ijekavian Cyrillic.
            resolve_hybrid(ic ${_file_src}.in ${_file_bld_ijcyr})
            add_derived_file_target(${_file_bld_ijcyr})
            install(FILES ${_file_bld_ijcyr}
                    DESTINATION ${_dest_ijcyr} RENAME ${_file_ijcyr} ${_rest})
            # Ijekavian Latin.
            resolve_hybrid(il ${_file_src}.in ${_file_bld_ijlat})
            add_derived_file_target(${_file_bld_ijlat})
            install(FILES ${_file_bld_ijlat} DESTINATION ${_dest_ijlat} RENAME ${_file_ijlat} ${_rest})
        else(${_derived}) # static file
            install(FILES ${_file_src}
                    DESTINATION ${_dest_ekcyr} RENAME ${_file_ekcyr} ${_rest})
            install(FILES ${_file_src}
                    DESTINATION ${_dest_eklat} RENAME ${_file_eklat} ${_rest})
            install(FILES ${_file_src}
                    DESTINATION ${_dest_ijcyr} RENAME ${_file_ijcyr} ${_rest})
            install(FILES ${_file_src}
                    DESTINATION ${_dest_ijlat} RENAME ${_file_ijlat} ${_rest})
        endif(${_derived})

    endforeach(_file)

endmacro(INSTALL_DATA_SR)
