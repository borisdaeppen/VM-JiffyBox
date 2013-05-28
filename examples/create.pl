use VM::JiffyBox;

my $jiffy = VM::JiffyBox->new(token => 'MyToken');
my $box = $jiffy->get_vm('MyBoxID');

print $jiffy->token;
print "\n";

print $box->{hypervisor}->token;
print "\n";
print $box->id;
print "\n";

