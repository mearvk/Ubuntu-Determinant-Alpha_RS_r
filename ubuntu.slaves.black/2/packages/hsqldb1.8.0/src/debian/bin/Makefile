scripts = $(addprefix hsqldb-,databasemanager databasemanagerswing transfer querytool sqltool)

all: $(scripts)

hsqldb-databasemanager: class=DatabaseManager
hsqldb-databasemanagerswing: class=DatabaseManagerSwing
hsqldb-transfer: class=Transfer
hsqldb-querytool: class=QueryTool
hsqldb-sqltool: class=SqlTool

$(scripts): hsqldb.in
	sed "s/@CLASS@/$(class)/g" $< >$@
	chmod a+x $@

clean:
	rm -f $(scripts)
