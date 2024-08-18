# == Schema Information
#
# Table name: favorite_comics
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  comic_id   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe FavoriteComic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
