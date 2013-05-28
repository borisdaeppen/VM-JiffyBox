use VM::JiffyBox;

my $jiffy = VM::JiffyBox->new(token => 'MyToken');
my $box = $jiffy->get_vm('MyBoxID');

print "< JIFFY >\n";
print $jiffy->token . "\n";
print $jiffy->version . "\n";

print "\n";

print "< BOX >\n";
print $box->{hypervisor}->token . "\n";
print $box->{hypervisor}->version . "\n";
print $box->id . "\n";

print "\n";

my $jiffy2 = VM::JiffyBox->new(token => 'MyToken', version => 'v1.1');

print "< JIFFY2 >\n";
print $jiffy2->version;

print "\n";
