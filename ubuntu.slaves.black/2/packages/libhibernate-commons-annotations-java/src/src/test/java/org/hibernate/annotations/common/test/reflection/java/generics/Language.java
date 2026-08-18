//$Id: Language.java 11282 2007-03-14 22:05:59Z epbernard $
package org.hibernate.annotations.common.test.reflection.java.generics;

/**
 * @author Emmanuel Bernard
 */
public interface Language<T> {
	T getLanguage();
}
