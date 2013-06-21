use strict;
use warnings;

use feature qw(say);

use VM::JiffyBox;

# check commandline arguments

my $auth_token = '';
my $box_name   = '';
unless ($ARGV[0]) {
    say 'Token as first argument needed!';
    exit 1;
}
unless ($ARGV[1]) {
    say 'BoxName as second argument needed!';
    exit 1;
}
$auth_token = $ARGV[0];
$box_name   = $ARGV[1];

# prepare connection to VM-Server
my $jiffy = VM::JiffyBox->new(token => $auth_token); 

# translate VM-Name (String) to ID (Number)
my $master_box_id = $jiffy->get_id_from_name($box_name);

say "master_box_id: $master_box_id";

# prepare connection to the VM
my $master_box = $jiffy->get_vm($master_box_id);

# collect information about the VM
my $backup_id  = $master_box->get_backups()->{result}->{daily}->{id};
my $plan_id    = $master_box->get_details()->{result}->{plan}->{id};

say "backup_id: $backup_id";
say "plan_id: $plan_id";

# create a clone of the VM
# ...

