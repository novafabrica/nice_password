require "yaml"
module NicePassword #:nodoc:

  class << self

    @@languages = ['en', 'fr', 'es']
    @@default_language = 'en'
    @@dictionaries = {}
    
    def default_language; @@default_language; end
    def default_language=(value); @@default_language = value; end

    # <tt>new</tt> generates a new NicePassword according to the parameters passed 
    # in via the options hash, or using the default parameters.
    #
    # Options include:
    #   :length - total number of characters in the password, default is 12
    #   :words - total number of words in the password, between 1-4, default is 2
    #   :digits - number of digits between each word (not the total number), default is 2
    #   :language - abbreviation for language to use for the words, default is 'en' (English)
    #   :dictionary - specify a custom dictionary to use instead of the default dictionary
    #
    def new(options= {})
      password        = ""
      total_length    = (options[:length] || 12).to_i
      word_count      = (options[:words]  ||  2).to_i
      digit_length    = (options[:digits] ||  2).to_i
      word_options    = options.slice(:language, :dictionary)
      length_variance = 3
      
      validate_word_count(word_count)
      
      total_digits = digit_length * (word_count - 1)
      avg_word_length = (total_length - total_digits) / word_count
      
      validate_avg_word_length(avg_word_length)

      word_count.downto(1) do |n|
        length_needed = total_length - password.length
        break if length_needed <= 0

        if n == 1 # this is the last word
          word_options[:exact] = length_needed
        else # not the last word
          word_options[:min] = [1, avg_word_length - length_variance].max
          # max_length = total remaining length - remaining digits and words
          word_options[:max] = length_needed - ((n-1) * (digit_length + avg_word_length))
        end
        password << pick_dictionary_word(word_options)
        password << pick_random_number(digit_length).to_s if digit_length > 0 && n > 1
      end

      return password
    end

    protected
    
      # <tt>load_dictionary</tt> load the YAML dictionary file for the given language
      # The language should be a two letter abbreviation that corresponds to the file 
      # name in /lib/nice_password/dictionaries/*.yml such as 'en', 'fr', 'es'.
      def load_dictionary(lang)
        return false unless lang
        dictionary = File.join(File.dirname(__FILE__), 'dictionaries', "#{lang}.yml")
        YAML::load(File.open(dictionary))
      end
    
      # <tt>pick_dictionary_word</tt> selects a word from the dictionary that matches the 
      # desired (or default) length parameters.
      #
      # Options include:
      #   :min - minimum length word to retrieve, defaults to 1
      #   :max - maximum length word to retreive, defaults to 5
      #   :exact - if included, :exact overrides :min and :max lengths
      #   :language - abbreviation for language to use for the words, default is 'en' (English)
      #   :dictionary - specify a custom dictionary to use instead of the default dictionary
      #
      def pick_dictionary_word(options={})
        min_length = (options[:exact] || options[:min] || 1).to_i
        max_length = (options[:exact] || options[:max] || 5).to_i
        
        language   = (options[:language] || @@default_language).to_s
        validate_language(language)
        
        dictionary = options[:dictionary] || @@dictionaries[language] ||= load_dictionary(language)
        validate_dictionary(dictionary)
        
        sized_words = dictionary.select do |word|
          min_length <= word.length && word.length <= max_length
        end
        if !sized_words.empty?
          return sized_words[rand(sized_words.length)] 
        else
          # TODO: How should an empty sized_words be handled?
          return ""
        end
      end
    
      # <tt>pick_random_number</tt> chooses a random number with the same number of digits 
      # as the first argument
      def pick_random_number(digits=1)
        min = 10 ** (digits - 1)
        max = (10 ** digits ) - 1
        semirandom = min + rand(max-min)
        semirandom += 1 if semirandom == 666 #would be unpleasant to receive...
        return semirandom
      end
    
    private
    
      def validate_word_count(word_count)
        raise NicePassword::FormatError.new("Word count must be greater than 0") if word_count < 1
        raise NicePassword::FormatError.new("Word count must be less than 4") if word_count > 4
      end
      
      def validate_avg_word_length(avg_word_length)
        raise NicePassword::FormatError.new("Word length is too short, increase :length") if avg_word_length <= 2
        raise NicePassword::FormatError.new("Word length is too long, decrease :length") if avg_word_length >= 12
      end
      
      def validate_language(language)
        unless @@languages.include?(language)
          raise NicePassword::DictionaryError.new("Invalid language")
        end
      end
      
      def validate_dictionary(dictionary)
        unless dictionary.is_a?(Array) && !dictionary.compact.empty?
          raise NicePassword::DictionaryError.new("Invalid dictionary format")
        end
      end
      
  end
  
end
