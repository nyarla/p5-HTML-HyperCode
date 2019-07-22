use strict;
use warnings;

use Test2::Bundle::More;
use HTML::HyperCode qw[ :core ];

my @tests = (
  [ 'use content as code block without attributes',
    node( p => with {
      text "hello, world!";
    }),
    q(<p>hello, world!</p>),
  ],

  [ 'use content as code block with attributes HashRef',
    node( p => { id => "msg" }, with {
      text "hello, world!";
    } ),
    q(<p id="msg">hello, world!</p>),
  ],

  [ 'use content as code block with attributes List',
    node( p => ( id => "msg" ), with {
      text "hello, world!";
    } ),
    q(<p id="msg">hello, world!</p>),
  ],



  [ 'use content as ArrayRef without attributes',
    node(p => [ 'hello, world!' ]),
    q(<p>hello, world!</p>), 
  ],

  [ 'use content as ArrayRef with attributes HashRef',
    node( p => { id => 'msg' }, [ 'hello, world!' ]),
    q(<p id="msg">hello, world!</p>), 
  ],

  [ 'use content as ArrayRef with attributes List',
    node( p => ( id => 'msg' ) => [ 'hello, world!' ]),
    q(<p id="msg">hello, world!</p>),
  ],



  [ 'empty elemnet without any atteibutes',
    node('hr'),
    q(<hr>),
  ],

  [ 'empty element with arraibutes HashRef',
    node( img => { src => "https://example.com/image.png" } ),
    q(<img src="https://example.com/image.png">),
  ],

  [ 'empty element with attributes List',
    node( input => ( size => '10' ) ),
    q(<input size="10">),
  ],



  [ 'nested content with code block',
    node( main => with {
      node( p => with {
        text "hello, world!";  
      });
    } ),
    q(<main><p>hello, world!</p></main>),
  ],



  [ 'should escape html inside attributes',
    node('img', ( src => '" onerror="alert("XSS!")"')),
    q(<img src="&quot; onerror=&quot;alert(&quot;XSS!&quot;)&quot;">),
  ],

  [ 'should escape html inside tag',
    node( p => [ node('<script>') ]),
    q(<p><&lt;script&gt;></&lt;script&gt;></p>),
  ],

  [ 'should escape html inside text content',
    node('p', [ 'hello <script>alert("XSS!")</script>' ]),
    q(<p>hello &lt;script&gt;alert(&quot;XSS!&quot;)&lt;/script&gt;</p>),
  ],
);

for my $test ( @tests ) {
  subtest $test->[0] => sub {
    is_deeply( render($test->[1]), $test->[2] );
  };
}

done_testing;
