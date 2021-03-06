use strict;
use warnings;

use Modern::Perl;
use Test::More tests => 1;
use Test::Exception;

use Orbital::Payload::Service::GitHub;
use Orbital::Payload::Service::GitHub::User;

my $user = Orbital::Payload::Service::GitHub::User->new( user => 'zmughal' );
#my $token = Orbital::Payload::Service::GitHub->get_token;
my $token = do {
	my $gconfig_token = `git config --get github.token`;
	chomp $gconfig_token;
	$gconfig_token;
};
my $r = $user->_pithub_client
	->repos(
		token => $token,
		auto_pagination => 1,
	)->list(
		#user => 'zmughal',
		params => { type => 'all' },
		options => $user->_pithub_options,
	);
#use DDP; p $r;
#use DDP; p $r->response->request->as_string;
#say $r->next_page_uri;
#say $r->count;
#exit;
while( my $row = $r->next ) {
	print $row->{full_name};
	if( $row->{fork} ) {
		my $repo = $user->_pithub_client->repos(
			token => $token,
			auto_pagination => 1,
		)->get( user => $row->{owner}{login}, repo => $row->{name} );
		my $parent_repo = $repo->content->{parent}{full_name};
		print " (forked from: @{[ $parent_repo ]})";
	}
	say "";
}
#do {
	#use DDP; p $r->request;
	#my @fn = map { $_->{full_name} } @{ $r->content };
	#use DDP; p @fn;
#} while( $r = $r->next_page );
#use DDP; p $user->repos->first_page_uri;


# TODO
ok 1;
