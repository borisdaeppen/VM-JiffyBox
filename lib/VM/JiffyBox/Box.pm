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
    
    if ($self->{hypervisor}->test_mode) {
        return $url;
    } else {
        my $response = $self->{hypervisor}->ua->get($url);

        if ($response->is_success) {
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
}

sub get_details {
    my $self = shift;
    
    # add method specific stuff to the URL
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # return the URL if we are using test_mode
    if ($self->{hypervisor}->test_mode) {
        return $url;
    } else {
        # send the request and return the response
        my $response = $self->{hypervisor}->ua->get($url);

        if ($response->is_success) {
            # change the json response to perl structure
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
}

sub start {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    if ($self->{hypervisor}->test_mode) {
        return $url;
    } else {
        # send the request with method specific json content
        my $response = $self->{hypervisor}->ua->put($url, Content => to_json({status => 'START'}));
        
        if ($response->is_success) {
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
}

sub stop {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    if ($self->{hypervisor}->test_mode) {
        return $url;
    } else {   
        my $response = $self->{hypervisor}->ua->put($url, Content => to_json({status => 'SHUTDOWN'}));
        
        if ($response->is_success) {
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
}

sub delete {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    if ($self->{hypervisor}->test_mode) {
        return $url;
    } else {
        my $response = $self->{hypervisor}->ua->delete($url);    

        if ($response->is_success) {
            return from_json($response->decoded_content);
        } else {
            return $response->status_line;
        }
    }
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

