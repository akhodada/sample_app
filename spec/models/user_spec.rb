# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
	:name => "Example User", 
	:email => "user@example.com",
	:password => "foobar",
	:password_confirmation => "foobar"
 

    }
  end
  describe "micropost associations" do
    before(:each) do
      @user = User.create(@attr)
    end
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
  end
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
    it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  it "should have a name maximum 50 charactors" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@FOO.BAR.ORG first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject duplicat email addresses" do
    User.create!(@attr)
    user_duplicate_email = User.new(@attr)
    user_duplicate_email.should_not be_valid
  end
  it "should reject duplicate email uppercase as well" do
    upper_case_email =  @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_case_email))
    user_duplicate_email = User.new(@attr)
    user_duplicate_email.should_not be_valid
  end
  describe "password validation" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
      should_not be_valid
    end
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid"))
      should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end 
  end   
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)  
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:emial], "wrongpass")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        nonexistance_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistance_user.should be_nil
      end
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end 
  describe "micropost associations" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    describe "status feed " do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      it "should include the user's microposts" do
	@user.feed.include?(@mp1).should be_true
	@user.feed.include?(@mp2).should be_true
      end
      it "should not include a different user's microposts" do
	mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
	@user.feed.include?(mp3).should be_false
      end
    end
  end
end