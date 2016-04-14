def sign_up(email: 'test@test.com')
  visit '/users/sign_up'
  fill_in 'Email', with: email
  fill_in 'Password', with: '12345678'
  fill_in 'Password confirmation', with: '12345678'
  click_button 'Sign up'
end


def create_restaurant
  visit '/restaurants'
  click_link 'Add a restaurant'
  fill_in 'Name', with: 'KFC'
  click_button 'Create Restaurant'
  expect(page).to have_content 'KFC'
  expect(current_path).to eq '/restaurants'
end

def sign_in
end
