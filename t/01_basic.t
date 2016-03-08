use strict;
use warnings;
use utf8;
use Test::More;
use File::RotateLogs::Tiny;
use File::Temp;
use Time::HiRes ();

sub slurp {
    open my $fh, "<", shift or die;
    join "", <$fh>;
}
sub slurp_utf8 {
    open my $fh, "<:utf8", shift or die;
    join "", <$fh>;
}
sub capture_warn (&) {
    my $cb = shift;
    my @warn; {
        local $ENV{LANG} = "C";
        local $SIG{__WARN__} = sub { push @warn, @_ };
        $cb->();
    }
    my $warn = join "", @warn;
    note $warn;
    $warn;
}


my $dir = File::Temp::tempdir(CLEANUP => 1);

subtest default => sub {
    my $log = File::RotateLogs::Tiny->new(
        logfile => "$dir/default.%Y%m%d-%H%M%S",
    );
    $log->print("hello\n");
    my $current = $log->{filename};
    is slurp($current), "hello\n";
    Time::HiRes::sleep(1.01);
    $log->print("next\n");
    my $next = $log->{filename};
    is slurp($next), "next\n";
    isnt $current, $next;
    like capture_warn { $log->print("あいうえお") }, qr/Wide/;
};

subtest utf8 => sub {
    my $log = File::RotateLogs::Tiny->new(
        logfile => "$dir/utf8.%Y%m%d-%H%M%S",
        open_layer => ":unix:utf8",
    );
    $log->print("hello\n");
    my $current = $log->{filename};
    is slurp($current), "hello\n";
    Time::HiRes::sleep(1.01);
    $log->print("next\n");
    my $next = $log->{filename};
    is slurp($next), "next\n";
    isnt $current, $next;
    is capture_warn { $log->print("あいうえお") }, "";
};

done_testing;
