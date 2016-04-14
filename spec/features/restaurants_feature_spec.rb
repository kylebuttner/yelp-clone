require 'rails_helper'

feature 'restaurants' do
  context 'when logged out' do
    context 'restaurants have been added' do
      before do
        Restaurant.create(name: 'KFC')
      end

      scenario 'display restaurants' do
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end
    end

    scenario 'cannot see Add restaurant link' do
      visit '/restaurants'
      expect(page).not_to have_link 'Add a restaurant'
    end

    scenario 'cannot access unauthorized views' do
      visit '/restaurants/new'
      expect(current_path).to eq '/users/sign_in'
      visit '/restaurants/1/edit'
      expect(current_path).to eq '/users/sign_in'
    end

    context 'viewing restaurants' do
      let!(:kfc){Restaurant.create(name:'KFC')}

      scenario 'lets a user view a restaurant' do
        visit '/restaurants'
        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end

  end

  context 'when logged in' do
    before do
      sign_up
    end

    context 'no restaraunts have been added' do
      scenario 'should display a prompt to add a restaurant' do
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end


    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        create_restaurant
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end
    end


    context 'ammending restaurants' do
      before do
        create_restaurant
      end 

      scenario 'let a user edit their restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'does not let a user edit a restaurant they did not create' do
        click_link 'Sign out'
        visit '/users/sign_up'
        fill_in 'Email', with: 'test2@test.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '12345678'
        click_button 'Sign up'
        visit '/restaurants'
        expect(page).not_to have_link 'Edit KFC' 
      end

      context 'deleting restuarants' do
        scenario 'User can delete restaurant' do
          visit '/restaurants'
          click_link 'Delete KFC'
          expect(page).not_to have_content 'KFC'
          expect(page).to have_content 'Restaurant deleted sucessfully'
        end
      end
    end
      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end
  end
