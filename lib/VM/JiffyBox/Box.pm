package VM::JiffyBox::Box;

# ABSTRACT: Representation of a Virtual Machine in JiffyBox

use Moo;
use JSON;
use LWP::UserAgent; # needed?

my $def = sub {die unless $_[0]};

has id         => (is => 'ro', isa => $def);
has hypervisor => (is => 'rw');

has last          => (is => 'rw');
has backup_cache  => (is => 'rw');
has details_cache => (is => 'rw');
has start_cache   => (is => 'rw');
has stop_cache    => (is => 'rw');
has delete_cache  => (is => 'rw');

sub get_backups {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/backups/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->get($url);

    # POSSIBLE EXIT
    unless ($response->is_success) {

        $self->last ( $response->status_line );
        return 0;
    }

    my $backup_info = from_json($response->decoded_content);

    $self->last         ($backup_info);
    $self->backup_cache ($backup_info);
    return               $backup_info ;

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

        $self->last ( $response->status_line );
        return 0;
    }

    my $details = from_json($response->decoded_content);

    $self->last          ($details);
    $self->details_cache ($details);
    return                $details ;
}

sub start {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    # send the request with method specific json content
    my $response = $self->{hypervisor}->ua->put(  $url,
                                                  Content => to_json(
                                                    {
                                                      status => 'START'
                                                    }
                                                  )
                                                );

    # POSSIBLE EXIT
    unless ($response->is_success) {

        $self->last ( $response->status_line );
        return 0;
    }

    my $start_info = from_json($response->decoded_content);

    $self->last        ($start_info);
    $self->start_cache ($start_info);
    return              $start_info ;
}

sub stop {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->put( $url,
                                                 Content => to_json(
                                                   {
                                                     status => 'SHUTDOWN'
                                                   }
                                                 )
                                               );
        
    # POSSIBLE EXIT
    unless ($response->is_success) {

        $self->last ( $response->status_line );
        return 0;
    }

    my $stop_info = from_json($response->decoded_content);

    $self->last       ($stop_info);
    $self->stop_cache ($stop_info);
    return             $stop_info ;
}

sub delete {
    my $self = shift;
    
    my $url = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    
    # POSSIBLE EXIT
    return $url if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->delete($url);    

    # POSSIBLE EXIT
    unless ($response->is_success) {

        $self->last ( $response->status_line );
        return 0;
    }

    my $delete_info = from_json($response->decoded_content);

    $self->last       ($delete_info);
    $self->stop_cache ($delete_info);
    return             $delete_info ;
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

