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

import java.io.InputStream;
import java.io.Reader;
import java.lang.Object;
import java.lang.String;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.Date;
import java.sql.NClob;
import java.sql.ParameterMetaData;
import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.RowId;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Map;

public abstract class FilterCallableStatement implements CallableStatement
{
	protected CallableStatement inner;
	
	public FilterCallableStatement(CallableStatement inner)
	{ this.inner = inner; }
	
	public FilterCallableStatement()
	{}
	
	public void setInner( CallableStatement inner )
	{ this.inner = inner; }
	
	public CallableStatement getInner()
	{ return inner; }
	
	public boolean wasNull() throws SQLException
	{ return inner.wasNull(); }
	
	public BigDecimal getBigDecimal(int a, int b) throws SQLException
	{ return inner.getBigDecimal(a, b); }
	
	public BigDecimal getBigDecimal(int a) throws SQLException
	{ return inner.getBigDecimal(a); }
	
	public BigDecimal getBigDecimal(String a) throws SQLException
	{ return inner.getBigDecimal(a); }
	
	public Timestamp getTimestamp(String a) throws SQLException
	{ return inner.getTimestamp(a); }
	
	public Timestamp getTimestamp(String a, Calendar b) throws SQLException
	{ return inner.getTimestamp(a, b); }
	
	public Timestamp getTimestamp(int a, Calendar b) throws SQLException
	{ return inner.getTimestamp(a, b); }
	
	public Timestamp getTimestamp(int a) throws SQLException
	{ return inner.getTimestamp(a); }
	
	public Blob getBlob(String a) throws SQLException
	{ return inner.getBlob(a); }
	
	public Blob getBlob(int a) throws SQLException
	{ return inner.getBlob(a); }
	
	public Clob getClob(String a) throws SQLException
	{ return inner.getClob(a); }
	
	public Clob getClob(int a) throws SQLException
	{ return inner.getClob(a); }
	
	public void setNull(String a, int b, String c) throws SQLException
	{ inner.setNull(a, b, c); }
	
	public void setNull(String a, int b) throws SQLException
	{ inner.setNull(a, b); }
	
	public void setBigDecimal(String a, BigDecimal b) throws SQLException
	{ inner.setBigDecimal(a, b); }
	
	public void setBytes(String a, byte[] b) throws SQLException
	{ inner.setBytes(a, b); }
	
	public void setTimestamp(String a, Timestamp b, Calendar c) throws SQLException
	{ inner.setTimestamp(a, b, c); }
	
	public void setTimestamp(String a, Timestamp b) throws SQLException
	{ inner.setTimestamp(a, b); }
	
	public void setAsciiStream(String a, InputStream b, int c) throws SQLException
	{ inner.setAsciiStream(a, b, c); }
	
	public void setBinaryStream(String a, InputStream b, int c) throws SQLException
	{ inner.setBinaryStream(a, b, c); }
	
	public void setObject(String a, Object b) throws SQLException
	{ inner.setObject(a, b); }
	
	public void setObject(String a, Object b, int c, int d) throws SQLException
	{ inner.setObject(a, b, c, d); }
	
	public void setObject(String a, Object b, int c) throws SQLException
	{ inner.setObject(a, b, c); }
	
	public void setCharacterStream(String a, Reader b, int c) throws SQLException
	{ inner.setCharacterStream(a, b, c); }
	
	public void registerOutParameter(String a, int b) throws SQLException
	{ inner.registerOutParameter(a, b); }
	
	public void registerOutParameter(int a, int b) throws SQLException
	{ inner.registerOutParameter(a, b); }
	
	public void registerOutParameter(int a, int b, int c) throws SQLException
	{ inner.registerOutParameter(a, b, c); }
	
	public void registerOutParameter(int a, int b, String c) throws SQLException
	{ inner.registerOutParameter(a, b, c); }
	
	public void registerOutParameter(String a, int b, int c) throws SQLException
	{ inner.registerOutParameter(a, b, c); }
	
	public void registerOutParameter(String a, int b, String c) throws SQLException
	{ inner.registerOutParameter(a, b, c); }
	
	public Object getObject(String a, Map b) throws SQLException
	{ return inner.getObject(a, b); }
	
	public Object getObject(int a, Map b) throws SQLException
	{ return inner.getObject(a, b); }
	
	public Object getObject(int a) throws SQLException
	{ return inner.getObject(a); }
	
	public Object getObject(String a) throws SQLException
	{ return inner.getObject(a); }
	
	public boolean getBoolean(int a) throws SQLException
	{ return inner.getBoolean(a); }
	
	public boolean getBoolean(String a) throws SQLException
	{ return inner.getBoolean(a); }
	
	public byte getByte(String a) throws SQLException
	{ return inner.getByte(a); }
	
	public byte getByte(int a) throws SQLException
	{ return inner.getByte(a); }
	
	public short getShort(int a) throws SQLException
	{ return inner.getShort(a); }
	
	public short getShort(String a) throws SQLException
	{ return inner.getShort(a); }
	
	public int getInt(String a) throws SQLException
	{ return inner.getInt(a); }
	
	public int getInt(int a) throws SQLException
	{ return inner.getInt(a); }
	
	public long getLong(int a) throws SQLException
	{ return inner.getLong(a); }
	
	public long getLong(String a) throws SQLException
	{ return inner.getLong(a); }
	
	public float getFloat(String a) throws SQLException
	{ return inner.getFloat(a); }
	
	public float getFloat(int a) throws SQLException
	{ return inner.getFloat(a); }
	
	public double getDouble(String a) throws SQLException
	{ return inner.getDouble(a); }
	
	public double getDouble(int a) throws SQLException
	{ return inner.getDouble(a); }
	
	public byte[] getBytes(int a) throws SQLException
	{ return inner.getBytes(a); }
	
	public byte[] getBytes(String a) throws SQLException
	{ return inner.getBytes(a); }
	
	public URL getURL(String a) throws SQLException
	{ return inner.getURL(a); }
	
	public URL getURL(int a) throws SQLException
	{ return inner.getURL(a); }
	
	public void setBoolean(String a, boolean b) throws SQLException
	{ inner.setBoolean(a, b); }
	
	public void setByte(String a, byte b) throws SQLException
	{ inner.setByte(a, b); }
	
	public void setShort(String a, short b) throws SQLException
	{ inner.setShort(a, b); }
	
	public void setInt(String a, int b) throws SQLException
	{ inner.setInt(a, b); }
	
	public void setLong(String a, long b) throws SQLException
	{ inner.setLong(a, b); }
	
	public void setFloat(String a, float b) throws SQLException
	{ inner.setFloat(a, b); }
	
	public void setDouble(String a, double b) throws SQLException
	{ inner.setDouble(a, b); }
	
	public String getString(String a) throws SQLException
	{ return inner.getString(a); }
	
	public String getString(int a) throws SQLException
	{ return inner.getString(a); }
	
	public Ref getRef(int a) throws SQLException
	{ return inner.getRef(a); }
	
	public Ref getRef(String a) throws SQLException
	{ return inner.getRef(a); }
	
	public void setURL(String a, URL b) throws SQLException
	{ inner.setURL(a, b); }
	
	public void setTime(String a, Time b) throws SQLException
	{ inner.setTime(a, b); }
	
	public void setTime(String a, Time b, Calendar c) throws SQLException
	{ inner.setTime(a, b, c); }
	
	public Time getTime(int a, Calendar b) throws SQLException
	{ return inner.getTime(a, b); }
	
	public Time getTime(String a) throws SQLException
	{ return inner.getTime(a); }
	
	public Time getTime(int a) throws SQLException
	{ return inner.getTime(a); }
	
	public Time getTime(String a, Calendar b) throws SQLException
	{ return inner.getTime(a, b); }
	
	public Date getDate(int a, Calendar b) throws SQLException
	{ return inner.getDate(a, b); }
	
	public Date getDate(String a) throws SQLException
	{ return inner.getDate(a); }
	
	public Date getDate(int a) throws SQLException
	{ return inner.getDate(a); }
	
	public Date getDate(String a, Calendar b) throws SQLException
	{ return inner.getDate(a, b); }
	
	public void setString(String a, String b) throws SQLException
	{ inner.setString(a, b); }
	
	public Array getArray(int a) throws SQLException
	{ return inner.getArray(a); }
	
	public Array getArray(String a) throws SQLException
	{ return inner.getArray(a); }
	
	public void setDate(String a, Date b, Calendar c) throws SQLException
	{ inner.setDate(a, b, c); }
	
	public void setDate(String a, Date b) throws SQLException
	{ inner.setDate(a, b); }
	
	public ResultSetMetaData getMetaData() throws SQLException
	{ return inner.getMetaData(); }
	
	public ResultSet executeQuery() throws SQLException
	{ return inner.executeQuery(); }
	
	public int executeUpdate() throws SQLException
	{ return inner.executeUpdate(); }
	
	public void addBatch() throws SQLException
	{ inner.addBatch(); }
	
	public void setNull(int a, int b, String c) throws SQLException
	{ inner.setNull(a, b, c); }
	
	public void setNull(int a, int b) throws SQLException
	{ inner.setNull(a, b); }
	
	public void setBigDecimal(int a, BigDecimal b) throws SQLException
	{ inner.setBigDecimal(a, b); }
	
	public void setBytes(int a, byte[] b) throws SQLException
	{ inner.setBytes(a, b); }
	
	public void setTimestamp(int a, Timestamp b, Calendar c) throws SQLException
	{ inner.setTimestamp(a, b, c); }
	
	public void setTimestamp(int a, Timestamp b) throws SQLException
	{ inner.setTimestamp(a, b); }
	
	public void setAsciiStream(int a, InputStream b, int c) throws SQLException
	{ inner.setAsciiStream(a, b, c); }
	
	public void setUnicodeStream(int a, InputStream b, int c) throws SQLException
	{ inner.setUnicodeStream(a, b, c); }
	
	public void setBinaryStream(int a, InputStream b, int c) throws SQLException
	{ inner.setBinaryStream(a, b, c); }
	
	public void clearParameters() throws SQLException
	{ inner.clearParameters(); }
	
	public void setObject(int a, Object b) throws SQLException
	{ inner.setObject(a, b); }
	
	public void setObject(int a, Object b, int c, int d) throws SQLException
	{ inner.setObject(a, b, c, d); }
	
	public void setObject(int a, Object b, int c) throws SQLException
	{ inner.setObject(a, b, c); }
	
	public void setCharacterStream(int a, Reader b, int c) throws SQLException
	{ inner.setCharacterStream(a, b, c); }
	
	public void setRef(int a, Ref b) throws SQLException
	{ inner.setRef(a, b); }
	
	public void setBlob(int a, Blob b) throws SQLException
	{ inner.setBlob(a, b); }
	
	public void setClob(int a, Clob b) throws SQLException
	{ inner.setClob(a, b); }
	
	public void setArray(int a, Array b) throws SQLException
	{ inner.setArray(a, b); }
	
	public ParameterMetaData getParameterMetaData() throws SQLException
	{ return inner.getParameterMetaData(); }
	
	public void setBoolean(int a, boolean b) throws SQLException
	{ inner.setBoolean(a, b); }
	
	public void setByte(int a, byte b) throws SQLException
	{ inner.setByte(a, b); }
	
	public void setShort(int a, short b) throws SQLException
	{ inner.setShort(a, b); }
	
	public void setInt(int a, int b) throws SQLException
	{ inner.setInt(a, b); }
	
	public void setLong(int a, long b) throws SQLException
	{ inner.setLong(a, b); }
	
	public void setFloat(int a, float b) throws SQLException
	{ inner.setFloat(a, b); }
	
	public void setDouble(int a, double b) throws SQLException
	{ inner.setDouble(a, b); }
	
	public void setURL(int a, URL b) throws SQLException
	{ inner.setURL(a, b); }
	
	public void setTime(int a, Time b) throws SQLException
	{ inner.setTime(a, b); }
	
	public void setTime(int a, Time b, Calendar c) throws SQLException
	{ inner.setTime(a, b, c); }
	
	public boolean execute() throws SQLException
	{ return inner.execute(); }
	
	public void setString(int a, String b) throws SQLException
	{ inner.setString(a, b); }
	
	public void setDate(int a, Date b, Calendar c) throws SQLException
	{ inner.setDate(a, b, c); }
	
	public void setDate(int a, Date b) throws SQLException
	{ inner.setDate(a, b); }
	
	public SQLWarning getWarnings() throws SQLException
	{ return inner.getWarnings(); }
	
	public void clearWarnings() throws SQLException
	{ inner.clearWarnings(); }
	
	public void setFetchDirection(int a) throws SQLException
	{ inner.setFetchDirection(a); }
	
	public int getFetchDirection() throws SQLException
	{ return inner.getFetchDirection(); }
	
	public void setFetchSize(int a) throws SQLException
	{ inner.setFetchSize(a); }
	
	public int getFetchSize() throws SQLException
	{ return inner.getFetchSize(); }
	
	public int getResultSetHoldability() throws SQLException
	{ return inner.getResultSetHoldability(); }
	
	public ResultSet executeQuery(String a) throws SQLException
	{ return inner.executeQuery(a); }
	
	public int executeUpdate(String a, int b) throws SQLException
	{ return inner.executeUpdate(a, b); }
	
	public int executeUpdate(String a, String[] b) throws SQLException
	{ return inner.executeUpdate(a, b); }
	
	public int executeUpdate(String a, int[] b) throws SQLException
	{ return inner.executeUpdate(a, b); }
	
	public int executeUpdate(String a) throws SQLException
	{ return inner.executeUpdate(a); }
	
	public int getMaxFieldSize() throws SQLException
	{ return inner.getMaxFieldSize(); }
	
	public void setMaxFieldSize(int a) throws SQLException
	{ inner.setMaxFieldSize(a); }
	
	public int getMaxRows() throws SQLException
	{ return inner.getMaxRows(); }
	
	public void setMaxRows(int a) throws SQLException
	{ inner.setMaxRows(a); }
	
	public void setEscapeProcessing(boolean a) throws SQLException
	{ inner.setEscapeProcessing(a); }
	
	public int getQueryTimeout() throws SQLException
	{ return inner.getQueryTimeout(); }
	
	public void setQueryTimeout(int a) throws SQLException
	{ inner.setQueryTimeout(a); }
	
	public void setCursorName(String a) throws SQLException
	{ inner.setCursorName(a); }
	
	public ResultSet getResultSet() throws SQLException
	{ return inner.getResultSet(); }
	
	public int getUpdateCount() throws SQLException
	{ return inner.getUpdateCount(); }
	
	public boolean getMoreResults() throws SQLException
	{ return inner.getMoreResults(); }
	
	public boolean getMoreResults(int a) throws SQLException
	{ return inner.getMoreResults(a); }
	
	public int getResultSetConcurrency() throws SQLException
	{ return inner.getResultSetConcurrency(); }
	
	public int getResultSetType() throws SQLException
	{ return inner.getResultSetType(); }
	
	public void addBatch(String a) throws SQLException
	{ inner.addBatch(a); }
	
	public void clearBatch() throws SQLException
	{ inner.clearBatch(); }
	
	public int[] executeBatch() throws SQLException
	{ return inner.executeBatch(); }
	
	public ResultSet getGeneratedKeys() throws SQLException
	{ return inner.getGeneratedKeys(); }
	
	public void close() throws SQLException
	{ inner.close(); }
	
	public boolean execute(String a, int b) throws SQLException
	{ return inner.execute(a, b); }
	
	public boolean execute(String a) throws SQLException
	{ return inner.execute(a); }
	
	public boolean execute(String a, int[] b) throws SQLException
	{ return inner.execute(a, b); }
	
	public boolean execute(String a, String[] b) throws SQLException
	{ return inner.execute(a, b); }
	
	public Connection getConnection() throws SQLException
	{ return inner.getConnection(); }
	
	public void cancel() throws SQLException
	{ inner.cancel(); }
	
	// JDCB 4.0

	public boolean isClosed() throws SQLException {
		return inner.isClosed();
	}

	public boolean isPoolable() throws SQLException {
		return inner.isPoolable();
	}

	public void setPoolable(boolean poolable) throws SQLException {
		inner.setPoolable(poolable);
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

	public void setAsciiStream(int parameterIndex, InputStream x)
			throws SQLException {
		inner.setAsciiStream(parameterIndex, x);
	}

	public void setAsciiStream(int parameterIndex, InputStream x,
			long length) throws SQLException {
		inner.setAsciiStream(parameterIndex, x, length);
	}

	public void setBinaryStream(int parameterIndex, InputStream x)
			throws SQLException {
		inner.setBinaryStream(parameterIndex, x);
	}

	public void setBinaryStream(int parameterIndex, InputStream x,
			long length) throws SQLException {
		inner.setBinaryStream(parameterIndex, x, length);
	}

	public void setBlob(int parameterIndex, InputStream inputStream)
			throws SQLException {
		inner.setBlob(parameterIndex, inputStream);
	}

	public void setBlob(int parameterIndex, InputStream inputStream,
			long length) throws SQLException {
		inner.setBlob(parameterIndex, inputStream, length);
	}

	public void setCharacterStream(int parameterIndex, Reader reader)
			throws SQLException {
		inner.setCharacterStream(parameterIndex, reader);
	}

	public void setCharacterStream(int parameterIndex, Reader reader,
			long length) throws SQLException {
		inner.setCharacterStream(parameterIndex, reader, length);
	}

	public void setClob(int parameterIndex, Reader reader)
			throws SQLException {
		inner.setClob(parameterIndex, reader);
	}

	public void setClob(int parameterIndex, Reader reader, long length)
			throws SQLException {
		inner.setClob(parameterIndex, reader, length);
	}

	public void setNCharacterStream(int parameterIndex, Reader value)
			throws SQLException {
		inner.setNCharacterStream(parameterIndex, value);
	}

	public void setNCharacterStream(int parameterIndex, Reader value,
			long length) throws SQLException {
		inner.setNCharacterStream(parameterIndex, value, length);
	}

	public void setNClob(int parameterIndex, NClob value)
			throws SQLException {
		inner.setNClob(parameterIndex, value);
	}

	public void setNClob(int parameterIndex, Reader reader)
			throws SQLException {
		inner.setNClob(parameterIndex, reader);
	}

	public void setNClob(int parameterIndex, Reader reader, long length)
			throws SQLException {
		inner.setNClob(parameterIndex, reader, length);
	}

	public void setNString(int parameterIndex, String value)
			throws SQLException {
		inner.setNString(parameterIndex, value);
	}

	public void setRowId(int parameterIndex, RowId x)
			throws SQLException {
		inner.setRowId(parameterIndex, x);
	}

	public void setSQLXML(int parameterIndex, SQLXML xmlObject)
			throws SQLException {
		inner.setSQLXML(parameterIndex, xmlObject);
	}
	

	public Reader getCharacterStream(int parameterIndex)
			throws SQLException {
		return inner.getCharacterStream(parameterIndex);
	}

	public Reader getCharacterStream(String parameterName)
			throws SQLException {
		return inner.getCharacterStream(parameterName);
	}

	public Reader getNCharacterStream(int parameterIndex)
			throws SQLException {
		return inner.getNCharacterStream(parameterIndex);
	}

	public Reader getNCharacterStream(String parameterName)
			throws SQLException {
		return inner.getNCharacterStream(parameterName);
	}

	public NClob getNClob(int parameterIndex) throws SQLException {
		return inner.getNClob(parameterIndex);
	}

	public NClob getNClob(String parameterName) throws SQLException {
		return inner.getNClob(parameterName);
	}

	public String getNString(int parameterIndex) throws SQLException {
		return inner.getNString(parameterIndex);
	}

	public String getNString(String parameterName) throws SQLException {
		return inner.getNString(parameterName);
	}

	public RowId getRowId(int parameterIndex) throws SQLException {
		return inner.getRowId(parameterIndex);
	}

	public RowId getRowId(String parameterName) throws SQLException {
		return inner.getRowId(parameterName);
	}

	public SQLXML getSQLXML(int parameterIndex) throws SQLException {
		return inner.getSQLXML(parameterIndex);
	}

	public SQLXML getSQLXML(String parameterName) throws SQLException {
		return inner.getSQLXML(parameterName);
	}

	public void setAsciiStream(String parameterName, InputStream x)
			throws SQLException {
		inner.setAsciiStream(parameterName, x);
	}

	public void setAsciiStream(String parameterName, InputStream x,
			long length) throws SQLException {
		inner.setAsciiStream(parameterName, x, length);
	}

	public void setBinaryStream(String parameterName, InputStream x)
			throws SQLException {
		inner.setBinaryStream(parameterName, x);
	}

	public void setBinaryStream(String parameterName, InputStream x,
			long length) throws SQLException {
		inner.setBinaryStream(parameterName, x, length);
	}

	public void setBlob(String parameterName, Blob x)
			throws SQLException {
		inner.setBlob(parameterName, x);
	}

	public void setBlob(String parameterName, InputStream inputStream)
			throws SQLException {
		inner.setBlob(parameterName, inputStream);
	}

	public void setBlob(String parameterName, InputStream inputStream,
			long length) throws SQLException {
		inner.setBlob(parameterName, inputStream, length);
	}

	public void setCharacterStream(String parameterName, Reader reader)
			throws SQLException {
		inner.setCharacterStream(parameterName, reader);
	}

	public void setCharacterStream(String parameterName, Reader reader,
			long length) throws SQLException {
		inner.setCharacterStream(parameterName, reader, length);
	}

	public void setClob(String parameterName, Clob x)
			throws SQLException {
		inner.setClob(parameterName, x);
	}

	public void setClob(String parameterName, Reader reader)
			throws SQLException {
		inner.setClob(parameterName, reader);
	}

	public void setClob(String parameterName, Reader reader, long length)
			throws SQLException {
		inner.setClob(parameterName, reader, length);
	}

	public void setNCharacterStream(String parameterName, Reader value)
			throws SQLException {
		inner.setNCharacterStream(parameterName, value);
	}

	public void setNCharacterStream(String parameterName, Reader value,
			long length) throws SQLException {
		inner.setNCharacterStream(parameterName, value, length);
	}

	public void setNClob(String parameterName, NClob value)
			throws SQLException {
		inner.setNClob(parameterName, value);
	}

	public void setNClob(String parameterName, Reader reader)
			throws SQLException {
		inner.setNClob(parameterName, reader);
	}

	public void setNClob(String parameterName, Reader reader,
			long length) throws SQLException {
		inner.setNClob(parameterName, reader, length);
	}

	public void setNString(String parameterName, String value)
			throws SQLException {
		inner.setNString(parameterName, value);
	}

	public void setRowId(String parameterName, RowId x)
			throws SQLException {
		inner.setRowId(parameterName, x);
	}

	public void setSQLXML(String parameterName, SQLXML xmlObject)
			throws SQLException {
		inner.setSQLXML(parameterName, xmlObject);
	}

	// JDBC 4.1

	public void closeOnCompletion() throws SQLException {
		//inner.closeOnCompletion();
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public boolean isCloseOnCompletion() throws SQLException {
		//return inner.isCloseOnCompletion();
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public Object getObject(int parameterIndex, Class type)
			throws SQLException {
		//return inner.getObject(parameterIndex, type);
		throw new java.sql.SQLFeatureNotSupportedException();
	}

	public Object getObject(String parameterName, Class type)
			throws SQLException {
		//return inner.getObject(parameterName, type);
		throw new java.sql.SQLFeatureNotSupportedException();
	}
}
