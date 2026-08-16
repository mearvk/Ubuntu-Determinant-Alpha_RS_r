set(PINYINHELPER_SOURCES
    pinyinhelper.cpp
    pinyinlookup.cpp
    stroke.cpp
)
add_library(pinyinhelper MODULE ${PINYINHELPER_SOURCES})
target_link_libraries(pinyinhelper Fcitx5::Core Fcitx5::Config LibIME::Core Boost::iostreams Fcitx5::Module::QuickPhrase Fcitx5::Module::Clipboard ${FMT_TARGET})
install(TARGETS pinyinhelper DESTINATION "${CMAKE_INSTALL_LIBDIR}/fcitx5")
configure_file(pinyinhelper.conf.in.in pinyinhelper.conf.in)
fcitx5_translate_desktop_file("${CMAKE_CURRENT_BINARY_DIR}/pinyinhelper.conf.in" pinyinhelper.conf)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/pinyinhelper.conf" DESTINATION "${FCITX_INSTALL_PKGDATADIR}/addon")

fcitx5_export_module(PinyinHelper TARGET pinyinhelper BUILD_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}" HEADERS pinyinhelper_public.h INSTALL)

set(PY_STROKE_TGT "${PROJECT_SOURCE_DIR}/pystroke/py_stroke.mb")
install(FILES "${PY_STROKE_TGT}" DESTINATION "${FCITX_INSTALL_PKGDATADIR}/pinyinhelper")

set(PY_TABLE_TGT "${PROJECT_SOURCE_DIR}/pytable/py_table.mb")
install(FILES "${PY_TABLE_TGT}" DESTINATION "${FCITX_INSTALL_PKGDATADIR}/pinyinhelper")
