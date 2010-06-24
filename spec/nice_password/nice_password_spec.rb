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
      NicePassword.new(:length => 20).length.should == 20
    end

    it "should be able to specify number of digits" do
      digits = NicePassword.new(:digits => 8).scan(/\d+/)
      digits.join("").size.should == 8
    end

    it "should be able to specify number of words" do
      words = NicePassword.new(:words => 4, :length => 20, :language => :en)
      words.scan(/\D+/).size.should == 4
    end

  end

end
