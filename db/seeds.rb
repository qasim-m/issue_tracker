# db/seeds.rb
puts "Seeding database..."
# Clear existing data
Comment.destroy_all
Issue.destroy_all
Project.destroy_all
User.destroy_all
# === Users ===
users = []
(1..10).each do |i|
  users << User.find_or_create_by!(email: "user#{i}@example.com") do |user|
    user.name = "User #{i}"
    user.password = "password"  # Devise requires password
    user.password_confirmation = "password"
  end
end
puts "Created #{users.size} users"

# === Projects ===
projects = []
(1..30).each do |i|
  projects << Project.find_or_create_by!(title: "Project #{i}", user: users[i % users.size])
end
puts "Created #{projects.size} projects"

# === Issues & Comments ===
projects.each do |project|
  (1..30).each do |i|
    creator = users.sample
    assignee = (users - [creator]).sample

    issue = Issue.find_or_create_by!(project: project, issue_number: i) do |iss|
      iss.title = "Issue #{i} for #{project.title}"
      iss.description = "This is description for issue #{i} in #{project.title}"
      iss.created_by = creator.id
      iss.assigned_to = assignee&.id
      iss.status = 0 # default (open)
    end

    # Add comments
    (1..5).each do |j|
      Comment.find_or_create_by!(issue: issue, text: "Comment #{j} on #{issue.title}") do |comment|
        comment.user = users.sample
      end
    end
  end
end

puts "Seeding completed!"
