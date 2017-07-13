namespace :dev do

  desc "Setup Development"
  task setup: :environment do
    images_path = Rails.root.join('public', 'system')

    puts "Executando o setup para desenvolvimento..."

    puts "Apagando imagens de public/system #{%x(rm -rf #{images_path})}"
    puts %x(rake db:migrate)
    puts %x(rake db:seed)
    puts %x(rake dev:generate_members)
    puts %x(rake dev:generate_ads)
    puts %x(rake dev:generate_comments)

    puts "Setup completado com sucesso!"
  end

#####################################################################
  desc "Cria Membros Fake"
  task generate_members: :environment do
    puts "Cadastrando MEMBROS..."

    100.times do
      Member.create!(
          email: Faker::Internet.email,
          password: "123456",
          password_confirmation: "123456"
      )
    end

    puts "Membros cadastrados com sucesso!"
  end


#####################################################################

  desc "Cria Anúncios Fake"
  task generate_ads: :environment do
    puts "Cadastrando ANÚNCIOS..."

    5.times do
      Ad.create!(
          title: Faker::Lorem.sentence([2, 3, 4, 5].sample),
          description_md: markdown_fake,
          description_short: Faker::Lorem.sentence([2, 3].sample),
          member: Member.first,
          category: Category.all.sample,
          price: "#{Random.rand(500)},#{Random.rand(99)}",
          finish_date: Date.today + Random.rand(90),
          picture: File.new(Rails.root.join('public', 'templates', 'images-for-ads', "#{Random.rand(9)}.jpg"), 'r')
      )
    end

    100.times do
      Ad.create!(
          title: Faker::Lorem.sentence([2, 3, 4, 5].sample),
          description_md: markdown_fake,
          description_short: Faker::Lorem.sentence([2, 3].sample),
          member: Member.all.sample,
          category: Category.all.sample,
          price: "#{Random.rand(500)},#{Random.rand(99)}",
          finish_date: Date.today + Random.rand(90),
          picture: File.new(Rails.root.join('public', 'templates', 'images-for-ads', "#{Random.rand(9)}.jpg"), 'r')
      )
    end

    puts "ANÚNCIOS cadastrados com sucesso!"
  end

  def markdown_fake
    %x(ruby -e "require 'doctor_ipsum'; puts DoctorIpsum::Markdown.entry")
  end

#####################################################################
  desc "Cria Comentários Fake"
  task generate_comments: :environment do
    puts "Cadastrando COMENTÁRIOS..."

    Ad.all.each do |ad|
      (Random.rand(3)).times do
        Comment.create!(
            body: Faker::Lorem.paragraph([1, 2, 3].sample),
            member: Member.all.sample,
            ad: ad
        )
      end
    end

    puts "COMENTÁRIOS cadastrados com sucesso!"
  end
end