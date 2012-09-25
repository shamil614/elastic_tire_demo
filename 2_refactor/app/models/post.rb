class Post < ActiveRecord::Base
  attr_accessible :title, :body, :user_id
  belongs_to :user

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id, type: 'integer', index: :not_analyzed
    indexes :title
    indexes :body
    indexes :user_full_name, boost: 10
    indexes :user_id, type: 'integer', index: :not_analyzed
    indexes :created_at, type: 'date', index: :not_analyzed
  end

  def self.search(params)
    tire.search(page: params[:page], per_page: 3) do 
      query do 
        boolean do 
          must { string params[:query], default_operator: "AND" } if params[:query].present?
          must { range :created_at, lte: Time.zone.now }
          must { term :user_id, params[:user_id] } if params[:user_id].present?
        end
      end
      sort { by :created_at, "desc" } if params[:query].blank?
      facet "users" do
        terms :user_id
      end
    end
  end

  def to_indexed_json
    to_json(methods: [:user_full_name])
  end

  def user_full_name
    user.full_name
  end
end
