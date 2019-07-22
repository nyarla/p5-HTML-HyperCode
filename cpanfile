requires 'perl', '5.008001';
requires 'HTML::Escape' => '1.10';

on 'test' => sub {
    requires 'Test2::Suite', '0.000122';
};

on 'develop' => sub {
    requires 'Minilla' => '0';
    requires 'Software::License' => '0';
};

# vim: ft=perl
