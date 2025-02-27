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

# SKILLS = SECTEUR D'ACTIVITE

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578053/SA_artisanat_mvmrvr.jpg"
Skill.create!(name: "Artisanat, Métiers du Batiment")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578054/SA_agriculture_b8up9i.jpg"
Skill.create!(name: "Agriculture, Agroalimentaire")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578053/SA_assurance_ouojh5.jpg"
Skill.create!(name: "Secrétariat, Comptabilité, Commerce")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578054/SA_commerce_s67fbz.jpg"
Skill.create!(name: "Métiers de bouche, Hôtellerie, Restauration")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578053/SA_industry_abd7bg.jpg"
Skill.create!(name: "Métiers de l’industrie et de la maintenance")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578053/SA_internet_ojzgiw.jpg"
Skill.create!(name: "Métiers du numérique")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578053/SA_research_cns4mx.jpg"
Skill.create!(name: "Métiers du Social, de la Santé, Service à la personne")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "http://res.cloudinary.com/stage-in/image/upload/v1519578054/SAtourisme_d6qtkw.jpg"
Skill.create!(name: "Tourisme, Culture, Sport")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"

url = "https://images.pexels.com/photos/1267338/pexels-photo-1267338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
Skill.create!(name: "Transport, logistique")
Skill.last.photo_url = url
puts "Création de la Skill #{Skill.last.name}"
puts "Seeding internship..."

puts "Skills created"


puts "Seeding Internships"

is = Internship.new(
  starts_at: Date.new(2019, 12, 16),
  ends_at: Date.new(2019, 12, 20),
  comment: "Stage de 3ème 2019-2020",
  college: c1
  )
is.save!
is = Internship.new(
  starts_at: Date.new(2019, 12, 2),
  ends_at: Date.new(2019, 12, 6),
  comment: "Stage de 3ème 2019-2020",
  college: c2
  )
is.save!
is = Internship.new(
  starts_at: Date.new(2020, 01, 3),
  ends_at: Date.new(2020, 01, 7),
  comment: "Stage de 3ème 2019-2020",
  college: c3
  )
is.save!
is = Internship.new(
  starts_at: Date.new(2020, 01, 20),
  ends_at: Date.new(2020, 01, 24),
  comment: "Stage de 3ème 2019-2020",
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

checkpoints = [ "<p>Je me suis renseigné sur l'entreprise.</p>",
                "<p class='margin-bottom-10px'>Je postule</p><p class='font-size-14px'>Valide cette étape pour récupérer par mail les coordonnées de l'entreprise</p>",
                "<p>J'ai contacté l'entreprise et j'ai pris rendez vous.</p>"
              ]
checkpoints.each_with_index do |title, i|
  Checkpoint.create!(title: title, order: i)
end

puts "Objectives created"

puts "The seed is done"



