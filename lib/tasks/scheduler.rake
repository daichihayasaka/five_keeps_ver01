desc "This task is called by the Heroku scheduler add-on"
task :delete_all_guests => :environment do
  puts "Updating guests..."
  User.where(guest: :true).where("created_at < ?", 1.day.ago).destroy_all
  puts "done."
end
