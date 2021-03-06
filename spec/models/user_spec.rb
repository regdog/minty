# encoding: utf-8

require 'spec_helper'

describe User do
  let(:valid_attrs) do
    {name: "abcde", password: "123456", email: "a@a.com", phone: "010-2222-0000"}
  end

  context "validation" do
    it '제대로된 값을 가지고는 user가 만들어진다.' do
      user = User.new(valid_attrs)
      user.should be_valid
    end

    it '유저 이름은 4글자 이상이여야 한다.' do
      too_short_user_name = valid_attrs.merge(name: 'abc')
      user = User.new( too_short_user_name )
      user.should_not be_valid
    end

    it '유저 이름은 중복될 수 없다.' do
      User.create!(valid_attrs)

      new_user = User.new(valid_attrs)
      new_user.should_not be_valid
    end

    it '유저 이름이 없으면 에러가 난다.' do
      user = User.new(valid_attrs.merge(name: nil))
      user.should_not be_valid
    end

    it '유저 이름에는 영문자와 숫자 그리고 언더바만 사용할 수 있다.' do
      valid_names = ['___abcd', '________']
      invalid_names = ['+abcd', '    ', 'asdf,zzz', '진창훈ㅋ']

      valid_names.each do |name|
        User.new(valid_attrs.merge(name: name)).should be_valid
      end

      invalid_names.each do |name|
        User.new(valid_attrs.merge(name: name)).should_not be_valid
      end
    end

    it '이름은 40자 이하여야 한다' do
      user = User.new(valid_attrs.merge(name: "0123456789012345678901234567890123456789"))
      user.should be_valid

      user = User.new(valid_attrs.merge(name: "01234567890123456789012345678901234567891"))
      user.should_not be_valid
    end

    it '유저의 트윗 목록의 순서가 최신 순으로 정렬되어야 한다.' do
      user = User.create!(valid_attrs)
      tweet1 = Tweet.create!(content: "dkdk", user_id: user.id)
      tweet2 = Tweet.create!(content: "dhdh", user_id: user.id)

      user.tweets.first.should == tweet2
    end
  end

  context 'profile image' do
    it 'Profile image 를 저장할 수 있다.' do
      user = User.new(valid_attrs)
      test_file = Rails.root.join('spec', 'fixtures', 'sample.gif')
      file = File.open(test_file)

      user.profile_image = file
      user.save

      user.profile_image.url.should == "/uploads/user/profile_image/1/sample.gif"
    end

    it 'should respond to profile_thumb_image' do
      user = User.new(valid_attrs)
      test_file = Rails.root.join('spec', 'fixtures', 'sample.gif')
      file = File.open(test_file)

      user.profile_image = file
      user.save

      user.profile_thumb_image.should == "/uploads/user/profile_image/1/thumb_sample.gif"
    end
  end

  context 'favorite_tweets' do
  	let(:user) { User.create! name:'tester', password: "123456", email: "a@a.com", phone: "010-2222-0000" }
  	let(:tweet) { Tweet.create! content: 'test content' }

  	it 'should add tweet to my favorites list' do
  		user.add_to_favorites tweet
  		user.favorite_tweets.should include(tweet)
  	end
  end

  it '유저의 트윗 목록의 순서가 최신 순으로 정렬되어야 한다.' do
    user = User.create!(valid_attrs)
    tweet1 = Tweet.create!(content: "dkdk", user_id: user.id)
    tweet2 = Tweet.create!(content: "dhdh", user_id: user.id)

    user.tweets.first.should == tweet2
  end

  context "user password" do
    it '유저의 비밀번호는 없으면 안된다.' do
      user = User.new(valid_attrs.merge(password: nil))
      user.should_not be_valid
    end

    it '유저의 비밀번호는 6자리 이상 12자리 이하여야 한다.' do
      user1 = User.new(valid_attrs.merge(password: "1234"))
      user1.should_not be_valid

      user2 = User.new(valid_attrs.merge(password: "123456789101123"))
      user2.should_not be_valid
    end
  end
end