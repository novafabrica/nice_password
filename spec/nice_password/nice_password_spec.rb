require File.expand_path('../../spec_helper', __FILE__)

describe "Nice Password" do

  it "should raise Format Error if word count exceeds a threshold for decent generation" do
    lambda do
      NicePassword.new(:words => 6)
    end.should raise_error(NicePassword::FormatError)
  end

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
      (6..20).each do |n|
        NicePassword.new(:length => n).length.should == n
      end
    end

    it "should be able to specify number of digits" do
      (1..5).each do |n|
        digits = NicePassword.new(:digits => n).scan(/\d+/)
        digits.join("").size.should == n
      end
    end

    it "should be able to specify number of words" do
      (1..3).each do |n|
        words = NicePassword.new(:words => n)
        words.scan(/\D+/).size.should == n
      end
    end
    
    it "should be able to specify the language"
    
    it "should be able to send an alternate dictionary"

  end

end
