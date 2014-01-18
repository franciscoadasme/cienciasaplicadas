# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Group.create!(
  name: 'Doctorado en Ciencias Aplicadas',
  abbr: 'CienciasAplicadas',
  email: 'contact@cienciasaplicadas.cl'
)
user = User.create!(
  first_name: 'Francisco',
  last_name: 'Adasme',
  nickname: 'fadasme',
  email: 'francisco.adasme@gmail.com',
  role: User::ROLE_ADMIN,
  password: '13051988',
  invitation_accepted_at: DateTime.current
)
user.build_settings.save!

Page.seed! author: user, published: true
Position.seed!
MailingList.seed!