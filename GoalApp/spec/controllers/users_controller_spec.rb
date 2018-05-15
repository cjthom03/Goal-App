require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    describe 'GET#new' do
      it 'renders the new template' do 
        get :new
        expect(response).to render_template(:new)
      end
    end
    
    describe 'POST#Create' do
      context 'with invalid params' do
        before :each do  
          post :create, 
          params: { user: { username: "charlie", password: "" } }
        end 
    
        it 'flashes errors' do
          expect(flash[:errors]).to be_present
        end
    
        it 're-renders the new template' do
          expect(response).to render_template(:new)
        end 
      end
    
      context 'with valid params' do
        before :each do  
          post :create, 
          params: { user: { username: "charlie", password: "123456" } }
        end 
    
        it 'saves the user to the database and logs the user in' do
          user = User.find_by_credentials("charlie", "123456")
          expect(user).not_to be_nil
          expect(user.session_token).to eq(session[:session_token])
        end
    
        it 'redirects to the users#show page' do
          user = User.find_by_credentials("charlie", "123456")
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
    
    describe 'GET#show' do
      context 'when not logged in' do
        it 'redirects to the log in page' do
          user = User.create(username: "charlie", password: "123456")
          session[:sesion_token] = nil
          get :show, params: {id: user.id}
          expect(response).not_to render_template(:new)
          expect(response).to redirect_to(new_session_path)
        end 
      end
    
      context 'when logged in' do
        it 'renders the show page' do
          user = User.create!(username: "charlie", password: "123456")
          get :show, params: { id: user.id }
          debugger
          expect(response).to render_template('show')
        end
      end
    end
end
