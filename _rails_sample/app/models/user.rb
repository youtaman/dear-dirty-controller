class User
  include ActiveModel::Model

  attr_accessor :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end

  def self.find(_id)
    new(first_name: "Taro", last_name: "Yamada")
  end
end
