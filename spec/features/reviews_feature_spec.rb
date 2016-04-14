require 'rails_helper'

feature 'reviewing' do
  before do
    sign_up
    create_restaurant
  end 

  context 'review has been left' do
    before do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end


    scenario 'allows users to leave a review using a form' do
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'so so'
    end

    scenario 'deletes review upon restaurant deletion' do
      click_link 'Delete KFC'
      expect(Review.count).to be 0
    end

    scenario 'user can only leave one review per restaurant' do
      expect(page).not_to have_link 'Review KFC'
    end

    scenario 'user can delete their own reviews' do
      expect(page).to have_link 'Delete review'
    end

    scenario 'user cannot delete others\' reviews' do
      click_link 'Sign out'
      sign_up(email: 'test2@test.com')
      expect(page).not_to have_link 'Delete review'
    end

  end
end
