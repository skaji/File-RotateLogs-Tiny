use strict;
use warnings;
use Test::More;
use File::RotateLogs::Tiny;
use Parallel::ForkManager;

my $file = "xt/test-log.txt";
unlink $_ for glob "xt/test-log.txt*";

my $log = File::RotateLogs::Tiny->new(logfile => "$file.%Y%m%d.%H%M");

my $pm = Parallel::ForkManager->new(5);

my $LENGTH = 64 * 1024;
my $TIMES  = 2000;

for my $i (1..5) {
    $pm->start and next;
    $log->print( ($i x $LENGTH) . "\n" ) for 1..$TIMES;
    $pm->finish;
}
$pm->wait_all_children;

open my $fh, "<", $log->{filename} or die;
while (my $l = <$fh>) {
    my $c = substr $l, 0, 1;
    is $l, ($c x $LENGTH) . "\n";
}

done_testing;
