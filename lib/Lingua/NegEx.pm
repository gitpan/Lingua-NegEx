package Lingua::NegEx;

use 5.008008;
use strict;
use warnings;

require Exporter;

our (@ISA,@EXPORT);
BEGIN {
  @ISA = qw(Exporter);
  @EXPORT = qw(
    negation_scope	
  );
}
our $VERSION = '0.01';

our (
  $pseudo_negation_phrases, $negation_phrases,
  $post_negation_phrases, $conjunctions
);

sub negation_scope {
  my $text = shift;
  my $string = [ ( split /\s/, $text ) ];
  return helper( $string, 0 );
}

sub helper {
  my ($string,$index) = @_;
  my $word_count = scalar( @$string );

  if ( $index < $word_count  ) {
    for ( my $i = $index; $i < $word_count; $i++ ) {
      my $indexII =  contains( $string, $pseudo_negation_phrases, $i, 0 );

      if ( $indexII != -1 ) {
          return helper($string, $indexII );

      } else {
          my $indexIII = contains( $string, $negation_phrases, $i, 0 );
          if ( $indexIII != -1 ) {
              my $indexIV = -1;
              for ( my $j = $indexIII; $j < $word_count; $j++ ) {
                            $indexIV = contains( $string, $conjunctions, $j, 1 );

                            last if $indexIV != -1;
                }
                if ( $indexIV != -1 ) {
                            return $indexIII . " - " . $indexIV;
                } else {

                  if ( $indexIII > $word_count - 1 ) {
                    if ( 1 ) {   # $boolean_value
                      return "0 - " . ( $indexIII - 2 );
                    } else {
                      return "-2";
                    }
                  } else {
                    return$indexIII . " - " . ( $word_count - 1 );
                  }
                }

          } else {
                my $indexV = contains( $string, $post_negation_phrases, $i , 1 );
                return "0 - " . $indexV if ( $indexV != -1 );
          }
      }
    }
  }
  return "-1";
}


# returns index of negation phrase if any negation phrase is found in a sentence
#       returns -1 if no negation phrase is found
sub contains {
  my ($string, $target_list, $index, $type ) = @_;
  my $counts = 0;
  my $word_count = scalar( @$string );
  foreach my $token ( @$target_list ) {
    my $element = [ ( split /\s/, $token ) ];
    if ( scalar( @$element ) == 1 ) {
          if ( @$string[ $index ] eq @$element[0] ) {
            return $index + 1;
          }
    } else {
          my $firstWord = '';
          if ( (scalar( @$string ) - $index) >= scalar( @$element ) ) {
                $firstWord = @$string[ $index ];
          }
          if ( $firstWord eq @$element[0] ) {
                $counts++;
                for ( my $i = 1; $i < scalar( @$element ); $i++ ) {
                  if ( @$string[ $index + $i ] eq @$element[ $i ] )  {
                            $counts++;
                  } else {
                            $counts = 0;
                            #last;
                  }
                  if ( $counts == scalar( @$element ) ) {
                        if ( $type == 0 ) {
                          return $index + $i + 1;
                        } else {
                          return $index;
                        }
                  }
                }
          }
    }
  }
  return -1;
}


$pseudo_negation_phrases = [
        "no increase",
        "no change",
        "no suspicious change",
        "no significant change",
        "no interval change",
        "no definite change",
        "not extend",
        "not cause",
        "not drain",
        "not significant interval change",
        "not certain if",
        "not certain whether",
        "gram negative",
        "without difficulty",
        "not necessarily",
        "not only",
];

$negation_phrases = [
        "absence of",
        "cannot see",
        "cannot",
        "checked for",
        "declined",
        "declines",
        "denied",
        "denies",
        "denying",
        "evaluate for",
        "fails to reveal",
        "free of",
        "negative for",
        "never developed",
        "never had",
        "no",
        "no abnormal",
        "no cause of",
        "no complaints of",
        "no evidence",
        "no new evidence",
        "no other evidence",
        "no evidence to suggest",
        "no findings of",
        "no findings to indicate",
        "no mammographic evidence of",
        "no new",
        "no radiographic evidence of",
        "no sign of",
        "no significant",
        "no signs of",
        "no suggestion of",
        "no suspicious",
        "not",
        "not appear",
        "not appreciate",
        "not associated with",
        "not complain of",
        "not demonstrate",
        "not exhibit",
        "not feel",
        "not had",
        "not have",
        "not know of",
        "not known to have",
        "not reveal",
        "not see",
        "not to be",
        "patient was not",
        "rather than",
        "resolved",
        "test for",
        "to exclude",
        "unremarkable for",
        "with no",
        "without any evidence of",
        "without evidence",
        "without indication of",
        "without sign of",
        "without",
        "rule out for",
        "rule him out for",
        "rule her out for",
        "rule the patient out for",
        "rule him out",
        "rule her out",
        "rule out",
        "r/o",
        "ro",
        "rule the patient out",
        "rules out",
        "rules him out",
        "rules her out",
        "ruled the patient out for",
        "rules the patient out",
        "ruled him out against",
        "ruled her out against",
        "ruled him out",
        "ruled her out",
        "ruled out against",
        "ruled the patient out against",
        "did rule out for",
        "did rule out against",
        "did rule out",
        "did rule him out for",
        "did rule him out against",
        "did rule him out",
        "did rule her out for",
        "did rule her out against",
        "did rule her out",
        "did rule the patient out against",
        "did rule the patient out for",
        "did rule the patient out",
        "can rule out for",
        "can rule out against",
        "can rule out",
        "can rule him out for",
        "can rule him out against",
        "can rule him out",
        "can rule her out for",
        "can rule her out against",
        "can rule her out",
        "can rule the patient out for",
        "can rule the patient out against",
        "can rule the patient out",
        "adequate to rule out for",
        "adequate to rule out",
        "adequate to rule him out for",
        "adequate to rule him out",
        "adequate to rule her out for",
        "adequate to rule her out",
        "adequate to rule the patient out for",
        "adequate to rule the patient out against",
        "adequate to rule the patient out",
        "sufficient to rule out for",
        "sufficient to rule out against",
        "sufficient to rule out",
        "sufficient to rule him out for",
        "sufficient to rule him out against",
        "sufficient to rule him out",
        "sufficient to rule her out for",
        "sufficient to rule her out against",
        "sufficient to rule her out",
        "sufficient to rule the patient out for",
        "sufficient to rule the patient out against",
        "sufficient to rule the patient out",
        "what must be ruled out is",
];

$post_negation_phrases = [
        "should be ruled out for",
        "ought to be ruled out for",
        "may be ruled out for",
        "might be ruled out for",
        "could be ruled out for",
        "will be ruled out for",
        "can be ruled out for",
        "must be ruled out for",
        "is to be ruled out for",
        "be ruled out for",
        "unlikely",
        "free",
        "was ruled out",
        "is ruled out",
        "are ruled out",
        "have been ruled out",
        "has been ruled out",
        "being ruled out",
        "should be ruled out",
        "ought to be ruled out",
        "may be ruled out",
        "might be ruled out",
        "could be ruled out",
        "will be ruled out",
        "can be ruled out",
        "must be ruled out",
        "is to be ruled out",
        "be ruled out",
];

$conjunctions = [
        "but",
        "however",
        "nevertheless",
        "yet",
        "though",
        "although",
        "still",
        "aside from",
        "except",
        "apart from",
        "secondary to",
        "as the cause of",
        "as the source of",
        "as the reason of",
        "as the etiology of",
        "as the origin of",
        "as the cause for",
        "as the source for",
        "as the reason for",
        "as the etiology for",
        "as the origin for",
        "as the secondary cause of",
        "as the secondary source of",
        "as the secondary reason of",
        "as the secondary etiology of",
        "as the secondary origin of",
        "as the secondary cause for",
        "as the secondary source for",
        "as the secondary reason for",
        "as the secondary etiology for",
        "as the secondary origin for",
        "as a cause of",
        "as a source of",
        "as a reason of",
        "as a etiology of",
        "as a cause for",
        "as a source for",
        "as a reason for",
        "as a etiology for",
        "as a secondary cause of",
        "as a secondary source of",
        "as a secondary reason of",
        "as a secondary etiology of",
        "as a secondary origin of",
        "as a secondary cause for",
        "as a secondary source for",
        "as a secondary reason for",
        "as a secondary etiology for",
        "as a secondary origin for",
        "cause of",
        "cause for",
        "causes of",
        "causes for",
        "source of",
        "source for",
        "sources of",
        "sources for",
        "reason of",
        "reason for",
        "reasons of",
        "reasons for",
        "etiology of",
        "etiology for",
        "trigger event for",
        "origin of",
        "origin for",
        "origins of",
        "origins for",
        "other possibilities of",
];

1;
__END__

=head1 NAME

Lingua::NegEx - Perl extension for finding negated phrases in text.

=head1 SYNOPSIS

  use Lingua::NegEx;
 
  my $scope = negation_scope( 'There is no pulmonary embolism.' );
  print $scope; # prints '3 - 4'

=head1 DESCRIPTION

This is a perl implementation of Wendy Chapman's NegEx algorithm which uses a list of phrases to determine whether clinical conditions are negated in a sentence. 

EXPORT

negation_scope( $text );

=head1 SEE ALSO

The NegEx documentation and downloads for java implementation can be found here:

http://code.google.com/p/negex/

The one exported function, negation_scope(), takes a sentence as inuput and returns '-1' if no negation is found or returns the index of the words that make up the scope of the negation.

=head1 AUTHOR

Eduardo Iturrate, E<lt>ed@iturrate.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Eduardo Iturrate 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
