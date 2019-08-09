json.extract! page, :id, :name, :relative_path, :parent_path, :slug, :created_at, :updated_at
json.url page_url(page, format: :json)
