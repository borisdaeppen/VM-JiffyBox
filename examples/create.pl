use VM::JiffyBox;
use Data::Dumper;

my $jiffy = VM::JiffyBox->new(token => 'TOKEN', test_mode => 1);
print "VM::JiffyBox\n";
if ($jiffy->test_mode) {
   print "Test-Mode: ON\n";
} else {
   print "Test-Mode: OFF\n" 
}
print "Token: " . $jiffy->token . "\n";
print "Version: " . $jiffy->version . "\n";

print "\n";

my $box = $jiffy->get_vm('BOXID');
print "VM::JiffyBox::Box\n";
if ($box->{hypervisor}->test_mode) {
   print "Test-Mode: ON\n";
} else {
   print "Test-Mode: OFF\n" 
}
print "Token: " . $box->{hypervisor}->token . "\n";
print "Version: " . $box->{hypervisor}->version . "\n";
print "Box-ID: " . $box->id . "\n";

print "\n";

my $box_details = $box->get_details();
print Dumper($box_details) . "\n";
