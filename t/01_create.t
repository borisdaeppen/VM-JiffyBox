use Test::More tests => 10;
use Test::Exception;

my $module = 'VM::JiffyBox';
require_ok($module);
require_ok('VM::JiffyBox::Box');

can_ok($module, 'new'); 

dies_ok{$module->new()} 'Die if no Token'; 

my $token = 'MyToken';
my $jiffy = $module->new(token => $token);
isa_ok($jiffy, $module);

is($jiffy->token, $token, 'Check Token');

can_ok($jiffy, 'get_vm'); 

TODO: {
    local $TODO = "Die on missing ID has to be implemented";
    dies_ok{$jiffy->get_vm()} 'Die if no ID';
}

my $box_id = 'MyBoxID';
my $box = $jiffy->get_vm($box_id);

is($box->id, $box_id, 'Check ID');
is($box->{hypervisor}->token, $token, 'Check Token @ Box');
