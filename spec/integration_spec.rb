require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

RSpec.configure do |config|
  config.before(:each) do
    DB.exec("DELETE FROM lists *;")
    DB.exec("DELETE FROM tasks *;")
  end
end

describe('The To Do List Manager App', {:type => :feature}) do
  describe('adding a new list') do
    it('allows a user to click a list to see the tasks and details for it') do
      visit('/')
      click_link('Add New List')
      fill_in('list_name', :with => 'Weekend Chores')
      click_button('Add List')
      expect(page).to have_content('Weekend Chores')
      expect(page).to have_content('Success!')
    end
  end

  describe('navigating back to index after adding new list') do
    it('allows user to navigate back to index after adding new list') do
      visit('/')
      click_link('Add New List')
      fill_in('list_name', :with => 'Weekend Chores')
      click_button('Add List')
      click_link('Back')
      expect(page).to have_content('View All Lists')
      expect(page).to have_content('Add New List')
    end
  end

  describe('viewing all lists') do
    it('allows a user to view all saved lists') do
      list = List.new({:name => 'Test List', :id => nil})
      list.save()
      visit('/')
      click_link('View All Lists')
      expect(page).to have_content(list.name)
    end
  end

  describe('viewing specific list') do
    it("allows a user to view a specific list") do
      list = List.new({:name => 'Test List', :id => nil})
      list.save()
      visit('/lists')
      click_link('Test List')
      expect(page).to have_content(list.name)
    end
    it('allows user to view task(s) in a list') do
      list = List.new({:name => 'whatever', :id => nil})
      list.save()
      task = Task.new({:description => 'test', :list_id => list.id, :due_date => Date.new(2015,9,18)})
      task.save()
      visit("/lists/#{list.id}")
      expect(page).to have_content(task.description)
      expect(page).to have_content(task.due_date)
    end
  end

  describe('creating a new task') do
    it('allows user to create a new task for a list') do
      list = List.new({:name => 'whatever', :id => nil})
      list.save()
      visit("/lists/#{list.id}")
      click_link('Enter a task')
      fill_in('task_description', :with => 'new task description')
      fill_in('due_date', :with => Date.new(2015,9,18))
      click_button('Add Task')
      expect(page).to have_content('new task description')
      expect(page).to have_content(Date.new(2015,9,18))
    end
  end

  describe('creates a link back to index') do
    it('allows user to go back to original page') do
      list = List.new({:name => 'iam', :id => nil})
      list.save()
      visit("/lists/#{list.id}")
      click_link('Take me Home')
      expect(page).to have_content('View All Lists')
      expect(page).to have_content('Add New List')
    end

    describe('creates a link back to all lists page') do
      it('allows user to go back to all lists page') do
        list = List.new({:name => 'Cray cray', :id => nil})
        list2 = List.new({:name => 'Awesome', :id => nil})
        list.save()
        list2.save()
        visit("/lists/#{list.id}")
        click_link('Go back to Lists')
        expect(page).to have_content(list.name())
        expect(page).to have_content(list2.name())
      end
    end
  end


end
