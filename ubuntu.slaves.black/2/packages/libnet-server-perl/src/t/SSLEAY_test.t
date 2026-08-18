#!/usr/bin/env perl

package Net::Server::Test;
use strict;
use FindBin qw($Bin);
use lib $Bin;
use NetServerTest qw(prepare_test ok use_ok diag skip);
my $env = prepare_test({n_tests => 4, start_port => 20200, n_ports => 2}); # runs three of its own tests

if (! eval { require File::Temp }
    || ! eval { require Net::SSLeay }
   ) {
  SKIP: { skip("Cannot load Net::SSleay libraries to test Socket SSL server: $@", 1); };
    exit;
}
if (! eval { require Net::Server::Proto::SSLEAY }) {
    diag "Cannot load SSLEAY library on this platform: $@";
  SKIP: { skip("Skipping tests on this platform", 1); };
    exit;
}

my $pem = << 'PEM'; # this certificate is invalid, please only use for testing
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIUA8Xm/EUFCN3yY1jqQqfivcJPAxcwDQYJKoZIhvcNAQEL
BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMDA0MDExMzA5MDRaFw00NzA4
MTgxMzA5MDRaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQDH7zYyow2nvRQeqa8dPtJCi65OcDvWUmL4Fazxas56
kYHv3gdEAVcxrW1AFhziDNvrsLiWE9WfFoav9xEPtXvDsY9+2rsNoiTUzPgvYaFG
5Uz43sz4gqxbndxWTtMbpFA0zrhXnAHm4EUM2ykU04KQXHMGFTAHb+c7ARKMg7+B
H6j4XiSEZenWRqh9bE71wIMs2gvsRuVzTZrobzYHSrHJYyhjBoEmWahm9PFAfkvF
tZl9hmaz0jPYDmHdzqusMT3lNvZucGn76Z+8KCFmnMb8lGmfMBbumHpjiJ53DLGK
KEhR7kK/86t9lnAdvcIPlDTJPk/xHoxXhbHcKtEnnKat1a3/THSTrGT96OYlpjm/
JwjbLoFGjT9D06oajWY/lt/CeAQy76qRHqJVJyZ2j9TXw3tEQvawTxPMPIE+iKfs
78OG4d/j9M1R4tkPQdwD8VCVJB7e6+2HlbPai/djMUqkj2stMZ3sgv5ehHae0xth
BM29I/TdOLfgP8S3EGqVVYcyRAWKYvGYwgGEvocmiUgXjowOsOt1h5a+CD/Qfodg
6qfilPpD2aZYqcPSn5Htqp+pkjMpWC1aMflxQbxvXcJFTzGbc4HslqJhbLXe/fwR
2scOg8ZEt8Y94sF/7Y+GLDaJnV8ObmdMttzx7HWdQMtPkFvo4/h7fseG/bA4/SoX
xQIDAQABo1MwUTAdBgNVHQ4EFgQUntWE93uYLQ+bbKqFswQyG0aqZkowHwYDVR0j
BBgwFoAUntWE93uYLQ+bbKqFswQyG0aqZkowDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAgEAt2+PAKmobIRb4+5vGgfhLzPW97yCi03szpfe9mUwmeFN
EcLXRl1t2lyLc/Ucn8pSUTfEv1WT96JYbTurUkM1iLi+y5jJeS8qAA59Me1HcPvF
vMy7MG/Fam0wU/wEC0wzWwPDDIUG5PM9rk9vkBmZ44TltE//i2wbh8Zo7z1nNUDy
ms6K8pQjoG7SJefHbCjyqYrm17pb2/ClIZuZWs8rvot/9zslKiDKNK4ewdY0iONy
q861PZ+TqdTpxm8ouBkpQA2ggIZNcfwO/KVr6nqBVp072dXlaSRiBD+z4CNnGb4b
Gz931Iev0zTKY3m9uL8jNO36BRB4paIaDexeYxK01L2mFHkCZOukhYOB4qli8+4y
/vlOaMuuhVeQNdjjq2t1k1wP1+1QjHdyimenDYFnvzTnu7hBr5Wgs0/sxCBug9aJ
/v6rW/kItPbLmgoo6Q9sJWEzJBjUzacaus/7HYa2XMQ6qq+dP+HMcaCtDCzbKgyJ
w1EMMd4f/uZeinE5BDljhSuJLl6vVP0WyBR3CYQdbpQlc1Koansr/j97OyZtwTmY
6+xIh1WATcvrzSVJiLJb9zTcOg8SXtAHpAkpEGQk1kDiJUP+3AN2uOT3KrlxSjCg
skbx0I2wRdK4UvTr3WAakSjdmxMoHzAyoZ1OqBiz9ndGWWY8i5acAlcgFIfa730=
-----END CERTIFICATE-----
-----BEGIN PRIVATE KEY-----
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
k+WUbp8EAMRqFNRRLcPzcux5vlLvOtw=
-----END PRIVATE KEY-----
PEM

my ($pem_fh, $pem_filename) =
  File::Temp::tempfile(SUFFIX => '.pem', UNLINK => 1);
print $pem_fh $pem;
$pem_fh->close;

require Net::Server;
@Net::Server::Test::ISA = qw(Net::Server);

sub accept {
    my $self = shift;
    exit if $^O eq 'MSWin32' && $self->{'__one_accept_only'}++;
    $env->{'signal_ready_to_test'}->();
    return $self->SUPER::accept(@_);
}

sub process_request {
    my $self = shift;
    my $client = $self->{'server'}->{'client'};
    return $self->SUPER::process_request if $client->NS_port == $env->{'ports'}->[1];
    my $offset = 0;
    my $total = 0;
    my $buf;

    # Wait data
    my $vec = '';
    vec($vec, $client->fileno, 1) = 1;

    until ($buf) {
        select($vec, undef, undef, undef);
        $client->sysread(\$buf, 100, $total);
    }

    select(undef, $vec, undef, undef);

    $client->syswrite($buf);

    $self->server_close;
}

my $ok = eval {
    local $SIG{'ALRM'} = sub { die "Timeout\n" };
    alarm $env->{'timeout'};
    my $ppid = $$;
    my $pid = fork;
    die "Trouble forking: $!" if ! defined $pid;

    ### parent does the client
    if ($pid) {
        $env->{'block_until_ready_to_test'}->();

        my $remote = NetServerTest::client_connect(PeerAddr => $env->{'hostname'}, PeerPort => $env->{'ports'}->[1]) || die "Couldn't open child to sock: $!";

        my $ctx = Net::SSLeay::CTX_new()
            or Net::SSLeay::die_now("Failed to create SSL_CTX $!");
        Net::SSLeay::CTX_set_options($ctx, &Net::SSLeay::OP_ALL)
            and Net::SSLeay::die_if_ssl_error("ssl ctx set options");
        my $ssl = Net::SSLeay::new($ctx)
            or Net::SSLeay::die_now("Failed to create SSL $!");
        Net::SSLeay::set_fd($ssl, $remote->fileno);
        Net::SSLeay::connect($ssl);
        my $line = Net::SSLeay::read($ssl);
        die "Didn't get the type of line we were expecting: ($line)" if $line !~ /Net::Server/;
        diag $line;
        Net::SSLeay::write($ssl, "quit\n");
        my $line2 = Net::SSLeay::read($ssl);
        diag $line2;


        $remote = NetServerTest::client_connect(PeerAddr => $env->{'hostname'}, PeerPort => $env->{'ports'}->[0]) || die "Couldn't open child to sock: $!";

        $ctx = Net::SSLeay::CTX_new()
            or Net::SSLeay::die_now("Failed to create SSL_CTX $!");
        Net::SSLeay::CTX_set_options($ctx, &Net::SSLeay::OP_ALL)
            and Net::SSLeay::die_if_ssl_error("ssl ctx set options");
        $ssl = Net::SSLeay::new($ctx)
            or Net::SSLeay::die_now("Failed to create SSL $!");

        Net::SSLeay::set_fd($ssl, $remote->fileno);
        Net::SSLeay::connect($ssl);

        Net::SSLeay::write($ssl, "foo bar");
        my $res = Net::SSLeay::read($ssl);
        return $res eq "foo bar";

    ### child does the server
    } else {
        eval {
            alarm $env->{'timeout'};
            close STDERR;
            Net::Server::Test->run(
                host  => $env->{'hostname'},
                port  => $env->{'ports'},
                ipv   => $env->{'ipv'},
                proto => 'ssleay',
                background => 0,
                setsid => 0,
                SSL_cert_file => $pem_filename,
                SSL_key_file  => $pem_filename,
                );
        } || do {
            diag("Trouble running server: $@");
            kill(9, $ppid) && ok(0, "Failed during run of server");
        };
        exit;
    }
    alarm(0);
};
alarm(0);
ok($ok, "Got the correct output from the server") || diag("Error: $@");
