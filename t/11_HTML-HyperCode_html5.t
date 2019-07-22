use strict;
use warnings;

use Test2::Bundle::More;
use HTML::HyperCode qw( :html5 );

is_deeply(
  render(p { id => "msg" }, with { text "hello, world!" }),
  q(<p id="msg">hello, world!</p>),
);

done_testing;
