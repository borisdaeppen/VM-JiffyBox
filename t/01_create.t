use Test::More tests => 7;

my $module = 'VM::JiffyBox';
require_ok($module);
require_ok('VM::JiffyBox::Box');

my $token = 'MyToken';
my $jiffy = $module->new(token => $token);
isa_ok($jiffy, $module);
is($jiffy->token, $token, 'Check Token');

can_ok($jiffy, 'get_vm'); 
my $box_id = 'MyBoxID';
my $box = $jiffy->get_vm($box_id);
is($box->id, $box_id, 'Check ID');

is($box->{hypervisor}->token, $token, 'Check Token @ Box');
