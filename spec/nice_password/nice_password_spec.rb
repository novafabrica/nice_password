require File.expand_path('../../spec_helper', __FILE__)

describe "Nice Password" do

  describe "defaults" do

    it "should have the length of 12" do
      NicePassword.new.length.should == 12
    end

    it "should contain a two digit number" do
      digits = NicePassword.new.scan(/\d+/)
      digits.join.size.should == 2
    end

    it "should contain two words" do
      words = NicePassword.new.scan(/\D+/)
      words.size.should == 2
    end

  end

  describe "options" do

    it "should be able to specify length" do
      (8..24).each do |n|
        password = NicePassword.new(:length => n)
        password.length.should == n
      end
    end

    it "should be able to specify number of digits" do
      (1..5).each do |n|
        password = NicePassword.new(:digits => n)
        password.scan(/\d+/).join.size.should == n
      end
    end

    it "should be able to specify number of words" do
      (2..4).each do |n|
        # :length increases :words to avoid validation errors
        password = NicePassword.new(:words => n, :length => n * 5)
        password.scan(/\D+/).size.should == n
      end
    end
    
    it "should be able to specify the language as a string" do
      ['en', 'fr', 'es'].each do |lang|
        yaml_file = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'nice_password', 'dictionaries', "#{lang}.yml")
        dictionary = YAML::load(File.open(yaml_file))
        
        password = NicePassword.new(:language => lang)
        password.scan(/\D+/).each do |word|
          dictionary.include?(word).should be_true
        end
      end
      
    end
    
    it "should be able to specify the language as a symbol" do
      [:en, :fr, :es].each do |lang|
        yaml_file = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'nice_password', 'dictionaries', "#{lang}.yml")
        dictionary = YAML::load(File.open(yaml_file))
        
        password = NicePassword.new(:language => lang)
        password.scan(/\D+/).each do |word|
          dictionary.include?(word).should be_true
        end
      end
      
    end
    
    it "should be able to send an alternate dictionary" do
      dictionary = ['a', 'b', 'c', 'd', 'e', 'ax', 'be', 'co', 'do', 'em', 
        'art', 'bye', 'cat', 'doe', 'ear', 'aces', 'baby', 'cart', 'dove', 'even',
        'apple', 'boast', 'child', 'devil', 'eager',
        'aprons', 'bounce', 'chance', 'denied', 'easter',
        'approve', 'beneath', 'chiller', 'defined', 'evolves',
        'annotate', 'believes', 'children', 'destruct', 'eloquent',
        'appreciate', 'backbench', 'construct', 'deflected', 'everybody']
      password = NicePassword.new(:dictionary => dictionary)
      password.scan(/\D+/).each do |word|
        dictionary.include?(word).should be_true
      end
    end

  end

  describe "validations" do
    
    it "should raise FormatError if avg word count is too small" do
      lambda do
        NicePassword.new(:length => 6, :words => 0, :digits => 2)
      end.should raise_error(NicePassword::FormatError)
    end

    it "should raise FormatError if avg word count is too large" do
      lambda do
        NicePassword.new(:length => 6, :words => 5, :digits => 2)
      end.should raise_error(NicePassword::FormatError)
    end

    it "should raise FormatError if avg word length is too small" do
      lambda do
        NicePassword.new(:length => 6, :words => 2, :digits => 2)
      end.should raise_error(NicePassword::FormatError)
    end

    it "should raise FormatError if avg word length is too large" do
      lambda do
        NicePassword.new(:length => 26, :words => 2, :digits => 2)
      end.should raise_error(NicePassword::FormatError)
    end

    it 'should raise DictionaryError if language is an invalid choice' do
      lambda do
        NicePassword.new(:language => 'martian')
      end.should raise_error(NicePassword::DictionaryError)
    end
    
    it 'should raise DictionaryError if dictionary is invalid'   do
      lambda do
        NicePassword.new(:dictionary => {})
      end.should raise_error(NicePassword::DictionaryError)
      lambda do
        NicePassword.new(:dictionary => [])
      end.should raise_error(NicePassword::DictionaryError)
      lambda do
        NicePassword.new(:dictionary => [nil, nil, nil])
      end.should raise_error(NicePassword::DictionaryError)
    end
    
  end
  
end
