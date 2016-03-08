[![Build Status](https://travis-ci.org/skaji/File-RotateLogs-Tiny.svg?branch=master)](https://travis-ci.org/skaji/File-RotateLogs-Tiny)

# NAME

File::RotateLogs::Tiny - tiny File::RotateLogs

# SYNOPSIS

    use File::RotateLogs::Tiny;

    my $rotatelogs = File::RotateLogs::Tiny->new(
      logfile => "/path/to/%Y%m%d.log",
    );

    $rotatelogs->print("logging!\n");

# DESCRIPTION

File::RotateLogs::Tiny is a limited [File::RotateLogs](https://metacpan.org/pod/File::RotateLogs).

File::RotateLogs is awesome, but I sometimes feel it is too feature-rich.
That is, I don't want features of removing old logs and creating a symlink linking to the latest log.

I just want the feature of rotating log according to time.

# METHODS

## new

    my $rotatelogs = File::RotateLogs::Tiny->new(%option);

Constructor. `%option` is

- logfile

    This is file name pattern. The format is [POSIX](https://metacpan.org/pod/POSIX)'s strftime.
    This is required.

- open\_layer

    The open layer to open files. The default is `:unix` (non buffered).
    You may specify `:unix:utf8` instead.

## print

    $rotatelogs->print("hello!\n");

Print to the log.

# FAQ

- But, I want to remove old logs...

    OK, let's use cron:

        > crontab -l
        1 5 * * * find /path/to/log/dir -type f -mtime +30 -delete

- I want to compress old logs...

    OK, let's use cron again:

        > crontab -l
        2 * * * * find /path/to/log/dir -type f -mtime +1 -exec gzip {}\;

# AUTHOR

Shoichi Kaji <skaji@cpan.org>

# COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
