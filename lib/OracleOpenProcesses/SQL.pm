package OracleOpenProcesses::SQL;

#===============================================================================
#
#         FILE: SQL.pm
#      PACKAGE: SQL
#
#  DESCRIPTION: SQL OracleOpenProcesses
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Denis Immoos (<denis.immoos@soprasteria.com>)
#    AUTHORREF: Senior Linux System Administrator (LPIC3)
# ORGANIZATION: Sopra Steria Switzerland
#      VERSION: 1.0
#      CREATED: 01/27/2016 01:03:34 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use DBI;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
} 

sub error {
    my $caller = shift;
    my $msg = shift || $caller;
    die( "ERROR($caller): $msg" );
}

sub verbose {
    my $caller = shift;
    my $msg = shift || $caller;
    print( "INFO($caller): $msg" . "\n" );
}


sub sql {

    my $self = shift;
    my $ref_Options = shift;
    my %Options = %{ $ref_Options };
    my $caller = (caller(0))[3];

	my $sql = 'SELECT resource_name, max_utilization, limit_value from v$resource_limit where resource_name in (\'processes\', \'sessions\', \'transactions\', \'mts_max_servers\')';

    my $dbh = DBI->connect("dbi:Oracle:host=$Options{'hostname'};sid=$Options{'sid'}", $Options{'username'}, $Options{'password'})
    or die( $DBI::errstr . "\n");

    my $sth = $dbh->prepare($sql);
       $sth->execute;

    while ( my $row = $sth->fetchrow_hashref ) {
	    $Options{'LIMITS'}{$row->{'RESOURCE_NAME'}} = $row;
	}
	return  %Options;
}



1;

__END__

=head1 NAME

SQL - SQL OracleOpenProcesses 

=head1 SYNOPSIS

use SQL;

my $object = SQL->new();

=head1 DESCRIPTION

This description does not exist yet, it
was made for the sole purpose of demonstration.

=head1 LICENSE

This is released under the GPL3.

=head1 AUTHOR

Denis Immoos - <denis.immoos@soprasteria.com>, Senior Linux System Administrator (LPIC3)

=cut


