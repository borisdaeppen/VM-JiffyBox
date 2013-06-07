package VM::JiffyBox;

# The line below is recognised by Dist::Zilla and taken for CPAN packaging
# ABSTRACT: OO-API for JiffyBox Virtual Machine

use Moo;
use JSON;
use LWP::UserAgent;

use VM::JiffyBox::Box;

has domain_name => (is => 'ro', default => 'https://api.jiffybox.de');
has version     => (is => 'ro', default => 'v1.0');
has token       => (is => 'ro', required => 1);

has test_mode   => (is => 'rw');

sub base_url {
    my $self = shift;

    return   $self->domain_name . '/'
           . $self->token       . '/' 
           . $self->version     ;
}

# TODO
sub get_id_from_name {
    my $self = shift;
}

sub get_vm {
    my $self   = shift;
    my $box_id = shift;

    my $box = VM::JiffyBox::Box->new(id => $box_id);

    # tell the VM which hypervisor it belongs to
    $box->hypervisor($self);

    return $box;
}

# TODO
sub create_vm {
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

