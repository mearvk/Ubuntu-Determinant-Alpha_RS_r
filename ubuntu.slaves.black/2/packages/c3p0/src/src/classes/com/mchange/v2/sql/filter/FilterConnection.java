/*
 * Distributed as part of c3p0 v.0.9.1.2
 *
 * Copyright (C) 2005 Machinery For Change, Inc.
 *
 * Author: Steve Waldman <swaldman@mchange.com>
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 2.1, as 
 * published by the Free Software Foundation.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this software; see the file LICENSE.  If not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 */


package com.mchange.v2.sql.filter;

import java.lang.String;
import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.NClob;
import java.sql.PreparedStatement;
import java.sql.SQLClientInfoException;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Savepoint;
import java.sql.Statement;
import java.sql.Struct;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.Executor;

public abstract class FilterConnection implements Connection
{
	protected Connection inner;
	
	public FilterConnection(Connection inner)
	{ this.inner = inner; }
	
	public FilterConnection()
	{}
	
	public void setInner( Connection inner )
	{ this.inner = inner; }
	
	public Connection getInner()
	{ return inner; }
	
	public Statement createStatement(int a, int b, int c) throws SQLException
	{ return inner.createStatement(a, b, c); }
	
	public Statement createStatement(int a, int b) throws SQLException
	{ return inner.createStatement(a, b); }
	
	public Statement createStatement() throws SQLException
	{ return inner.createStatement(); }
	
	public PreparedStatement prepareStatement(String a, String[] b) throws SQLException
	{ return inner.prepareStatement(a, b); }
	
	public PreparedStatement prepareStatement(String a) throws SQLException
	{ return inner.prepareStatement(a); }
	
	public PreparedStatement prepareStatement(String a, int b, int c) throws SQLException
	{ return inner.prepareStatement(a, b, c); }
	
	public PreparedStatement prepareStatement(String a, int b, int c, int d) throws SQLException
	{ return inner.prepareStatement(a, b, c, d); }
	
	public PreparedStatement prepareStatement(String a, int b) throws SQLException
	{ return inner.prepareStatement(a, b); }
	
	public PreparedStatement prepareStatement(String a, int[] b) throws SQLException
	{ return inner.prepareStatement(a, b); }
	
	public CallableStatement prepareCall(String a, int b, int c, int d) throws SQLException
	{ return inner.prepareCall(a, b, c, d); }
	
	public CallableStatement prepareCall(String a, int b, int c) throws SQLException
	{ return inner.prepareCall(a, b, c); }
	
	public CallableStatement prepareCall(String a) throws SQLException
	{ return inner.prepareCall(a); }
	
	public String nativeSQL(String a) throws SQLException
	{ return inner.nativeSQL(a); }
	
	public void setAutoCommit(boolean a) throws SQLException
	{ inner.setAutoCommit(a); }
	
	public boolean getAutoCommit() throws SQLException
	{ return inner.getAutoCommit(); }
	
	public void commit() throws SQLException
	{ inner.commit(); }
	
	public void rollback(Savepoint a) throws SQLException
	{ inner.rollback(a); }
	
	public void rollback() throws SQLException
	{ inner.rollback(); }
	
	public DatabaseMetaData getMetaData() throws SQLException
	{ return inner.getMetaData(); }
	
	public void setCatalog(String a) throws SQLException
	{ inner.setCatalog(a); }
	
	public String getCatalog() throws SQLException
	{ return inner.getCatalog(); }
	
	public void setTransactionIsolation(int a) throws SQLException
	{ inner.setTransactionIsolation(a); }
	
	public int getTransactionIsolation() throws SQLException
	{ return inner.getTransactionIsolation(); }
	
	public SQLWarning getWarnings() throws SQLException
	{ return inner.getWarnings(); }
	
	public void clearWarnings() throws SQLException
	{ inner.clearWarnings(); }
	
	public Map getTypeMap() throws SQLException
	{ return inner.getTypeMap(); }
	
	public void setTypeMap(Map a) throws SQLException
	{ inner.setTypeMap(a); }
	
	public void setHoldability(int a) throws SQLException
	{ inner.setHoldability(a); }
	
	public int getHoldability() throws SQLException
	{ return inner.getHoldability(); }
	
	public Savepoint setSavepoint() throws SQLException
	{ return inner.setSavepoint(); }
	
	public Savepoint setSavepoint(String a) throws SQLException
	{ return inner.setSavepoint(a); }
	
	public void releaseSavepoint(Savepoint a) throws SQLException
	{ inner.releaseSavepoint(a); }
	
	public void setReadOnly(boolean a) throws SQLException
	{ inner.setReadOnly(a); }
	
	public boolean isReadOnly() throws SQLException
	{ return inner.isReadOnly(); }
	
	public void close() throws SQLException
	{ inner.close(); }
	
	public boolean isClosed() throws SQLException
	{ return inner.isClosed(); }
	
	// JDBC 4.0

	public Array createArrayOf(String arg0, Object[] arg1) throws SQLException {
		return inner.createArrayOf(arg0, arg1);
	}

	public Blob createBlob() throws SQLException {
		return inner.createBlob();
	}

	public Clob createClob() throws SQLException {
		return inner.createClob();
	}

	public NClob createNClob() throws SQLException {
		return inner.createNClob();
	}

	public SQLXML createSQLXML() throws SQLException {
		return inner.createSQLXML();
	}

	public Struct createStruct(String arg0, Object[] arg1) throws SQLException {
		return inner.createStruct(arg0, arg1);
	}

	public Properties getClientInfo() throws SQLException {
		return inner.getClientInfo();
	}

	public String getClientInfo(String arg0) throws SQLException {
		return inner.getClientInfo(arg0);
	}

	public boolean isValid(int arg0) throws SQLException {
		return inner.isValid(arg0);
	}

	public void setClientInfo(Properties arg0) throws SQLClientInfoException {
		inner.setClientInfo(arg0);
	}

	public void setClientInfo(String arg0, String arg1)
			throws SQLClientInfoException {
		inner.setClientInfo(arg0, arg1);
	}

	public boolean isWrapperFor(Class c) throws SQLException {
		return c.isInstance(this);
	}
	
	public Object unwrap(Class c) throws SQLException {
		if (c.isInstance(this)) {
			return this;
		}
		// should people be calling unwrap when isWrapperFor would return false
		return null;
	}

	// JDBC 4.1
	
	public void abort(Executor arg0) throws SQLException {
		//inner.abort(arg0);
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public int getNetworkTimeout() throws SQLException {
		//return inner.getNetworkTimeout();
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public String getSchema() throws SQLException {
		//return inner.getSchema();
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public void setNetworkTimeout(Executor arg0, int arg1) throws SQLException {
		//inner.setNetworkTimeout(arg0, arg1);
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public void setSchema(String arg0) throws SQLException {
		//inner.setSchema(arg0);
		throw new java.sql.SQLFeatureNotSupportedException();
	}
}
