package VM::JiffyBox::Box;

# ABSTRACT: Representation of a Virtual Machine in JiffyBox

use Moo;
use JSON;
use LWP::UserAgent;

has id         => (is => 'ro');
has hypervisor => (is => 'rw');

# TODO
sub get_backup_id {
    my $self = shift;
}

sub get_details {
    my $self = shift;

    # add request specific stuff to base url
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # if in test_mode we don't do any real request,
    if ($self->{hypervisor}->test_mode) {

        # but just return the plain URL
        return $url;
    }
    # no test_mode, we do some serious requests
    else {
        my $ua = LWP::UserAgent->new();
        
        # do HTTP-request to API
        my $details = $ua->get($url);    

        # check result
        if ($details->is_success) {

            # return JSON as a Perl-structure
            return from_json($details->decoded_content);

        }
        else {
            return 0;
        }
    }
}

# TODO
sub start {
    my $self = shift;
}

# TODO
sub stop {
    my $self = shift;
}

# TODO
sub delete {
    my $self = shift;
}

1;

__END__

=encoding utf8

=head1 PLEASE NOTE

This module ist still under heavy development and a B<TRIAL> release.
We do not recommend to use it.

=head1 SYNOPSIS

See the C<examples> directory for examples of working code.
Synopsis will come when first stable release is here.

=head1 SEE ALSO

=over

=item * L<https://github.com/tim-schwarz/VM-JiffyBox>

=back

