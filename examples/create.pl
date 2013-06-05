use VM::JiffyBox;
use Data::Dumper;

unless ( $ARGV[0] ) {
    print "Auth-Token as first argument needed!\n";
    exit 1;
}
unless ( $ARGV[1] ) {
    print "Box-ID as second argument needed!\n";
    exit 1;
}

my $jiffy = VM::JiffyBox->new(token => $ARGV[0], test_mode => 1);
print "VM::JiffyBox\n";
if ($jiffy->test_mode) {
   print "Test-Mode: ON\n";
} else {
   print "Test-Mode: OFF\n" 
}
print "Token: " . $jiffy->token . "\n";
print "Version: " . $jiffy->version . "\n";

print "\n";

my $box = $jiffy->get_vm($ARGV[1]);
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

print "URL:\n";
my $box_details = $box->get_details();
print Dumper($box_details) . "\n";

print "LIVE:\n";
$jiffy->test_mode = 0;
my $box_details2 = $box->get_details();
print Dumper($box_details2) . "\n";

