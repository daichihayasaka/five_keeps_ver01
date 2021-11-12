# 5Keeps
※**日本語は[こちら](/README_ja.md)**  
 This is simple bookmark app. You can create up to 5 groups and 5 links per group. By keeping only the information you need now, you can quickly access to it. (https://www.5keeps.com/en)

[![5Keeps_ogp_en](https://user-images.githubusercontent.com/72771511/141037698-e0e90d12-854a-4a50-aebf-142ccd588628.png)](https://www.5keeps.com/en)

## Summary
### Issues to be solved
This service can provide solutions to users who are facing the following issues with their browser's bookmarking function.
- Difficult to access to the information quickly because of the too many bookmarks .
- It's hard to organize too many bookmarks.

### Solution
We have solved the problem by limiting the functions as follows. Save the information needed right now in plain sight.
- Up to 5 groups can be created.
- Up to 5 links can be created for each group.
- Links must have a title.

### How to use
Please refer to the top page of the application.   
https://www.5keeps.com/en

## Functions/ Features
### User-related
- create, view, update, delete
- authentication/authorization
- remember me
- account activation by email
- password reset by email
- guest-login function  
*details is written later
### Group-related
- create, view, update, delete by asynchronous communication
### Link-related
- create, view, update, delete by asynchronous communication
- display data of an open graph protocol.  
*Fetch from URL by Nokogiri gem
- search function
### Others
- contact function（using Gmail）
- switch language function（Japanese/ English）

## Details of guest-login function
Create a temporary guest account that visitor can use to try the application. Later on visitor can sign up for a permanent account if they like it.
I implement this guest-login function as below.

**1. Add a boolean guest attribute to the users table**
（db/migrate/xxxx_add_guest_to_users.rb）

```ruby
class AddGuestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :guest, :boolean, default: false
  end
end
```

**2. Add route for guest page**   
（config/routes.rb）
```ruby
post '/guest', to:'users#create_guest'
get '/guest', to:'static_pages#guest'
```

**3. Add create_guest action to users controller**
（app/controllers/users_controller.rb）
```ruby
  # POST /guest
  # Current user is guest => Redirect to guest page
  # Current user is nil => Create new guest account
  def create_guest
    if current_user && current_user.guest?
      redirect_to guest_path
    else
      user = User.create(name: "Guest User",
                                   email: SecureRandom.alphanumeric(15) + "@guest.com",
                            password: SecureRandom.alphanumeric(10),
                                  guest: 1)
      log_in user
      flash[:success] = t('.flash.success')
      redirect_to guest_path
    end
  end
```

**4. Add guest action to static_pages controller**   
（app/controllers/static_pages_controller.rb）
```ruby
  # GET /guest
  # Current user is nil or Current user is not a guest account => Redirect to root url
  def guest    
    redirect_to root_url if !current_user || !current_user.guest?
  end
```

**5. Delete guest user regularly**   
Guest accounts deleted automatically by Heroku scheduler.   
Run below rake task automatically at 4:00 PM UTC everyday.   
（lib/tasks/scheduler.rake）

```ruby
desc "This task is called by the Heroku scheduler add-on"
task :delete_all_guests => :environment do
  puts "Updating guests..."
  # Destroy all the guest accounts that were created over a day ago.
  User.where(guest: :true).where("created_at < ?", 1.day.ago).destroy_all
  puts "done."
end
```

## ER diagram
![er_diagram](https://user-images.githubusercontent.com/72771511/140603325-dafce5de-d449-4076-9f73-85b6b5e8b3cb.png)

## Technologies used 
- Ruby 2.6.3
- Ruby on Rails 6.1.4
- Vanilla JS
- Sass
- MySQL 8.0
- Heroku
- Minitest

## Plan to improve
### Usability
- Make asynchronous communication faster
- Improve UI and UX on mobile screen.
- Implement social login function.
- Implement SNS sharing function.
### Technologies
- Rewrite test by RSpec.
- Using AWS instead of Heroku.
- Remake app as REST API with React.
