#!/usr/bin/perl -w
#
# Cobrand.t:
# Tests for the cobranding functions
#
#  Copyright (c) 2009 UK Citizens Online Democracy. All rights reserved.
# Email: louise@mysociety.org; WWW: http://www.mysociety.org/
#
# $Id: Cobrand.t,v 1.4 2009-09-02 08:32:23 louise Exp $
#

use strict;
use warnings;
use Test::More tests => 11;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin";
use lib "$FindBin::Bin/../perllib";
use lib "$FindBin::Bin/../../perllib";

use Cobrand;
use MockQuery;

sub test_site_restriction{
    my $q  = new MockQuery('mysite');
    my ($site_restriction, $site_id) = Cobrand::set_site_restriction($q);
    like($site_restriction, qr/ and council = 1 /, 'should return result of cobrand module site_restriction function');
    ok($site_id == 99, 'should return result of cobrand module site_restriction function');    
    
    $q = new MockQuery('nosite');
    ($site_restriction, $site_id) = Cobrand::set_site_restriction($q);
    ok($site_restriction eq '', 'should return "" and zero if no module exists' );
    ok($site_id == 0, 'should return "" and zero if no module exists');
}

sub test_cobrand_handle{
    my $cobrand = 'mysite';
    my $handle = Cobrand::cobrand_handle($cobrand);
    like($handle->site_name(), qr/mysite/, 'should get a module handle if Util module exists for cobrand');
    $cobrand = 'nosite';    
    $handle = Cobrand::cobrand_handle($cobrand);
    ok($handle == 0, 'should return zero if no module exists');
    
}

sub test_cobrand_page{
    my $q  = new MockQuery('mysite');
    # should get the result of the page function in the cobrand module if one exists
    my ($html, $params) = Cobrand::cobrand_page($q);
    like($html, qr/A cobrand produced page/, 'cobrand_page returns output from cobrand module'); 

    # should return 0 if no cobrand module exists
    $q  = new MockQuery('mynonexistingsite');
    ($html, $params) = Cobrand::cobrand_page($q);
    is($html, 0, 'cobrand_page returns 0 if there is no cobrand module'); 
    return 1;

}

ok(test_cobrand_handle() == 1, 'Ran all tests for the cobrand_handle function');
ok(test_cobrand_page() == 1, 'Ran all tests for the cobrand_page function');
ok(test_site_restriction() == 1, 'Ran all tests for the site_restriction function');