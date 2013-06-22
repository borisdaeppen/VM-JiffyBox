package VM::JiffyBox::Box;

# ABSTRACT: Representation of a Virtual Machine in JiffyBox

use Moo;
use JSON;
use LWP::UserAgent;

my $def = sub {die unless $_[0]};

has id         => (is => 'ro', isa => $def);
has hypervisor => (is => 'rw');

sub get_backups {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/backups/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->get($url);

    # POSSIBLE EXIT
    unless ($response->is_success) {
        return $response->status_line;
    }

    return from_json($response->decoded_content);
}

sub get_details {
    my $self = shift;
    
    # add method specific stuff to the URL
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    # return the URL if we are using test_mode
    return $url if ($self->{hypervisor}->test_mode);
    
    # send the request and return the response
    my $response = $self->{hypervisor}->ua->get($url);

    # POSSIBLE EXIT
    unless ($response->is_success) {
        # change the json response to perl structure
        return $response->status_line;
    }

    return from_json($response->decoded_content);
}

sub start {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    # send the request with method specific json content
    my $response = $self->{hypervisor}->ua->put($url, Content => to_json({status => 'START'}));
    
    # POSSIBLE EXIT
    unless ($response->is_success) {
        return $response->status_line;
    }

    return from_json($response->decoded_content);
}

sub stop {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->put($url, Content => to_json({status => 'SHUTDOWN'}));
        
    # POSSIBLE EXIT
    unless ($response->is_success) {
        return $response->status_line;
    }

    return from_json($response->decoded_content);
}

sub delete {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->delete($url);    

    # POSSIBLE EXIT
    unless ($response->is_success) {
        return $response->status_line;
    }

    return from_json($response->decoded_content);
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

