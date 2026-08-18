/*
 * Copyright 2009 IIZUKA Software Technologies Ltd
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.googlecode.jtype;

import java.lang.reflect.GenericArrayType;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;

/**
 * 
 * 
 * @author Mark Hobson
 * @version $Id: TypeVisitor.java 111 2011-11-23 17:25:02Z markhobson $
 */
public interface TypeVisitor
{
	void visit(Class<?> type);

	// TODO: rename to visit
	<D extends GenericDeclaration> boolean beginVisit(TypeVariable<D> type);
	
	void visitTypeVariableBound(Type bound, int index);
	
	<D extends GenericDeclaration> void endVisit(TypeVariable<D> type);
	
	void visit(GenericArrayType type);
	
	// TODO: rename to visit
	boolean beginVisit(ParameterizedType type);
	
	void visitActualTypeArgument(Type type, int index);
	
	void endVisit(ParameterizedType type);
	
	// TODO: rename to visit
	boolean beginVisit(WildcardType type);
	
	void visitUpperBound(Type bound, int index);
	
	void visitLowerBound(Type bound, int index);

	void endVisit(WildcardType type);
}
