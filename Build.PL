# $Id: Build.PL,v 1.1 2003/03/26 22:18:03 cwest Exp $
use strict;

use Module::Build;

Module::Build->new(
	module_name => 'Parse::PhoneNumber',
	license     => 'perl',
	build_requires => {
		'Test::More'    => 0,
		'Module::Build' => 0,
	},
)->create_build_script;
