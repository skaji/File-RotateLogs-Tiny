package File::RotateLogs::Tiny;
use strict;
use warnings;
use POSIX ();
use Carp 'croak';

our $VERSION = '0.01';

sub new {
    my ($class, %option) = @_;
    my $logfile = $option{logfile} or croak "missing logfile option";
    my $open_layer = $option{open_layer} || ":unix";
    my $self = bless {
        fh => undef,
        filename => "",
        logfile => $logfile,
        open_layer => $open_layer,
    }, $class;
    $self->fh;
    $self;
}

sub filename { shift->{filename} }

sub fh {
    my $self = shift;
    my $next = POSIX::strftime($self->{logfile}, localtime);
    if ($next ne $self->{filename}) {
        close $self->{fh} if $self->{fh};
        open my $fh, ">>$self->{open_layer}", $next
            or croak "Cannot open $next: $!";
        $self->{fh} = $fh;
        $self->{filename} = $next;
    }
    $self->{fh};
}

sub print {
    my $self = shift;
    my $fh = $self->fh;
    print {$fh} @_;
}

1;
__END__

=encoding utf-8

=head1 NAME

File::RotateLogs::Tiny - tiny File::RotateLogs

=head1 SYNOPSIS

  use File::RotateLogs::Tiny;

  my $rotatelogs = File::RotateLogs::Tiny->new(
    logfile => "/path/to/%Y%m%d.log",
  );

  $rotatelogs->print("logging!\n");

=head1 DESCRIPTION

File::RotateLogs::Tiny is a limited L<File::RotateLogs>.

File::RotateLogs is awesome, but I sometimes feel it is too feature-rich.
That is, I don't want features of removing old logs and creating a symlink linking to the latest log.

I just want the feature of rotating log according to time.

=head1 METHODS

=head2 new

  my $rotatelogs = File::RotateLogs::Tiny->new(%option);

Constructor. C<%option> is

=over 4

=item logfile

This is file name pattern. The format is L<POSIX>'s strftime.
This is required.

=item open_layer

The open layer to open files. The default is C<:unix> (not buffered).
You may specify C<:unix:utf8> instead.

=back

=head2 print

  $rotatelogs->print("hello!\n");

Print to the log.

=head1 FAQ

=over 4

=item But, I want to remove old logs...

OK, let's use cron:

  > crontab -l
  1 5 * * * find /path/to/log/dir -type f -mtime +30 -delete

=item I want to compress old logs...

OK, let's use cron again:

  > crontab -l
  2 * * * * find /path/to/log/dir -type f -mtime +1 -exec gzip {}\;

=back

=head1 AUTHOR

Shoichi Kaji <skaji@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
