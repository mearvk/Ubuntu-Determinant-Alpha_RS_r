// Copyright: © 2012 Enrico Tassi <gareuselesinge@debian.org>
// License: MIT/X

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lauxlib.h>
#include <lualib.h>

// this should include all the needed libraries and
// define 
//   static void app_open(lua_State* L)
#include "app.c.conf"

int main(int argn,char** argv){
	int rc;
	int i;
	const char *init = getenv("LUA_INIT");

	// create a lua VM
	lua_State* L = lua_open();
	if (L == NULL) {
		fprintf(stderr,"Unable to allocate a lua_State");
		return 1;
	}

	// load stdlib
	lua_gc(L, LUA_GCSTOP, 0);  /* stop collector during initialization */
	luaL_openlibs(L);  /* open libraries */
	lua_gc(L, LUA_GCRESTART, 0);

	// LUA_INIT
	if (init != NULL && luaL_dostring(L, init)) {
		const char* error = NULL;
		error = lua_tostring(L,-1);
		fprintf(stderr,"app.c: %s\n",error);
		return 1;
	}

	// here the specific luaopen_MODULENAME
	app_open(L);

	// LOAD
	if (argn < 2 || !strcmp("-", argv[1])) {
		rc = luaL_loadfile(L, NULL);
	}
	else {
		rc = luaL_loadfile(L,argv[1]);
	}

	// check for errors
	if (rc != 0){
		const char* error = NULL;
		error = lua_tostring(L,-1);
		fprintf(stderr,"app.c: %s\n",error);
		return 1;
	}

	// RUN!
	lua_newtable(L);
	for(i=1;i<argn;i++){
		lua_pushnumber(L,i-1);
		lua_pushstring(L,argv[i]);
		lua_settable(L,-3);
	}
	lua_setglobal(L,"arg");

	for(i=2;i<argn;i++) lua_pushstring(L,argv[i]);
	rc = lua_pcall(L,(argn > 2 ? argn-2 : 0),LUA_MULTRET,0);
	
	// check for errors
	if (rc != 0){
		const char* error = NULL;
		error = lua_tostring(L,-1);
		fprintf(stderr,"app.c: %s\n",error);
		return 1;
	}

	// shutdown lua VM
	lua_close(L);

	// bye!
	return (rc == 0 ? EXIT_SUCCESS : 1);
}
