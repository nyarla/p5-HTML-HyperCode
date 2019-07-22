package HTML::HyperCode;

use 5.008001;

use strict;
use warnings;

use parent qw( Exporter );

our $AUTHORITY  = 'cpan:NYARLA';
our $VERSION    = '0.01';

our @_EMPTY = qw( area base br col embed hr img input link meta param source track wbr );
our @_HTML5 = qw(
  html body

  base head link meta style title
  
  address article aside footer header
  h1 h2 h3 h4 h5 h6 hr hgroup main nav section
  
  blockquote dd div dl dt figcaption figure  li ol p pre ul
  
  a abbr b bdi bdo br cite code data dfn em i kbd mark q
  rb rt rtc ruby samp smalll span strong sub sup time u var wbr
  
  area audio img map track video
  embed iframe object picture source param
  
  canvas noscript script
  
  del ins 
  
  caption col colgroup table tbody td tfoot th thread tr 
  
  button datalist fieldset form input label legend meter optgroup
  option output progress select textarea 
  
  details dialog menu menuitem summary
  
  slot template 
);

our @_CORE = qw( node text with render );

our @EXPORT_OK = ( @_HTML5, @_CORE );

our %EXPORT_TAGS = (
  'html5' => [ @_HTML5, @_CORE ],
  'core'  => [ @_CORE ],
);

use HTML::Escape qw( escape_html );
use Carp qw( confess );

our $_with = undef;

sub node {
  my $tag       = shift;
  my @args      = @_;

  my @attrs     = ();
  my @contents  = ();
  
  if ( @args % 2 == 0 && ! grep { ref $_ ne q{} } @args ) {
    push @attrs, @args;
    goto finalized; 
  }

  my $last      = pop @args;

  my $type  = ref $last;

  if ( $type eq 'CODE' ) {
    local $_with = sub { push @contents, $_[0] };
    $last->();
  }
  elsif ( $type eq 'HASH' ) {
    @attrs = ( %{ $last } )
  }
  elsif ( $type eq 'ARRAY' ) {
    push @contents, @{ $last };
  }
  elsif ( defined $last ) {
    push @contents, escape_html("${last}");
  }

  if ( @args % 2 == 0 ) {
    push @attrs, @args;
  }
  else {
    $last = pop @args;
    $type = ref $last;

    if ( $type eq 'HASH' ) {
      @attrs = (%{ $last });
    }
    elsif ( $type eq 'ARRAY' ) {
      push @contents, @{ $last };
    }
    else {
      confess("Unsuported use case of 'node' function."); 
    }
  }

  finalized:

  my $ast = [ $tag, { @attrs }, [ @contents ] ];

  if ( defined $_with && ref $_with eq 'CODE' ) {
    $_with->($ast);
  }

  return $ast;
}

sub text {
  my $content = shift;

  if ( ! defined $_with || ref $_with ne 'CODE' ) {
    confess("this function cannot call outside CODE block argument of 'node' subroutine."); 
  }

  $_with->($content);
}

sub with (&) { $_[0] }

sub render {
  my $ast = shift @_;

  if ( ! ref $ast ) {
    return escape_html($ast); 
  }

  my ( $tag, $attrs, $contents ) = @{ $ast };

  my $attr = q{};
  for my $key ( sort keys %{ $attrs || {} } ) {
    $attr .= sprintf(' %s="%s"', escape_html($key), escape_html($attrs->{$key})); 
  }

  my $out = q{};
  $out .= sprintf('<%s%s>', escape_html($tag), $attr);
  for my $content ( @{ $contents || [] } ) {
    $out .= render($content); 
  }

  if ( ! grep { $tag eq $_ } @_EMPTY ) {
    $out .= sprintf('</%s>', escape_html($tag));
  }

  return $out;
}

sub html { return node("html", @_); }
sub body { return node("body", @_); }
sub base { return node("base", @_); }
sub head { return node("head", @_); }
sub link { return node("link", @_); }
sub meta { return node("meta", @_); }
sub style { return node("style", @_); }
sub title { return node("title", @_); }
sub address { return node("address", @_); }
sub article { return node("article", @_); }
sub aside { return node("aside", @_); }
sub footer { return node("footer", @_); }
sub header { return node("header", @_); }
sub h1 { return node("h1", @_); }
sub h2 { return node("h2", @_); }
sub h3 { return node("h3", @_); }
sub h4 { return node("h4", @_); }
sub h5 { return node("h5", @_); }
sub h6 { return node("h6", @_); }
sub hr { return node("hr", @_); }
sub hgroup { return node("hgroup", @_); }
sub main { return node("main", @_); }
sub nav { return node("nav", @_); }
sub section { return node("section", @_); }
sub blockquote { return node("blockquote", @_); }
sub dd { return node("dd", @_); }
sub div { return node("div", @_); }
sub dl { return node("dl", @_); }
sub dt { return node("dt", @_); }
sub figcaption { return node("figcaption", @_); }
sub figure { return node("figure", @_); }
sub li { return node("li", @_); }
sub ol { return node("ol", @_); }
sub p { return node("p", @_); }
sub pre { return node("pre", @_); }
sub ul { return node("ul", @_); }
sub a { return node("a", @_); }
sub abbr { return node("abbr", @_); }
sub b { return node("b", @_); }
sub bdi { return node("bdi", @_); }
sub bdo { return node("bdo", @_); }
sub br { return node("br", @_); }
sub cite { return node("cite", @_); }
sub code { return node("code", @_); }
sub data { return node("data", @_); }
sub dfn { return node("dfn", @_); }
sub em { return node("em", @_); }
sub i { return node("i", @_); }
sub kbd { return node("kbd", @_); }
sub mark { return node("mark", @_); }
sub q { return node("q", @_); }
sub rb { return node("rb", @_); }
sub rt { return node("rt", @_); }
sub rtc { return node("rtc", @_); }
sub ruby { return node("ruby", @_); }
sub samp { return node("samp", @_); }
sub smalll { return node("smalll", @_); }
sub span { return node("span", @_); }
sub strong { return node("strong", @_); }
sub sub { return node("sub", @_); }
sub sup { return node("sup", @_); }
sub time { return node("time", @_); }
sub u { return node("u", @_); }
sub var { return node("var", @_); }
sub wbr { return node("wbr", @_); }
sub area { return node("area", @_); }
sub audio { return node("audio", @_); }
sub img { return node("img", @_); }
sub map { return node("map", @_); }
sub track { return node("track", @_); }
sub video { return node("video", @_); }
sub embed { return node("embed", @_); }
sub iframe { return node("iframe", @_); }
sub object { return node("object", @_); }
sub picture { return node("picture", @_); }
sub source { return node("source", @_); }
sub param { return node("param", @_); }
sub canvas { return node("canvas", @_); }
sub noscript { return node("noscript", @_); }
sub script { return node("script", @_); }
sub del { return node("del", @_); }
sub ins { return node("ins", @_); }
sub caption { return node("caption", @_); }
sub col { return node("col", @_); }
sub colgroup { return node("colgroup", @_); }
sub table { return node("table", @_); }
sub tbody { return node("tbody", @_); }
sub td { return node("td", @_); }
sub tfoot { return node("tfoot", @_); }
sub th { return node("th", @_); }
sub thread { return node("thread", @_); }
sub tr { return node("tr", @_); }
sub button { return node("button", @_); }
sub datalist { return node("datalist", @_); }
sub fieldset { return node("fieldset", @_); }
sub form { return node("form", @_); }
sub input { return node("input", @_); }
sub label { return node("label", @_); }
sub legend { return node("legend", @_); }
sub meter { return node("meter", @_); }
sub optgroup { return node("optgroup", @_); }
sub option { return node("option", @_); }
sub output { return node("output", @_); }
sub progress { return node("progress", @_); }
sub select { return node("select", @_); }
sub textarea { return node("textarea", @_); }
sub details { return node("details", @_); }
sub dialog { return node("dialog", @_); }
sub menu { return node("menu", @_); }
sub menuitem { return node("menuitem", @_); }
sub summary { return node("summary", @_); }
sub slot { return node("slot", @_); }
sub template { return node("template", @_); }

1;
__END__

=encoding utf-8

=head1 NAME

HTML::HyperCode - Library for writing html as Perl code.

=head1 SYNOPSIS

    use HTML::HyperCode qw( :html5 );
    
    # print '<p id="msg">hello, world!</p>'
    print render p { id => "msg" }, with {
        text "hello, world!";
    };
    

=head1 DESCRIPTION

HTML::HyperCode is DSL library for writing html as Perl code.

=head1 IMPORT FLAGS

=head2 C<use HTML::HyperCode qw( :core )>

This flag is only exports these functions:

    node text with render

=head2 C<use HTML::HyperCode qw( :html5 )>

This flag is exports C<:core> functions, and alias functions of html5 tags.

=head1 FUNCTIONS

=head2 node

    # make '<p>hello, world!</p>'; (basic usage)
    node p => [ "hello, world!" ];
    node p => with { text "hello, world!" };
    
    
    # make '<p id="msg">hello, world!</p>'; (basic usage with attributes)
    node p => { id => "msg" }, [ "hello, world!" ];
    node p => ( id => "msg" ), [ "hello, world!" ];
    node p => { id => "msg" }, with { text "hello, world!"; }; 
    node p => ( id => "msg" ), with { text "hello, world!"; }; 
    
    
    # make '<hr>'; (empty elements)
    node 'hr';
    
    # make '<img src="...">'; (empty elements with attributes)
    node img => { src => "..." };
    node img => ( src => "..." );
   
    
    # make '<p title="next link &lt;">next &lt;</p>'; (auto-escape)
    node p => ( title => "next link >" ) => [ "next >" ];
  
This function makes a html tree node, and structure of html tree like as follow:

    [ $tag, \%attrs, \@contents ]

=head2 render 
 
    # => <p>hello, world!</p>
    print render( node p => [ "hello, world!" ] );

This function is rendering html string from html node tree makes by C<node> function.

B<NOTE>:

All strings are required to escape on html is automattic escaping by this functions,
and raw tree of html nodes are not escaped strings. Please be carefully.

=head1 DOMAIN SPECIFIC LANGUAGE (DSL)

=head2 with

   with { ... };

This function is alias of C<sub { ... }>.

=head2 text

   text "hello, world!";

This function is append text node to parent html node.

This function is only callable inside CODE block as C<node>'s argument,
and other cases are throwing error.

=head2 html, body,

=head2 base, head, link, meta, style, title,

=head2 address, article, aside, footer, header,

=head2 h1, h2, h3, h4, h5, h6, hr, hgroup, main, nav, section,

=head2 blockquote, dd, div, dl, dt, figcaption, figure=head2 li, ol, p, pre, ul,

=head2 a, abbr, b, bdi, bdo, br, cite, code, data, dfn, em, i, kbd, mark, q,

=head2 rb, rt, rtc, ruby, samp, smalll, span, strong, sub, sup, time, u, var, wbr,

=head2 area, audio, img, map, track, video,

=head2 embed, iframe, object, picture, source, param,

=head2 canvas, noscript, script,

=head2 del, ins, 

=head2 caption, col, colgroup, table, tbody, td, tfoot, th, thread, tr, 

=head2 button, datalist, fieldset, form, input, label, legend, meter, optgroup,

=head2 option, output, progress, select, textarea, 

=head2 details, dialog, menu, menuitem, summary,

=head2 slot, template

These functions are alias of C<node $tag, @_;>.

=head1 LICENSE

Copyright (C) OKAMURA Naoki a.k.a nyarla

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

OKAMURA Naoki E<lt>nyarla@cpan.orgE<gt>

=cut

