use Test::More tests=>4;
use Net::IP;

my $obj = Net::IP->new('10.10.0.0/31');
is($obj->reverse_ip, '0.10.10.in-addr.arpa.', 'reverse_ip');
$obj->set('192.168.0.0/24');
is($obj->reverse_ip, '0.168.192.in-addr.arpa.', 'reverse_ip');
$obj->set('192.0.0.0/24');
is($obj->reverse_ip, '0.0.192.in-addr.arpa.', 'reverse_ip');
$obj->set('192.0.0.0/32');
is($obj->reverse_ip, '0.0.0.192.in-addr.arpa.', 'reverse_ip');


