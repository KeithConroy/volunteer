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
type = ShiftType.create(
  organization_id: org.id,
  name: 'Animal Care AM',
  description: 'Feed/Clean'
)
address = Address.create(
  line_1: '123 Main Street',
  city: 'Gotham',
  state: 'CA',
  zip_code: '12345',
  organization_id: org.id
)
shift = Shift.create(
  shift_type_id: 1,
  starts_at: DateTime.now,
  ends_at: DateTime.now + 1.hour,
  slots: 2,
  address_id: address.id
)
UserShift.create(
  user_id: user.id,
  shift_id: shift.id
)

