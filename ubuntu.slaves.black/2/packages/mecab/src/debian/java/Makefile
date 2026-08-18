TARGET=MeCab
JAVAC=javac -source 1.7 -target 1.7 -encoding UTF-8
JAVA=java
JAR=jar
CXX=g++
INCLUDE=/usr/lib/jvm/default-java/include

PACKAGE=org/chasen/mecab

#LIBS=`mecab-config --libs`
#INC=`mecab-config --cflags` -I$(INCLUDE) -I$(INCLUDE)/linux
LIBS=-L../src/.libs -lmecab -lstdc++
INC=-I../src -I$(INCLUDE) -I$(INCLUDE)/linux

all:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -g -O3 -c -fpic $(TARGET)_wrap.cxx  $(INC)
	$(CXX) -shared  $(TARGET)_wrap.o -o lib$(TARGET).so $(LDFLAGS) $(LIBS)
	$(JAVAC) $(PACKAGE)/*.java
	$(JAVAC) test.java
	$(JAR) cfv $(TARGET).jar $(PACKAGE)/*.class

test:
	env LD_LIBRARY_PATH=. $(JAVA) test

clean:
	rm -fr *.jar *.o *.so *.class $(PACKAGE)/*.class

cleanall:
	rm -fr $(TARGET).java *.cxx
