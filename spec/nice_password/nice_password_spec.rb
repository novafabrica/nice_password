require File.expand_path('../../spec_helper', __FILE__)
describe "Nice Password" do

  np = NicePassword

  it "should raise Format Error if word count exceeds a threshold for decent generation" do
    lambda do
      np.new(:word_count => 6)
    end.should raise_error(NicePassword::FormatError)
  end

  describe "defaults" do

    it "should have the length of 12" do
      np.new.length.should == 12
    end

    it "should contain a two digit number" do
      p = np.new
      digits = p.scan(/\d+/)

      digits.join("").size.should == 2
    end

    it "should contain a two words" do
      words = np.new.scan(/\D+/)
      words.size.should == 2
    end

  end

  describe "options" do

    it "should be able to specify length" do
      np.new(:length => 20).length.should == 20
    end

    it "should be able to specify number of digits" do
      digits = np.new(:digits => 8).scan(/\d+/)
      digits.join("").size.should == 8
    end

    it "should be able to specifiy number fo words" do
      words = np.new(:word_count => 4, :length => 20, :language => :en)
      words.scan(/\D+/).size.should == 4
    end

  end

end
