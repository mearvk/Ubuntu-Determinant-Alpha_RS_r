scripts = $(addprefix hsqldb-,databasemanager databasemanagerswing transfer sqltool)

all: $(scripts)

hsqldb-databasemanager: class=DatabaseManager
hsqldb-databasemanager: path=util
hsqldb-databasemanager: arg=\"$$\@\"
hsqldb-databasemanagerswing: class=DatabaseManagerSwing
hsqldb-databasemanagerswing: path=util
hsqldb-databasemanagerswing: arg=--help
hsqldb-transfer: class=Transfer
hsqldb-transfer: path=util
hsqldb-transfer: arg=--help
hsqldb-sqltool: class=SqlTool
hsqldb-sqltool: path=cmdline
hsqldb-sqltool: arg=\"$$\@\"

$(scripts): hsqldb.in
	sed -e "s/@CLASS@/$(class)/g" -e "s/@PATH@/$(path)/g" -e "s/@ARG@/$(arg)/g" $< >$@
	chmod a+x $@

clean:
	rm -f $(scripts)
