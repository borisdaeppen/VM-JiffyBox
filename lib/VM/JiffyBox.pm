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

has ua          => (is => 'ro', isa => $def, default => sub {LWP::UserAgent->new()});

has test_mode   => (is => 'rw');
has answer      => (is => 'rw');

sub base_url {
    my $self = shift;

    return   $self->domain_name . '/'
           . $self->token       . '/' 
           . $self->version     ;
}

sub get_details {
    my $self = shift;
    
    my $url = $self->base_url . '/jiffyBoxes';
    

    # EXIT
    return $url if ($self->test_mode);
    
    my $response = $self->ua->get($url);

    if ($response->is_success) {
        return from_json($response->decoded_content);
    }
    else {
        return $response->status_line;
    }
}

sub get_id_from_name {
    my $self = shift;
    my $box_name = shift || '';
    
    my $details = $self->get_details;
    
    # EXIT
    return $details if ($self->test_mode);
    
    foreach my $box (values $details->{result}) {
        return $box->{id} if ($box->{name} eq $box_name);
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

sub create_vm {
    my $self = shift;
    my $name = shift || '';
    my $plan_id = shift || 0;
    my $backup_id = shift || 0;
    
    my $url = $self->base_url . '/jiffyBoxes';
    
    # EXIT
    return $url if ($self->test_mode);
    
    my $response = $self->ua->post($url, Content => to_json({name => $name, planid => $plan_id, backupid => $backup_id}));

    if ($response->is_success) {
        $self->answer ( from_json($response->decoded_content) );

        # TODO: should check the array for more messages
        if (exists $self->answer->{messages}->[0]->{type}
                    and
            $self->answer->{messages}->[0]->{type} eq 'error'
           ) {
            return 0;
        }

        my $box_id = $self->answer->{result}->{id};
        my $box = VM::JiffyBox::Box->new(id => $box_id);

        # set the hypervisor of the VM
        $box->hypervisor($self);

        return $box;
    }
    else {
        $self->answer = $response->status_line;
        return 0;
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

