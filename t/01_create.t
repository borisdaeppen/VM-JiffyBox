use Test::More tests => 8;

my $module = 'VM::JiffyBox';
require_ok($module);
require_ok('VM::JiffyBox::Box');

my $token = 'MyToken';
can_ok($module, 'new'); 
my $jiffy = $module->new(token => $token);
isa_ok($jiffy, $module);
is($jiffy->token, $token, 'Check Token');

my $box_id = 'MyBoxID';
can_ok($jiffy, 'get_vm'); 
my $box = $jiffy->get_vm($box_id);
is($box->id, $box_id, 'Check ID');

is($box->{hypervisor}->token, $token, 'Check Token @ Box');
