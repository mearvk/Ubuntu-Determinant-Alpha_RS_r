cmake_minimum_required (VERSION 2.8) 
project(user-migration)

find_package (PkgConfig)
pkg_check_modules (CACHED_SESSIONMIGRATION_DEPS REQUIRED "glib-2.0>=2.51.1;gio-2.0")

add_subdirectory(data)
add_subdirectory(src)

file(COPY debhelper tests
     DESTINATION ${PROJECT_BINARY_DIR})
add_custom_target(check
                  COMMAND nosetests3
                  DEPENDS session-migration)

macro(add_manpages target manpages translations)
    foreach(man ${manpages})
        string(LENGTH ${man} manpage_length)
        math(EXPR manpage_length ${manpage_length}-1)
        string(SUBSTRING ${man} ${manpage_length} 1 section)
        install(FILES ${man} DESTINATION share/man/man${section})

        if (USE_NLS)
            foreach(translation ${translations})
                set(transdir ${CMAKE_CURRENT_BINARY_DIR}/${translation})
                add_po4a(man ${man} po/${translation}.po ${transdir}/${man} "")
                install(FILES ${transdir}/${man}
                        DESTINATION share/man/${translation}/man${section})
                set(files ${files} ${transdir}/${man})
            endforeach(translation ${translations})
        endif(USE_NLS)
    endforeach(man ${manpages})
    add_custom_target(${target} ALL DEPENDS ${files})
endmacro(add_manpages target manpages translations)
add_manpages(doc-rawman session-migration.1 "en;")

