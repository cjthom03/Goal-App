# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.create(username: "charlie", password: "charlie123") }
  
  describe 'Validations' do
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_uniqueness_of(:username)}
    it {should validate_length_of(:password).is_at_least(6)}
    it {should allow_value(nil).for(:password)}
    
    it 'assigns a session_token if one is not given' do
      user = User.new(username: "charlie", password: "charlie123")
      user.valid?
      expect(user.session_token).not_to be_nil
    end
  end
  
  describe 'Methods' do
    describe 'User#reset_token' do
      it 'changes the users session_token in the database and returns the new token' do
        start_token = user.session_token
        new_token = user.reset_token!
        expect(new_token).not_to be_nil
        expect(new_token).not_to eq(start_token)
        expect(User.find_by_session_token(new_token)).to eq(user)
      end
    end
    
    describe 'User::find_by_credentials' do
      context 'with invalid params' do
        it 'returns nil' do
          charlie = User.find_by_credentials("charlie", "chrlie")
          expect(charlie).to be_nil
        end
      end
      
      context 'with valid params' do
        it 'returns the user' do
          user = User.create(username: "charlie", password: "charlie123")
          charlie = User.find_by_credentials("charlie", "charlie123")
          expect(charlie).to eq(user)
          
        end
      end
    end
  end

  #test associations once created  
  
  #password= assigns a password_digest
end
