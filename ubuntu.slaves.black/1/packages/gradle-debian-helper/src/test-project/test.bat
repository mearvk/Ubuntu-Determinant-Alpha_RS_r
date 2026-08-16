mkdir .gradle\init.d
copy init.gradle .gradle\init.d\
gradle --info --refresh-dependencies --offline --gradle-user-home .gradle --console plain compileJava
