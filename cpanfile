requires "Carp" => "0";
requires "JSON" => "0";
requires "Moo" => "0";
requires "Net::HTTP::Knork" => "0";
requires "namespace::clean" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Test::Fatal" => "0";
  requires "Test::LWP::UserAgent" => "0";
  requires "Test::More" => "0";
  requires "Test::Spec" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
};
