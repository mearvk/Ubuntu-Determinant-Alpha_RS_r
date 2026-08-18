/**
 * 
 */
package org.hibernate.annotations.common.test.annotationfactory;

/**
 * @author Paolo Perrotta
 * @author Davide Marchignoli
 */
public @interface TestAnnotation {
	String stringElement();

	String elementWithDefault() default "abc";

	boolean booleanElement();

	String someOtherElement();
}