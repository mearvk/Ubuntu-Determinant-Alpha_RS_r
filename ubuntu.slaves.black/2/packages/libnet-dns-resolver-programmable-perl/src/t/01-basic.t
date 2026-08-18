#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 17;

use Net::DNS::Resolver::Programmable;


diag(
    "Testing Net::DNS::Resolver::Programmable "
    . $Net::DNS::Resolver::Programmable::VERSION .", Perl $], $^X"
);


my $domain = "example.com";
my $fake_ns = "ns1.$domain";
# Set up resolver with a fake record
my $resolver = Net::DNS::Resolver::Programmable->new(
    records         => {
        'example.com'     => [
            Net::DNS::RR->new("$domain. 86400  A  127.0.0.5"),
            Net::DNS::RR->new("$domain. 86400 NS $fake_ns."),
        ],
        'ns1.example.com' => [
            Net::DNS::RR->new("$fake_ns. 86400 A 127.0.0.6"),
        ],
    },
);

# Check that we get that fake record
my $reply = $resolver->query($domain);

is(ref($reply), "Net::DNS::Packet", "Got a Net::DNS::Packet back for $domain");

my ($rr) = $reply->answer;

is($rr->type, "A", "Got a Net::DNS::RR::A object");
is($rr->address, "127.0.0.5", "Correct answer for $domain as mocked");

# Ditto for the address of our fake NS
$reply = $resolver->query($fake_ns);

is(ref($reply), "Net::DNS::Packet", "Got a Net::DNS::Packet back for $fake_ns");

($rr) = $reply->answer;

is($rr->type, "A", "Got a Net::DNS::RR::A object for $fake_ns");
is($rr->address, "127.0.0.6", "Correct answer as mocked for $fake_ns");


# And an NS lookup works, too
$reply = $resolver->query($domain, 'NS');

is(ref($reply), "Net::DNS::Packet",
    "Got a Net::DNS::Packet back for NS $domain");

($rr) = $reply->answer;

is($rr->type, "NS", "Got a Net::DNS::RR::NS object for NS $domain");
is($rr->nsdname, $fake_ns, "Correct NS answer as mocked for $domain");


# We can also do a lookup by passing in a Net::DNS::Packet object
my $packet = Net::DNS::Packet->new($domain, "A", "IN");
$reply = $resolver->send($packet);
is(ref($reply), "Net::DNS::Packet",
    "got a Packet object back from send(\$packet)");
($rr) = $reply->answer;
ok($rr, "Got an answer in that packet");
is ($rr->type, "A", 
    "Got a Net::DNS::RR::A object for $domain from send(\$packet)");
is($rr->address, "127.0.0.5", "... and it contains the expected answer");

my $unmocked = "www.google.com";

# A query() that shouldn't match any of the mocked entries we set up
# gets undef
$reply = $resolver->query($unmocked);

ok(!$reply, "No reply for a query() on unmocked name $unmocked");


# send() on the other hand gets a packet back with the expected rcode
$reply = $resolver->send($unmocked);

is(ref($reply),
    "Net::DNS::Packet",
    "Got a Net::DNS::Packet back from send() on unmocked name $unmocked",
);

is(
    $reply->header->rcode,
    "NOERROR",
    "Expected NOERROR rcode for lookup that doesn't match mocks",
);

($rr) = $reply->answer;

is($rr, undef, "No answer for lookup that doesn't match mocks");
