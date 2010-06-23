require "yaml"
module NicePassword #:nodoc:

  # NicePassword creates an easy to remember but still somewhat secure and random passwords
  # by taking common words from a "safe" dictionary and splicing them together with random numbers
  # in between. The password is easier to remember than purely random strings of letters and numbers.
  # NicePassword is intended for use whenever you need Rails to auto-generate a password for a user.
  # Two possible uses would be after the user clicks on a "send me a new password" link or
  # as a "suggested password" on a page that lets users input a new password.
  #
  # Examples of NicePasswords:
  #    campaign34bone
  #    parent492wheat
  #    orbit8low5mix
  #
  # The Dictionary contains a list of words (English/Spanish/French only currently) which are reasonably safe
  # for use in a corporate environment.  (For example, in addition to slang and obscene words,
  # 'kill' and 'hate' aren't listed.)  However, it should be noted that sometimes awkward or funny
  # combinations can appear such as 'knife2sister' or 'harbor82evil'. These are rare and unavoidable.
  # The dictionary also contains each of the single letters in the alphabet. These are important
  # for the cases in which the password is one letter short of the required length when the
  # last word is selected.
  #
  class << self

    # Options that can be passed when creating a new NicePassword include:
    # <tt>:password_length</tt> - total number of characters in the password, default is 12
    # <tt>:language</tt> - language of the words used defaults to english
    # <tt>:word_count</tt> - total number of words in the password, default is 2
    # <tt>:digit_count</tt> - the number of digits between each word (not the total number), default is 2
    # <tt>:dictionary</tt> - for a custome dictionary you would like to use instead of the default
    def new( options = {} )
      language = options[:language].to_s || 'en'
      nice_pwd = ""
      password_length = options[:length] || 12
      word_count = options[:word_count] || 2
      digit_count = options[:digits] || 2
      dictionary = options[:dictionary] || load_yaml(language)
      word_length_variance = 3

      # Each word should be roughly the same size
      approx_word_length = (password_length - (digit_count * (word_count - 1))) / word_count
      # short_word_length allows for some variance
      short_word_length = [1, approx_word_length - word_length_variance].max
      raise NicePassword::FormatError.new("Generation Ugly")  if password_length / word_count <= 2

      1.upto(word_count.to_i) do |word_num|
        remaining_length = password_length - nice_pwd.length
        if word_num < word_count # this is not the last word
          # max_length: remaining_length - remaining digits and words (NB: no digits after last word)
          max_length = remaining_length - ((word_count - word_num) * (short_word_length + digit_count)) - digit_count
          nice_pwd << pick_dictionary_word(:min_length => short_word_length, :max_length => max_length, :dictionary => dictionary)
          nice_pwd << (pick_random_number(digit_count)).to_s if digit_count > 0
        elsif remaining_length > 0 # this is the last word and we still need it
          nice_pwd << pick_dictionary_word(:exact_length => remaining_length, :dictionary => dictionary)
        end
      end
      return nice_pwd
    end

    # pick_dictionary_word selects a word from the dictionary
    #
    # Options include:
    # <tt>:exact_length</tt> - when a word with an exact length is required, overrides max/min length options
    # <tt>:min_length</tt> - minimum length word to retrieve, defaults to 1
    # <tt>:max_length</tt> - maximum length word to retreive, defaults to 5
    # <tt>:dictionary</tt> - dictionary to use, defaults to ENGLISH_SAFE_WORD_LIST defined in NiceDictionary
    def pick_dictionary_word( options = {} )
      dictionary_word = ""
      language = options[:language] || :en
      exact_length = options[:exact_length] || nil
      min_length = options[:min_length] || 1
      max_length = options[:max_length] || 5
      dictionary = options[:dictionary] || @@dictionaries[language]
      if exact_length && exact_length > 0
        safe_sized_list = dictionary.find_all {|word| word.length == exact_length }
      else
        safe_sized_list = dictionary.find_all {|word| min_length <= word.length && word.length <= max_length }
      end
      dictionary_word = safe_sized_list[rand(safe_sized_list.length)] if safe_sized_list && safe_sized_list.length > 0
      return dictionary_word
    end

    private

      def load_yaml(language)
        YAML::load(File.open(File.join(File.dirname(__FILE__), 'dictionaries', language + ".yml")))
      end

      # pick_random_number chooses a random number with the number of digits defined by digit_count
      def pick_random_number( digit_count = 1 )
        min = 10 ** (digit_count - 1)
        max = (10 ** digit_count ) - 1
        semirandom_number = min + rand(max-min)
        semirandom_number += 1 if semirandom_number == 666 #would be unpleasant to receive...
        return semirandom_number
      end
  end

end
