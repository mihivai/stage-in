require "faker"
ActionMailer::Base.perform_deliveries = false

puts "Cleaning DB..."

HiringCheckpoint.destroy_all
StudentHiring.destroy_all
Hiring.destroy_all
Internship.destroy_all
User.where(role: :student).destroy_all
User.where(role: :college).destroy_all
User.where(role: :company).destroy_all
StudentSkill.destroy_all
Skill.destroy_all
Checkpoint.destroy_all

puts "Seeding User Colleges"

c1 = User.create!(
  college_name: "Collège Arnault Daniel",
  zipcode: "24600",
  address: "Rue Couleau",
  city: "Ribérac",
  email:"arnault.daniel@averifier.com",
  password: "123456",
  role: 'college')
c2 = User.create!(
  college_name: "Collège Michel Debet",
  zipcode: "24350",
  address: "Route du Treuil",
  city: "Tocane-Saint-Apre",
  email: "ce.0240073z@ac-bordeaux.fr",
  password: "123456",
  role: 'college')
c3 = User.create!(
  college_name: "MFR du Ribéracois",
  zipcode: "24600",
  address: "Le Bourg",
  city: "Vanxains",
  email: "mfr.vanxains@mfr.asso.fr",
  password: "123456",
  role: 'college')

puts "Colleges created"


puts "Seeding User Student"

User.create!(
  email: "jules@gmail.com",
  num: "30",
  address: "Rue Couleau",
  zipcode: "24600",
  city: "Ribérac",
  birthday: Date.new(2000, 01, 14),
  first_name: 'Jules',
  last_name: 'Maregiano',
  role: 'student',
  password: '123soleil',
  level: '3ème',
  phone: '0123456789',
  college: c1,
  college_acceptation: true)

puts "Student created"


puts "Seeding Skills"

Skill.create!(name: "Artisanat, Métiers du Batiment", image: 'artisanat.jpg')
Skill.create!(name: "Agriculture, Agroalimentaire", image: 'agriculture.jpg')
Skill.create!(name: "Secrétariat, Comptabilité, Commerce", image: 'commerce.jpg')
Skill.create!(name: "Métiers de bouche, Hôtellerie, Restauration", image: 'restauration.jpg')
Skill.create!(name: "Métiers de l’industrie et de la maintenance", image: 'industrie.jpg')
Skill.create!(name: "Métiers du numérique", image: 'numerique.jpg')
Skill.create!(name: "Métiers du Social, de la Santé, Service à la personne", image: 'social.jpg')
Skill.create!(name: "Tourisme, Culture, Sport", image: 'tourisme.jpg')
Skill.create!(name: "Transport, logistique", image: 'transport.jpg')

puts "Skills created"


puts "Seeding Internships"

is = Internship.new(
  starts_at: Date.new(2018, 12, 3),
  ends_at: Date.new(2018, 12, 7),
  comment: "Stage de 3ème 2018-2019",
  college: c1
  )
is.save!
is = Internship.new(
  starts_at: Date.new(2018, 12, 17),
  ends_at: Date.new(2018, 12, 21),
  comment: "Stage de 3ème 2018-2019",
  college: c2
  )
is.save!
is = Internship.new(
  starts_at: Date.new(2019, 01, 14),
  ends_at: Date.new(2019, 01, 25),
  comment: "Stage de 3ème 2018-2019",
  college: c3
  )
is.save!

puts "Internships created"


puts "Seeding User Companies & Hirings"

csv_options = { col_sep: ';', quote_char: "|", headers: :first_row }
csv_filepath = File.read(Rails.root.join('db', 'csv', 'list_companies.csv'))
csv_companies = CSV.parse(csv_filepath, csv_options)
companies = []

csv_companies.each do |row|
  skill = Skill.find_by_name(row['skill'])
  company = User.new(
      company: row['company'],
      email: row['email'],
      password: "123soleil",
      description: row['description'],
      address: row['address'],
      zipcode: row['zipcode'],
      city: row['city'],
      phone: row['phone'],
      role: 'company'
    )
  company.skill = skill
  company.save!
  hiring = Hiring.new(
    internship: Internship.all.sample,
    company: company,
    visible: true
  )
  hiring.save!
end

puts "Companies & Hirings created"


puts "Seeding objectives"

checkpoints = [ "Je me renseigne sur l'entreprise.",
                "J'informe l'entreprise que je suis intéressé.",
                "Je prend rendez-vous avec l'entreprise."
              ]
checkpoints.each_with_index do |title, i|
  Checkpoint.create!(title: title, order: i)
end

puts "Objectives created"

puts "The seed is done"



