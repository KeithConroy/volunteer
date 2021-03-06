# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

data = [
  {
    org_name: 'Serenity Animal Sanctuary',
    shift_type_1: {
      name: 'Morning Animal Care',
      description: 'Clean/Breakfast'
    },
    shift_type_2: {
      name: 'Afternoon Animal Care',
      description: 'Clean/Dinner'
    },
    role_1: {
      name: 'Green',
      description: 'Entry level'
    },
    role_2: {
      name: 'Blue',
      description: 'Experienced'
    }
  },
  {
    org_name: 'My Non Profit',
    shift_type_1: {
      name: 'Dog Walking',
      description: 'Walk around the block'
    },
    shift_type_2: {
      name: 'Cat Socializing',
      description: 'Play with kittens'
    },
  }
]

user = User.create!(
  first_name: 'Keith',
  last_name: 'Conroy',
  email: 'keith@mail.com',
  password: 'password',
)

2.times do |org_num|
  org = Organization.create!(
    name: data[org_num][:org_name],
    description: '',
    url: 'www.google.com'
  )
  OrganizationAdmin.create!(
    organization_id: org.id,
    user_id: user.id
  )
  users = []
  2.times do |i|
    users << User.create!(
      first_name: 'User',
      last_name: "Test#{org_num}#{i}",
      email: "user#{org_num}#{i}@mail.com",
      password: "password#{org_num}#{i}",
    )
  end

  org.user_organizations.create!(
    user_id: user.id,
    status: :approved
  )
  org.user_organizations.create!(
    user_id: users[0].id,
    status: :approved
  )
  org.user_organizations.create!(
    user_id: users[1].id,
    status: :pending
  )

  address = org.addresses.create!(
    line_1: '123 Main Street',
    city: 'Gotham',
    state: 'CA',
    zip_code: '12345',
  )

  type = org.shift_types.create!(
    name: data[org_num][:shift_type_1][:name],
    address_id: address.id,
    description: data[org_num][:shift_type_1][:description],
  )

  type_2 = org.shift_types.create!(
    name: data[org_num][:shift_type_2][:name],
    address_id: address.id,
    description: data[org_num][:shift_type_2][:description],
  )

  if org_num == 0
    role_1 = org.roles.create!(
      name: data[org_num][:role_1][:name],
      description: data[org_num][:role_1][:description]
    )
    UserRole.create!(
      user_id: user.id,
      role_id: role_1.id
    )
    UserRole.create!(
      user_id: users[0].id,
      role_id: role_1.id
    )

    role_2 = org.roles.create!(
      name: data[org_num][:role_2][:name],
      description: data[org_num][:role_2][:description]
    )

    type.update(role_id: role_1.id)
    type_2.update(role_id: role_2.id)
  end

  shift = org.shifts.create!(
    shift_type_id: type.id,
    date: Date.today,
    start_time: Time.now.beginning_of_hour + 6.hours,
    end_time: Time.now.beginning_of_hour + 7.hours,
    spots: 2,
  )
  shift.user_shifts.create!(user_id: users[0].id)
  shift.user_shifts.create!(user_id: user.id)

  completed_shift = org.shifts.create!(
    shift_type_id: type.id,
    date: Date.today - 2.days,
    start_time: Time.now.beginning_of_hour,
    end_time: Time.now.beginning_of_hour + 1.hour,
    spots: 2,
  )
  completed_shift.user_shifts.create!(user_id: users[0].id)
  completed_shift.user_shifts.create!(user_id: user.id)

  org.shifts.create!(
    shift_type_id: type_2.id,
    date: Date.today,
    start_time: Time.now.beginning_of_hour,
    end_time: Time.now.beginning_of_hour + 1.hour,
    spots: 2,
  )

  3.times do |i|
    org.shifts.create!(
      shift_type_id: type.id,
      date: Date.today + i.days,
      start_time: Time.now.beginning_of_hour,
      end_time: Time.now.beginning_of_hour + 1.hour,
      spots: 2,
    )
  end

  org.schedules.create!(
    shift_type_id: type_2.id,
    start_date: Date.today,
    end_date: Date.today + 14.days,
    frequency: :daily,
    # frequency_data: 'MWF',
    start_time: Time.now.beginning_of_hour,
    end_time: Time.now.beginning_of_hour + 4.hours,
    spots: 3,
    days_out: 7,
  )
end
