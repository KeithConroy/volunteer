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
org = Organization.create(
  name: 'Serenity Animal Sanctuary',
  description: '',
  url: 'www.google.com'
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
  description: ''
)
role_2 = Role.create(
  organization_id: org.id,
  name: 'Blue',
  description: ''
)
type = ShiftType.create(
  organization_id: org.id,
  name: 'Animal Care AM',
  address_id: address.id,
  description: 'Feed/Clean'
)
type_2 = ShiftType.create(
  organization_id: org.id,
  name: 'Animal Care PM',
  address_id: address.id,
  description: 'Feed Dinner'
)
shift = Shift.create(
  shift_type_id: type.id,
  starts_at: DateTime.now,
  ends_at: DateTime.now + 1.hour,
  slots: 2,
  role_id: role_1.id
)
shift_2 = Shift.create(
  shift_type_id: type_2.id,
  starts_at: DateTime.now,
  ends_at: DateTime.now + 1.hour,
  slots: 2,
  address_id: address.id,
  role_id: role_2.id
)
UserShift.create(
  user_id: user.id,
  shift_id: shift.id
)
UserRole.create(
  user_id: user.id,
  role_id: role_1.id
)

