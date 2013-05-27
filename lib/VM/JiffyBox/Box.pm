package VM::JiffyBox::Box;

use Moo;

has id => (is => 'ro');
has hypervisor => (is => 'rw');

sub get_backup_id {
    my $self = shift;
}

sub get_details {
    my $self = shift;
}

sub start {
    my $self = shift;
}

sub stop {
    my $self = shift;
}

sub delete {
    my $self = shift;
}

1;

__END__

=encoding utf8

=head1 NAME

VM::JiffyBox::Box

=head1 SYNOPSIS

 use VM::JiffyBox;

 my $jiffy = VM::JiffyBox->new($token);

 my $box_id = $jiffy->get_id_from_name($box_name);
 my $box    = $jiffy->get_vm($box_id);

 my $backup_id = $box->get_backup_id();
 my $new_box   = $jiffy->create_vm($backup_id);
 $new_box->start();

 my $new_box_details = $new_box->get_details();

 $new_box->stop();
 $new_box->delete();

 1;

=head1 DESCRIPTION

=head1 METHODS

=head2 get_backup_id()

=head2 get_details()

=head2 start()

=head2 stop()

=head2 delete()
