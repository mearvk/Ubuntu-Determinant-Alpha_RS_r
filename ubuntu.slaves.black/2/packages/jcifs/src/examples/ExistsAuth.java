import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;

public class ExistsAuth {

    public static void main( String argv[] ) throws Exception {

        SmbFile f = new SmbFile(argv[0], new NtlmPasswordAuthentication(argv[1], argv[2], argv[3]));
        if( f.exists() ) {
            System.out.println("exists" );
        } else {
            System.out.println("does not exist" );
        }
    }
}

