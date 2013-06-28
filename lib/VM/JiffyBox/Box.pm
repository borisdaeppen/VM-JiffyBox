package VM::JiffyBox::Box;

# ABSTRACT: Representation of a Virtual Machine in JiffyBox

use Moo;
use JSON;

has id         => (is => 'rw', required => 1);
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
    return { url => $url } if ($self->{hypervisor}->test_mode);
    
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
    return { url => $url } if ($self->{hypervisor}->test_mode);
    
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
    
    my $url  = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    my $json = to_json( { status => 'START' } );
    
    # POSSIBLE EXIT
    return { url => $url, json => $json }
        if ($self->{hypervisor}->test_mode);
    
    # send the request with method specific json content
    my $response = $self->{hypervisor}->ua->put( $url, Content => $json ); 

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
    
    my $url  = $self->{hypervisor}->base_url . '/jiffyBoxes/' . $self->id;
    my $json = to_json( { status => 'SHUTDOWN' } );
    
    # POSSIBLE EXIT
    return { url => $url, json => $json }
        if ($self->{hypervisor}->test_mode);
    
    my $response = $self->{hypervisor}->ua->put( $url, Content => $json ); 

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
    return { url => $url } if ($self->{hypervisor}->test_mode);
    
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

=head1 SYNOPSIS

This module should be used together with L<VM::JiffyBox>.
L<VM::JiffyBox> is the factory for producing objects of this module.
However if you want to do it yourself:

 my $box = VM::JiffyBox::Box->new(id => $box_id);

 # set the hypervisor of the VM (e.g. ref to JiffyBox)
 $box->hypervisor($ref);

You then can do a lot of stuff with this box:

 # get some info
 my $backup_id = $box->get_backups()->{result}->{daily}->{id};
 my $plan_id   = $box->get_details()->{result}->{plan}->{id};

 # get more info using the caching technique
 my $state = $box->details_chache->{result}->{status};
 my $ip    = $box->last->{result}->{ips}->{public}->[0];
 # ... or
 use Data::Dumper;
 print Dumper( $box->backup_cache->{result} );

 # start, stop, delete...
 if ( $box->start ) {
     print "VM started"
 }

 # and so on...

(See also the SYNOPSIS of L<VM::JiffyBox> or the C<examples> directory for more examples of working code.)

=head1 ERROR HANDLING

All methods will return C<0> on failure, so you can check for this with a simple C<if> on the return value.
If you need the error message you can use the cache and look into the attribute C<last>.
The form of the message is open.
It can contain a simple string, or also a hash.
This depends on the kind of error.
So if you want to be sure, just use L<Data::Dumper> to print it.

=head1 CACHING

There are possibilities to take advantage of caching functionality.
The following caches are available:

=over

=item last

Always contains the last information.

=item backup_cache 

Contains information of the last call to get_backups().

=item details_cache

Contains information of the last call to get_details().

=item start_cache

Contains information of the last call to start().

=item stop_cache

Contains information of the last call to stop().

=item delete_cache

Contains information of the last call to delete().

=back

=head1 METHODS

=head2 get_details

Returns hashref with information about the virtual machine.
Takes no arguments.

=head2 get_backups

Returns hashref with information about the backups of the virtual machine.
Takes no arguments.

=head2 start

Starts a virtual machine.
It must be ensured (by you) that the machine has the state C<READY> before calling this.

=head2 stop

Stop a virtual machine.

=head2 delete

Delete a virtual machine.
(Be sure that the VM has the appropriate state for doing so)

=head1 SEE ALSO

=over

=item *

Source, contributions, patches: L<https://github.com/tim-schwarz/VM-JiffyBox>

=item *

This module is B<not> officially supported by or related to the company I<domainfactory> in Germany.
However it aims to provide an interface to the API of their product I<JiffyBox>.
So to use this module with success you should also B<read their API-Documentation>, available for registered users of their service.

=back

