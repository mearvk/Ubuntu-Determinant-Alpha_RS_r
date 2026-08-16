set (CFLAGS ${CACHED_SESSIONMIGRATION_DEPS_CFLAGS})
set (LIBS ${CACHED_SESSIONMIGRATION_DEPS_LIBRARIES} ${UNITY_STANDALONE_LADD})

add_definitions (${CFLAGS})
link_libraries (${LIBS})

add_executable (session-migration session-migration.c) 

install(TARGETS session-migration DESTINATION bin)
