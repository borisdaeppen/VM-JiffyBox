use VM::JiffyBox;
use Data::Dumper;

# script musst be called like this:
#     ./script.pl $AUTH_TOKEN $BOX_ID

unless ( $ARGV[0] ) {
    print "Auth-Token as first argument needed!\n";
    exit 1;
}
unless ( $ARGV[1] ) {
    print "Box-ID as second argument needed!\n";
    exit 1;
}

# create a hypervisor with test_mode on
my $jiffy = VM::JiffyBox->new(token => $ARGV[0], test_mode => 1);

# get a specific box
my $box = $jiffy->get_vm($ARGV[1]);

# do a request to this box
# since we have test_mode enabled it will just return the URL for the API
my $req_url = $box->get_details();

# we print out the URL
print "URL for request is:\n\t$req_url\n\n";

# we change the status of the box and disable test_mode
$jiffy->test_mode = 0;

# do the same request again, this time live!
my $box_details = $box->get_details();

print "Result from request is:\n";
print Dumper($box_details) . "\n";

