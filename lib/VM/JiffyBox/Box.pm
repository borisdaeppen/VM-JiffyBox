package VM::JiffyBox::Box;

# ABSTRACT: Representation of a Virtual Machine in JiffyBox

use Moo;
use JSON;
use LWP::UserAgent;

has id => (is => 'ro');
has hypervisor => (is => 'rw');

sub get_backup_id {
    my $self = shift;
}

sub get_details {
    my $self = shift;

    my $token = $self->{hypervisor}->token;
    my $version = $self->{hypervisor}->version; 
    my $test_mode = $self->{hypervisor}->test_mode;
    my $id = $self->id;
        
    my $url = 'https://api.jiffybox.de/' . $token . '/' . $version . '/jiffyBoxes/' . $id;
    
    if ($test_mode) {
        return $url;
    } else {
        my $ua = LWP::UserAgent->new();
        
        my $details = $ua->get($url);    
        if ($details->is_success) {
            return from_json($details->decoded_content);
        } else {
            return "FAIL";
        }
    }
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

=head1 PLEASE NOTE

This module ist still under heavy development and a B<TRIAL> version.
We do not recommend to use or even test it.

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

=head1 METHODS

=head2 get_backup_id()

=head2 get_details()

=head2 start()

=head2 stop()

=head2 delete()

=head1 SEE ALSO

=over

=item * L<https://github.com/tim-schwarz/VM-JiffyBox>

=back

