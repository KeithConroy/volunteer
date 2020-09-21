# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(
  first_name: 'Keith',
  last_name: 'Conroy',
  email: 'kconroyjr@gmail.com'
)
4.times do |i|
  User.create(
    first_name: 'User',
    last_name: "Test#{i}",
    email: "user#{i}@gmail.com"
  )
end

org = Organization.create(
  name: 'Serenity Animal Sanctuary',
  description: '',
  url: 'www.google.com'
)
UserOrganization.create(
  user_id: user.id,
  organization_id: org.id,
  status: :approved
)

Organization.create(
  name: 'My Non Profit',
  description: '',
  url: 'www.mynonprofit.com',
  requires_approval: true
)

address = Address.create(
  line_1: '123 Main Street',
  city: 'Gotham',
  state: 'CA',
  zip_code: '12345',
  organization_id: org.id
)

role_1 = Role.create(
  organization_id: org.id,
  name: 'Green',
  description: 'Entry Level'
)
UserRole.create(
  user_id: user.id,
  role_id: role_1.id
)

role_2 = Role.create(
  organization_id: org.id,
  name: 'Blue',
  description: 'Experienced'
)

type = ShiftType.create(
  organization_id: org.id,
  name: 'Animal Care AM',
  address_id: address.id,
  description: 'Feed/Clean',
  role_id: role_1.id
)

type_2 = ShiftType.create(
  organization_id: org.id,
  name: 'Animal Care PM',
  address_id: address.id,
  description: 'Feed Dinner',
  role_id: role_1.id
)

shift = Shift.create(
  shift_type_id: type.id,
  starts_at: DateTime.now + 6.hours,
  ends_at: DateTime.now + 7.hours,
  spots: 2,
)

shift_2 = Shift.create(
  shift_type_id: type_2.id,
  starts_at: DateTime.now,
  ends_at: DateTime.now + 1.hour,
  spots: 2,
)

completed_shift = Shift.create(
  shift_type_id: type.id,
  starts_at: DateTime.now - 2.days,
  ends_at: DateTime.now - 2.days + 1.hour,
  spots: 2,
)
UserShift.create(
  user_id: user.id,
  shift_id: shift.id
)
UserShift.create(
  user_id: user.id,
  shift_id: completed_shift.id
)

3.times do |i|
  Shift.create(
    shift_type_id: type.id,
    starts_at: DateTime.now + i.days,
    ends_at: DateTime.now + i.days + 1.hour,
    spots: 2,
  )
end
