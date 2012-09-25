# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

content = [
  {first_name: "Troy", last_name: "McClure", title: "Bovine Carnivores", 
    body: "Don't kid yourself, Jimmy. If a cow ever got the chance, he'd eat you and everyone you care about!"},
  {first_name: "Homer", last_name: "Simpson", title: "Gun Control", 
    body: "When I held that gun in my hand, I felt a surge of power...like God must feel when he's holding a gun."},
  {first_name: "Milhouse", last_name: "Van Houten", title: "Friendship", 
    body: "Remember the time he ate my goldfish? And you lied and said I never had goldfish. Then why did I have the bowl, Bart? *Why did I have the bowl?*"},
  {first_name: "Ned", last_name: "Flanders", title: "Following Doctrine", 
    body: "I've done everything the Bible says - even the stuff that contradicts the other stuff!"},
  {first_name: "Sideshow", last_name: "Bob", title: "Politics Never Changes", 
    body: "I'll be back. You can't keep the Democrats out of the White House forever, and when they get in, I'm back on the streets, with all my criminal buddies."},
  {first_name: "Bart", last_name: "Simpsons", title: "Insights on life", 
    body: "I didn't think it was physically possible, but this both sucks *and* blows"}
]

content.each do |c|
  user = User.new(first_name: c[:first_name], last_name: c[:last_name])
  user.posts << Post.new(title: c[:title], body: c[:body])
  user.save
end




