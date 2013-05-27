package VM::JiffyBox;

use strict;
use warnings;

use Moo;

has token => (is => 'rw');

sub get_id_from_name {
    my $self = shift;
}

sub get_vm {
    my $self = shift;
}

sub create_vm {
    my $self = shift;
}

1;

# ABSTRACT: OO-API for JiffyBox Virtual Machine

__END__

=encoding utf8

=head1 PLEASE NOTE

This module ist still under heavy development and a B<TRIAL> version.
We do not recommend to test or even use it.

=head1 NAME

VM::JiffyBox

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

=head2 get_id_from_name($box_name)

=head2 get_vm($box_id)

=head2 create_vm($backup_id)
