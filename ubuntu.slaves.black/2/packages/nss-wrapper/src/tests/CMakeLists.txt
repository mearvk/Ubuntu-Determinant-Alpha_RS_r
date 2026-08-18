project(tests C)

set(TESTSUITE_LIBRARIES ${NWRAP_REQUIRED_LIBRARIES} ${CMOCKA_LIBRARY})
string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

add_library(nss_nwrap SHARED nss_nwrap.c)
target_compile_options(nss_nwrap
                       PRIVATE
                          ${DEFAULT_C_COMPILE_FLAGS})
target_include_directories(nss_nwrap
                           PRIVATE
                               ${CMAKE_BINARY_DIR}
                               ${CMOCKA_INCLUDE_DIR})

set(HOMEDIR ${CMAKE_CURRENT_BINARY_DIR})

configure_file(passwd.in ${CMAKE_CURRENT_BINARY_DIR}/passwd @ONLY)
configure_file(group.in ${CMAKE_CURRENT_BINARY_DIR}/group @ONLY)
configure_file(hosts.in ${CMAKE_CURRENT_BINARY_DIR}/hosts @ONLY)
configure_file(shadow.in ${CMAKE_CURRENT_BINARY_DIR}/shadow @ONLY)

set(NWRAP_TESTS
    testsuite
    test_nwrap_vector
    test_getaddrinfo
    test_getnameinfo
    test_gethostby_name_addr
    test_gethostent
    test_getpwuid_module)

if (HAVE_SHADOW_H)
    list(APPEND NWRAP_TESTS test_shadow)
endif (HAVE_SHADOW_H)

function(ADD_CMOCKA_TEST_ENVIRONMENT _TEST_NAME)
    if (CMAKE_BUILD_TYPE)
        string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)
        if (CMAKE_BUILD_TYPE_LOWER STREQUAL "addresssanitizer")
            find_library(ASAN_LIBRARY
                         NAMES asan)
            if (NOT ASAN_LIBRARY)
                foreach(version RANGE 10 1)
                    if (NOT ASAN_LIBRARY)
                        find_library(ASAN_LIBRARY libasan.so.${version})
                    endif()
                endforeach()
            endif()
        endif()
    endif()

    if (ASAN_LIBRARY)
        list(APPEND PRELOAD_LIBRARIES ${ASAN_LIBRARY})
    endif()
    list(APPEND PRELOAD_LIBRARIES ${NSS_WRAPPER_LOCATION})

    if (OSX)
        set(TORTURE_ENVIRONMENT "DYLD_FORCE_FLAT_NAMESPACE=1;DYLD_INSERT_LIBRARIES=${NSS_WRAPPER_LOCATION}")
    else ()
        string(REPLACE ";" ":" _TMP_ENV "${PRELOAD_LIBRARIES}")
        set(TORTURE_ENVIRONMENT "LD_PRELOAD=${_TMP_ENV}")
    endif()

    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_PASSWD=${CMAKE_CURRENT_BINARY_DIR}/passwd)
    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_GROUP=${CMAKE_CURRENT_BINARY_DIR}/group)
    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_SHADOW=${CMAKE_CURRENT_BINARY_DIR}/shadow)
    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_HOSTS=${CMAKE_CURRENT_BINARY_DIR}/hosts)
    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_MODULE_SO_PATH=${CMAKE_CURRENT_BINARY_DIR}/libnss_nwrap.so)
    list(APPEND TORTURE_ENVIRONMENT NSS_WRAPPER_MODULE_FN_PREFIX=nwrap)

    set_property(TEST
                    ${_TEST_NAME}
                PROPERTY
                    ENVIRONMENT "${TORTURE_ENVIRONMENT}")
endfunction()
foreach(_NWRAP_TEST ${NWRAP_TESTS})
    add_cmocka_test(${_NWRAP_TEST}
                    SOURCES ${_NWRAP_TEST}.c
                    COMPILE_OPTIONS ${DEFAULT_C_COMPILE_FLAGS}
                    LINK_LIBRARIES ${TESTSUITE_LIBRARIES}
                    LINK_OPTIONS ${DEFAULT_LINK_FLAGS})
    if (BSD)
        target_compile_options(${_NWRAP_TEST}
                               PRIVATE
                                   -DBSD)
    endif()
    target_include_directories(${_NWRAP_TEST}
                               PRIVATE
                                   ${CMAKE_BINARY_DIR}
                                   ${CMOCKA_INCLUDE_DIR})
    add_cmocka_test_environment(${_NWRAP_TEST})
endforeach()

if (HAVE_SHADOW_H)
    # This is needed to check the hash in tests/shadow.in
    target_link_libraries(test_shadow PRIVATE crypt)
endif (HAVE_SHADOW_H)

target_link_libraries(test_nwrap_vector PRIVATE ${CMAKE_THREAD_LIBS_INIT})
target_link_libraries(test_gethostby_name_addr PRIVATE ${CMAKE_THREAD_LIBS_INIT})

# Test nwrap without wrapping so the libc functions are called
if (NOT CMAKE_BUILD_TYPE_LOWER MATCHES "sanitizer")
    add_cmocka_test(test_nwrap_disabled
                    SOURCES test_nwrap_disabled.c
                    COMPILE_OPTIONS ${DEFAULT_C_COMPILE_FLAGS}
                    LINK_LIBRARIES ${TESTSUITE_LIBRARIES}
                    LINK_OPTIONS ${DEFAULT_LINK_FLAGS})
    target_include_directories(test_nwrap_disabled
                               PRIVATE
                                   ${CMAKE_BINARY_DIR}
                                   ${CMOCKA_INCLUDE_DIR})
    set_property(
        TEST
            test_nwrap_disabled
        PROPERTY
            ENVIRONMENT LD_PRELOAD=${NSS_WRAPPER_LOCATION})
endif()
