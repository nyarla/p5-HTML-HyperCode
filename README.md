# NAME

HTML::HyperCode - Library for writing html as Perl code.

# SYNOPSIS

    use HTML::HyperCode qw( :html5 );
    
    # print '<p id="msg">hello, world!</p>'
    print render p { id => "msg" }, with {
        text "hello, world!";
    };
    

# DESCRIPTION

HTML::HyperCode is DSL library for writing html as Perl code.

# IMPORT FLAGS

## `use HTML::HyperCode qw( :core )`

This flag is only exports these functions:

    node text with render

## `use HTML::HyperCode qw( :html5 )`

This flag is exports `:core` functions, and alias functions of html5 tags.

# FUNCTIONS

## node

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

## render 

    # => <p>hello, world!</p>
    print render( node p => [ "hello, world!" ] );

This function is rendering html string from html node tree makes by `node` function.

**NOTE**:

All strings are required to escape on html is automattic escaping by this functions,
and raw tree of html nodes are not escaped strings. Please be carefully.

# DOMAIN SPECIFIC LANGUAGE (DSL)

## with

    with { ... };

This function is alias of `sub { ... }`.

## text

    text "hello, world!";

This function is append text node to parent html node.

This function is only callable inside CODE block as `node`'s argument,
and other cases are throwing error.

## html, body,

## base, head, link, meta, style, title,

## address, article, aside, footer, header,

## h1, h2, h3, h4, h5, h6, hr, hgroup, main, nav, section,

## blockquote, dd, div, dl, dt, figcaption, figure=head2 li, ol, p, pre, ul,

## a, abbr, b, bdi, bdo, br, cite, code, data, dfn, em, i, kbd, mark, q,

## rb, rt, rtc, ruby, samp, smalll, span, strong, sub, sup, time, u, var, wbr,

## area, audio, img, map, track, video,

## embed, iframe, object, picture, source, param,

## canvas, noscript, script,

## del, ins, 

## caption, col, colgroup, table, tbody, td, tfoot, th, thread, tr, 

## button, datalist, fieldset, form, input, label, legend, meter, optgroup,

## option, output, progress, select, textarea, 

## details, dialog, menu, menuitem, summary,

## slot, template

These functions are alias of `node $tag, @_;`.

# LICENSE

Copyright (C) OKAMURA Naoki a.k.a nyarla

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

OKAMURA Naoki <nyarla@cpan.org>
