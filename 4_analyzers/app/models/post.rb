class Post < ActiveRecord::Base
  attr_accessible :title, :body, :user_id
  belongs_to :user

  include Tire::Model::Search
  include Tire::Model::Callbacks

  settings  analysis: {
              filter: {
                front_edge: {
                 type: "edgeNGram",
                 side: "front",
                 max_gram: 8,
                 min_gram: 4 
                }
              },
              analyzer: {
               partial_match: {
                  tokenizer: "whitespace",
                  filter: %w{asciifolding lowercase front_edge}
                },
                whole_sort: {
                  tokenizer: 'keyword',
                  filter: %w{asciifolding lowercase}
                }
              }
           } do
    mapping do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :title
      indexes :body, type: 'multi_field', fields: {
        start: {
          type: 'string', analyzer: 'partial_match', include_in_all: false
        },
        kw: {
          type: 'string', analyzer: 'snowball', include_in_all: false
        },
        sort: {
          type: 'string', analyzer: 'whole_sort', include_in_all: false
        }
      }
      indexes :user do
        indexes :full_name, boost: 10
      end
      indexes :user_id, type: 'integer', index: :not_analyzed
      indexes :created_at, type: 'date', index: :not_analyzed
    end
  end

  def self.search(params)
    tire.search(page: params[:page], per_page: 3) do 
      query do 
        boolean do 
          must { string "body.start:#{params[:query]} OR body.kw:#{params[:query]} 
                OR #{params[:query]}", default_operator: "AND" } if params[:query].present?
          must { range :created_at, lte: Time.zone.now }
          must { term :user_id, params[:user_id] } if params[:user_id].present?
        end
      end
      if params[:query].blank?
        sort { by :created_at, "desc" }
      else
        sort {by 'body.sort', 'asc' }
      end 
      facet "users" do
        terms :user_id
      end
    end
  end

  def to_indexed_json
    to_json(include: {user: { methods: [:full_name] } })
  end
end
