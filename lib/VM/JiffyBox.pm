package VM::JiffyBox;

# The line below is recognised by Dist::Zilla and taken for CPAN packaging
# ABSTRACT: OO-API for JiffyBox Virtual Machine

use Moo;
use JSON;
use LWP::UserAgent;

use VM::JiffyBox::Box;

my $def = sub {die unless $_[0]};

has domain_name => (is => 'ro', isa => $def, default => sub {'https://api.jiffybox.de'});
has version     => (is => 'ro', isa => $def, default => sub {'v1.0'});
has token       => (is => 'ro', isa => $def, required => 1);

has test_mode   => (is => 'rw');

my $ua = LWP::UserAgent->new();

sub base_url {
    my $self = shift;

    return   $self->domain_name . '/'
           . $self->token       . '/' 
           . $self->version     ;
}

sub get_details {
    my $self = shift;
    
    my $url = $self->base_url . '/jiffyBoxes';
    
    if ($self->test_mode) {
        return $url;
    } else {
        my $response = $ua->get($url);

        if ($response->is_success) {
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
}

sub get_id_from_name {
    my $self = shift;
    my $box_name = shift || '';
    
    my $details = $self->get_details;
    
    if ($self->test_mode) {
        return $details;
    } else {
        foreach my $box (values $details->{result}) {
            return $box->{id} if ($box->{name} eq $box_name);
        }
    }
}

sub get_vm {
    my $self   = shift;
    my $box_id = shift;

    my $box = VM::JiffyBox::Box->new(id => $box_id);

    # set the hypervisor of the VM
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

