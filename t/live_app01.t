#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

#use Test::WWW::Mechanize::Catalyst "Learn";
BEGIN { use_ok( "Test::WWW::Mechanize::Catalyst" => "Learn" ) }

my $ua1 = Test::WWW::Mechanize::Catalyst->new;
my $ua2 = Test::WWW::Mechanize::Catalyst->new;

$_->get_ok( "http://localhost/items", "Check redirect of base URL" ) for $ua1, $ua2;
$_->title_is( "Login", "Checa se vai pra página de login" ) for $ua1, $ua2;
$_->content_like( qr/precisa logar/, "Check we are NOT logged in" ) for $ua1, $ua2;

$ua1->get_ok( "http://localhost/login?username=test01&password=mypass", "login test01" );
$ua2->submit_form(
    fields => {
        username => 'test02',
        password => 'mypass',
    }
);

$_->get_ok( "http://localhost/login", "Return to '/login'" ) for $ua1, $ua2;
$_->title_is( "Login", "Check for login page" ) for $ua1, $ua2;
$_->content_like( qr/logado como/, "Check we are logged in" ) for $ua1, $ua2;

$ua1->get_ok( "http://localhost/login?username=test01&password=mypass", "login test01" );
$ua2->get_ok( "http://localhost/login?username=test02&password=mypass", "login test02" );

$_->title_is( "Lista Tarefas", "Check for item list title" ) for $ua1, $ua2;
$_->content_like( qr/Adicionar tarefa/, "Na lista de tarefas" ) for $ua1, $ua2;
$_->content_like( qr/Logout/, "Both users should have a 'User Logout'" ) for $ua1, $ua2;

$ua1->content_like( qr/Deletar Tudo!/, "'test01' should have a delete all" );
$ua2->content_unlike( qr/Deletar Tudo!/, "'test02' should not have a delete all" );
$ua1->get_ok( "http://localhost/items/list", "View book list as 'test01'" );

$ua1->get_ok( "http://localhost/items/url_create/Teste", "'test01' formless create" );
$ua1->content_contains( "Teste", "Check item added OK" );
$ua1->get_ok( "http://localhost/items/url_create/TesteABC", "'test01abc' formless create" );
$ua1->content_contains( "TesteABC", "Check item added OK" );

$ua1->submit_form(
    fields => {
        nome => 'TesteAAA',
    }
);

$ua1->content_contains( "TesteAAA", "Check item added OK" );
$ua1->get_ok( "http://localhost/items/form_create_do",      "'test01aaa' Encerrar essa" );
$ua1->get_ok( "http://localhost/items/url_create/Teste123", "'test01' formless create" );

done_testing;
