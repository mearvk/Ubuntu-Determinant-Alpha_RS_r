/*
 *	PROGRAM:	JRD Access Method
 *	MODULE:		scl.h
 *	DESCRIPTION:	Security class definitions
 *
 * The contents of this file are subject to the Interbase Public
 * License Version 1.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.Inprise.com/IPL.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Inprise Corporation
 * and its predecessors. Portions created by Inprise Corporation are
 * Copyright (C) Inprise Corporation.
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 */

#ifndef JRD_SCL_H
#define JRD_SCL_H

#include "../common/classes/MetaName.h"
#include "../common/classes/tree.h"
#include "../common/classes/GenericMap.h"
#include "../common/security.h"
#include "../jrd/obj.h"

namespace Firebird {
class ClumpletWriter;
}

namespace Jrd {

class thread_db;

const size_t ACL_BLOB_BUFFER_SIZE = MAX_USHORT; // used to read/write acl blob

// Security class definition


class SecurityClass
{
public:
	typedef ULONG flags_t;
	enum BlobAccessCheck { BA_UNKNOWN, BA_SUCCESS, BA_FAILURE };

	SecurityClass(Firebird::MemoryPool &pool, const Firebird::MetaName& name, const Firebird::MetaName& userName)
		: permissions(pool), sclClassUser(pool, Firebird::MetaNamePair(name, userName)), scl_flags(0), scl_blb_access(BA_UNKNOWN)
	{}

private:
	typedef Firebird::Pair<Firebird::Left<Firebird::MetaName, SLONG> > SecurityObject;
	mutable Firebird::GenericMap<Firebird::Pair<Firebird::Left<SecurityObject, flags_t> > > permissions;

public:
	bool getPrivileges(Firebird::MetaName objName, SLONG objType, flags_t& privileges) const
	{
		return permissions.get(SecurityObject(objName, objType), privileges);
	}

	void setPrivileges(Firebird::MetaName objName, SLONG objType, flags_t privileges) const
	{
		flags_t* p = permissions.put(SecurityObject(objName, objType));
		if (p)
			*p = privileges;
	}

	const Firebird::MetaNamePair sclClassUser;
	flags_t scl_flags;			// Default (no object) access permissions
	BlobAccessCheck scl_blb_access;

	static const Firebird::MetaNamePair& generate(const void*, const SecurityClass* item)
	{
		return item->sclClassUser;
	}
};

typedef Firebird::BePlusTree<
	SecurityClass*,
	Firebird::MetaNamePair,
	Firebird::MemoryPool,
	SecurityClass
> SecurityClassList;


const SecurityClass::flags_t SCL_select			= 1;		// SELECT access
const SecurityClass::flags_t SCL_drop			= 2;		// DROP access
const SecurityClass::flags_t SCL_control		= 4;		// Control access
const SecurityClass::flags_t SCL_exists			= 8;		// At least ACL exists
const SecurityClass::flags_t SCL_alter			= 16;		// ALTER access
const SecurityClass::flags_t SCL_corrupt		= 32;		// ACL does look too good
const SecurityClass::flags_t SCL_insert			= 64;		// INSERT access
const SecurityClass::flags_t SCL_delete			= 128;		// DELETE access
const SecurityClass::flags_t SCL_update			= 256;		// UPDATE access
const SecurityClass::flags_t SCL_references		= 512;		// REFERENCES access
const SecurityClass::flags_t SCL_execute		= 1024;		// EXECUTE access
const SecurityClass::flags_t SCL_usage			= 2048;		// USAGE access
const SecurityClass::flags_t SCL_create			= 4096;

const SecurityClass::flags_t SCL_SELECT_ANY	= SCL_select | SCL_references;
const SecurityClass::flags_t SCL_ACCESS_ANY	= SCL_insert | SCL_update | SCL_delete |
											  SCL_execute | SCL_usage | SCL_SELECT_ANY;
const SecurityClass::flags_t SCL_MODIFY_ANY	= SCL_create | SCL_alter | SCL_control | SCL_drop;


// information about the user

const USHORT USR_locksmith	= 1;		// User has great karma
const USHORT USR_dba		= 2;		// User has DBA privileges
const USHORT USR_owner		= 4;		// User owns database
const USHORT USR_mapdown	= 8;		// Mapping failed when getting context
const USHORT USR_newrole	= 16;		// usr_granted_roles array needs refresh

class UserId
{
public:
	Firebird::string	usr_user_name;		// User name
	Firebird::string	usr_sql_role_name;	// Role name
	Firebird::string	usr_trusted_role;	// Trusted role if set
	Firebird::string	usr_project_name;	// Project name
	Firebird::string	usr_org_name;		// Organization name
	Firebird::string	usr_auth_method;	// Authentication method
	Auth::AuthenticationBlock usr_auth_block;	// Authentication block after mapping
	USHORT				usr_user_id;		// User id
	USHORT				usr_group_id;		// Group id
	mutable USHORT		usr_flags;			// Misc. crud
	mutable Firebird::string usr_granted_role;

	bool locksmith() const
	{
		return usr_flags & (USR_locksmith | USR_owner | USR_dba);
	}

	UserId()
		: usr_user_id(0), usr_group_id(0), usr_flags(0)
	{ }

	UserId(Firebird::MemoryPool& p, const UserId& ui)
		: usr_user_name(p, ui.usr_user_name),
		  usr_sql_role_name(p, ui.usr_sql_role_name),
		  usr_trusted_role(p, ui.usr_trusted_role),
		  usr_project_name(p, ui.usr_project_name),
		  usr_org_name(p, ui.usr_org_name),
		  usr_auth_method(p, ui.usr_auth_method),
		  usr_auth_block(p),
		  usr_user_id(ui.usr_user_id),
		  usr_group_id(ui.usr_group_id),
		  usr_flags(ui.usr_flags),
		  usr_granted_role(p)
	{
		usr_auth_block.assign(ui.usr_auth_block);
		if (!(usr_flags & USR_newrole))
			usr_granted_role = ui.usr_granted_role;
	}

	UserId(Firebird::MemoryPool& p)
		: usr_user_name(p),
		  usr_sql_role_name(p),
		  usr_trusted_role(p),
		  usr_project_name(p),
		  usr_org_name(p),
		  usr_auth_method(p),
		  usr_auth_block(p),
		  usr_user_id(0),
		  usr_group_id(0),
		  usr_flags(0),
		  usr_granted_role(p)
	{ }

	UserId(const UserId& ui)
		: usr_user_name(ui.usr_user_name),
		  usr_sql_role_name(ui.usr_sql_role_name),
		  usr_trusted_role(ui.usr_trusted_role),
		  usr_project_name(ui.usr_project_name),
		  usr_org_name(ui.usr_org_name),
		  usr_auth_method(ui.usr_auth_method),
		  usr_user_id(ui.usr_user_id),
		  usr_group_id(ui.usr_group_id),
		  usr_flags(ui.usr_flags)
	{
		usr_auth_block.assign(ui.usr_auth_block);
		if (!(usr_flags & USR_newrole))
			usr_granted_role = ui.usr_granted_role;
	}

	UserId& operator=(const UserId& ui)
	{
		usr_user_name = ui.usr_user_name;
		usr_sql_role_name = ui.usr_sql_role_name;
		usr_trusted_role = ui.usr_trusted_role;
		usr_project_name = ui.usr_project_name;
		usr_org_name = ui.usr_org_name;
		usr_auth_method = ui.usr_auth_method;
		usr_user_id = ui.usr_user_id;
		usr_group_id = ui.usr_group_id;
		usr_flags = ui.usr_flags;
		usr_auth_block.assign(ui.usr_auth_block);
		if (!(usr_flags & USR_newrole))
			usr_granted_role = ui.usr_granted_role;

		return *this;
	}

	bool roleInUse(thread_db* tdbb, const Firebird::string& role) const
	{
		if (usr_flags & USR_newrole)
			findGrantedRoles(tdbb);
		return usr_granted_role == role;
	}

	void populateDpb(Firebird::ClumpletWriter& dpb, bool embeddedSupport);

private:
	void findGrantedRoles(thread_db* tdbb) const;
};


// These numbers are arbitrary and only used at run-time. Can be changed if necessary at any moment.
// We need to include here the new objects that accept ACLs.
const SLONG SCL_object_database		= obj_database;
const SLONG SCL_object_table		= obj_relations;
const SLONG SCL_object_package		= obj_packages;
const SLONG SCL_object_procedure	= obj_procedures;
const SLONG SCL_object_function		= obj_functions;
const SLONG SCL_object_collation	= obj_collations;
const SLONG SCL_object_exception	= obj_exceptions;
const SLONG SCL_object_generator	= obj_generators;
const SLONG SCL_object_charset		= obj_charsets;
const SLONG SCL_object_domain		= obj_domains;
const SLONG SCL_object_view			= obj_views;
const SLONG SCL_object_role			= obj_roles;
const SLONG SCL_object_filter		= obj_filters;
// Please keep it with code more than other objects
// - relations and procedures should be sorted before columns.
const SLONG SCL_object_column		= obj_type_MAX + 1;

} //namespace Jrd

#endif // JRD_SCL_H
