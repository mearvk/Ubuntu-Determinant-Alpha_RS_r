/*
 * This class was automatically generated with 
 * <a href="http://www.castor.org">Castor 1.3.0.1</a>, using an XML
 * Schema.
 * $Id$
 */

package org.exolab.castor.xml.schema.annotations.jdo.types;

/**
 * Class TableAccessModeType.
 * 
 * @version $Revision$ $Date$
 */
public class TableAccessModeType implements java.io.Serializable {


      //--------------------------/
     //- Class/Member Variables -/
    //--------------------------/

    /**
     * The read-only type
     */
    public static final int READ_ONLY_TYPE = 0;

    /**
     * The instance of the read-only type
     */
    public static final TableAccessModeType READ_ONLY = new TableAccessModeType(READ_ONLY_TYPE, "read-only");

    /**
     * The shared type
     */
    public static final int SHARED_TYPE = 1;

    /**
     * The instance of the shared type
     */
    public static final TableAccessModeType SHARED = new TableAccessModeType(SHARED_TYPE, "shared");

    /**
     * The exclusive type
     */
    public static final int EXCLUSIVE_TYPE = 2;

    /**
     * The instance of the exclusive type
     */
    public static final TableAccessModeType EXCLUSIVE = new TableAccessModeType(EXCLUSIVE_TYPE, "exclusive");

    /**
     * The db-locked type
     */
    public static final int DB_LOCKED_TYPE = 3;

    /**
     * The instance of the db-locked type
     */
    public static final TableAccessModeType DB_LOCKED = new TableAccessModeType(DB_LOCKED_TYPE, "db-locked");

    /**
     * Field _memberTable.
     */
    private static java.util.Hashtable _memberTable = init();

    /**
     * Field type.
     */
    private final int type;

    /**
     * Field stringValue.
     */
    private java.lang.String stringValue = null;


      //----------------/
     //- Constructors -/
    //----------------/

    private TableAccessModeType(final int type, final java.lang.String value) {
        super();
        this.type = type;
        this.stringValue = value;
    }


      //-----------/
     //- Methods -/
    //-----------/

    /**
     * Method enumerate.Returns an enumeration of all possible
     * instances of TableAccessModeType
     * 
     * @return an Enumeration over all possible instances of
     * TableAccessModeType
     */
    public static java.util.Enumeration enumerate(
    ) {
        return _memberTable.elements();
    }

    /**
     * Method getType.Returns the type of this TableAccessModeType
     * 
     * @return the type of this TableAccessModeType
     */
    public int getType(
    ) {
        return this.type;
    }

    /**
     * Method init.
     * 
     * @return the initialized Hashtable for the member table
     */
    private static java.util.Hashtable init(
    ) {
        java.util.Hashtable members = new java.util.Hashtable();
        members.put("read-only", READ_ONLY);
        members.put("shared", SHARED);
        members.put("exclusive", EXCLUSIVE);
        members.put("db-locked", DB_LOCKED);
        return members;
    }

    /**
     * Method readResolve. will be called during deserialization to
     * replace the deserialized object with the correct constant
     * instance.
     * 
     * @return this deserialized object
     */
    private java.lang.Object readResolve(
    ) {
        return valueOf(this.stringValue);
    }

    /**
     * Method toString.Returns the String representation of this
     * TableAccessModeType
     * 
     * @return the String representation of this TableAccessModeType
     */
    public java.lang.String toString(
    ) {
        return this.stringValue;
    }

    /**
     * Method valueOf.Returns a new TableAccessModeType based on
     * the given String value.
     * 
     * @param string
     * @return the TableAccessModeType value of parameter 'string'
     */
    public static org.exolab.castor.xml.schema.annotations.jdo.types.TableAccessModeType valueOf(
            final java.lang.String string) {
        java.lang.Object obj = null;
        if (string != null) {
            obj = _memberTable.get(string);
        }
        if (obj == null) {
            String err = "" + string + " is not a valid TableAccessModeType";
            throw new IllegalArgumentException(err);
        }
        return (TableAccessModeType) obj;
    }

}
