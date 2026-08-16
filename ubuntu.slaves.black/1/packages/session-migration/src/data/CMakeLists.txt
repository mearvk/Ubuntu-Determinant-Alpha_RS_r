install (FILES session-migration.conf DESTINATION share/upstart/sessions)
install (FILES session-migration.service DESTINATION lib/systemd/user)
install (FILES session-migration.override DESTINATION share/upstart/systemd-session/upstart)
